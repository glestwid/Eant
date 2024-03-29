﻿using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text.RegularExpressions;

namespace Valeant.Sp.UprsWeb.Data.Dynamic
{
	internal class ExpressionParser
	{
	    private struct Token
		{
			public TokenId ID;
			public string Text;
			public int Pos;
		}

	    private enum TokenId
		{
			Unknown,
			End,
			Identifier,
			StringLiteral,
			IntegerLiteral,
			RealLiteral,
			Exclamation,
			Percent,
			Amphersand,
			OpenParen,
			CloseParen,
			Asterisk,
			Plus,
			Comma,
			Minus,
			Dot,
			Slash,
			Colon,
			LessThan,
			Equal,
			GreaterThan,
			Question,
			OpenBracket,
			CloseBracket,
			Bar,
			ExclamationEqual,
			DoubleAmphersand,
			LessThanEqual,
			LessGreater,
			DoubleEqual,
			GreaterThanEqual,
			DoubleBar,
			AsType,
			IsType,
		}

	    private interface ILogicalSignatures
		{
			void F(bool x, bool y);
			void F(bool? x, bool? y);
		}

	    private interface IArithmeticSignatures
		{
			void F(int x, int y);
			void F(uint x, uint y);
			void F(long x, long y);
			void F(ulong x, ulong y);
			void F(float x, float y);
			void F(double x, double y);
			void F(decimal x, decimal y);
			void F(int? x, int? y);
			void F(uint? x, uint? y);
			void F(long? x, long? y);
			void F(ulong? x, ulong? y);
			void F(float? x, float? y);
			void F(double? x, double? y);
			void F(decimal? x, decimal? y);
		}

	    private interface IRelationalSignatures : IArithmeticSignatures
		{
			void F(string x, string y);
			void F(char x, char y);
			void F(DateTime x, DateTime y);
			void F(TimeSpan x, TimeSpan y);
			void F(char? x, char? y);
			void F(DateTime? x, DateTime? y);
			void F(TimeSpan? x, TimeSpan? y);
		}

	    private interface IEqualitySignatures : IRelationalSignatures
		{
			void F(bool x, bool y);
			void F(bool? x, bool? y);
		}

	    private interface IAddSignatures : IArithmeticSignatures
		{
			void F(DateTime x, TimeSpan y);
			void F(TimeSpan x, TimeSpan y);
			void F(DateTime? x, TimeSpan? y);
			void F(TimeSpan? x, TimeSpan? y);
		}

	    private interface ISubtractSignatures : IAddSignatures
		{
			void F(DateTime x, DateTime y);
			void F(DateTime? x, DateTime? y);
		}

	    private interface INegationSignatures
		{
			void F(int x);
			void F(long x);
			void F(float x);
			void F(double x);
			void F(decimal x);
			void F(int? x);
			void F(long? x);
			void F(float? x);
			void F(double? x);
			void F(decimal? x);
		}

	    private interface INotSignatures
		{
			void F(bool x);
			void F(bool? x);
		}

	    private interface IEnumerableSignatures
		{
			void Where(bool predicate);
            void FirstOrDefault(bool predicate);
            void FirstOrDefault();
			void Any();
			void Any(bool predicate);
			void All(bool predicate);
			void Count();
			void Count(bool predicate);
			void Min(object selector);
			void Max(object selector);
			void Sum(int selector);
			void Sum(int? selector);
			void Sum(long selector);
			void Sum(long? selector);
			void Sum(float selector);
			void Sum(float? selector);
			void Sum(double selector);
			void Sum(double? selector);
			void Sum(decimal selector);
			void Sum(decimal? selector);
			void Average(int selector);
			void Average(int? selector);
			void Average(long selector);
			void Average(long? selector);
			void Average(float selector);
			void Average(float? selector);
			void Average(double selector);
			void Average(double? selector);
			void Average(decimal selector);
			void Average(decimal? selector);
			void Contains(int value);
			void Contains(int? value);
			void Contains(long value);
			void Contains(long? value);
			void Contains(float value);
			void Contains(float? value);
			void Contains(double value);
			void Contains(double? value);
			void Contains(decimal value);
			void Contains(decimal? value);
			void Contains(string value);
		}

	    private static readonly Type[] PredefinedTypes = {
            typeof(object),
            typeof(bool),
            typeof(char),
            typeof(string),
            typeof(sbyte),
            typeof(byte),
            typeof(short),
            typeof(ushort),
            typeof(int),
            typeof(uint),
            typeof(long),
            typeof(ulong),
            typeof(float),
            typeof(double),
            typeof(decimal),
            typeof(DateTime),
            typeof(TimeSpan),
            typeof(Guid),
            typeof(Math),
            typeof(Convert)
        };

		private static readonly Expression TrueLiteral = Expression.Constant(true);
		private static readonly Expression FalseLiteral = Expression.Constant(false);
		private static readonly Expression NullLiteral = Expression.Constant(null);

		private static readonly string KeywordIt = "it";
		private static readonly string KeywordIif = "iif";
		private static readonly string KeywordNew = "new";
		private static readonly Regex KeywordParentItParser = new Regex(@"it_(?<idx>\d+)", RegexOptions.Compiled | RegexOptions.ExplicitCapture);

		private readonly Dictionary<string, object> _keywords;

		private Dictionary<string, object> _symbols;
		private IDictionary<string, object> _externals;
		private Dictionary<Expression, string> _literals;

		private readonly Stack<ParameterExpression> _itStack = new Stack<ParameterExpression>();
		private ParameterExpression It { get { return _itStack.Any() ? _itStack.Peek() : null; } }

		private string _text;
		private int _textPos;
		private int _textLen;
		private char _ch;
		private Token _token;

		private ICollection<Type> _allowedTypes;

		public ExpressionParser(ParameterExpression[] parameters, string expression, object[] values, ICollection<Type> additionalAllowedTypes = null)
		{
			if (additionalAllowedTypes == null || additionalAllowedTypes.Count == 0)
			{
				_allowedTypes = PredefinedTypes;
			}
			else
			{
				_allowedTypes = new HashSet<Type>(PredefinedTypes.Concat(additionalAllowedTypes));
			}

			if (expression == null)
				throw new ArgumentNullException("expression");
			
			_keywords = CreateKeywords();

			_symbols = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
			_literals = new Dictionary<Expression, string>();
			if (parameters != null)
			{
				ProcessParameters(parameters);
			}
			if (values != null)
			{
				ProcessValues(values);
			}
			_text = expression;
			_textLen = _text.Length;
			SetTextPos(0);
			NextToken();
		}

		private void ProcessParameters(ParameterExpression[] parameters)
		{
			foreach (var pe in parameters)
			{
				if (!string.IsNullOrEmpty(pe.Name))
				{
					AddSymbol(pe.Name, pe);
				}
			}

			if (parameters.Length == 1 && string.IsNullOrEmpty(parameters[0].Name))
			{
				_itStack.Push(parameters[0]);
			}
		}

		private void ProcessValues(object[] values)
		{
			for (var i = 0; i < values.Length; i++)
			{
				var value = values[i];
				if (i == values.Length - 1 && value is IDictionary<string, object>)
				{
					_externals = (IDictionary<string, object>)value;
				}
				else
				{
					AddSymbol("@" + i.ToString(CultureInfo.InvariantCulture), value);
				}
			}
		}

		private void AddSymbol(string name, object value)
		{
			if (_symbols.ContainsKey(name))
				throw ParseError(Res.DuplicateIdentifier, name);
			_symbols.Add(name, value);
		}

		public Expression Parse(Type resultType)
		{
			var exprPos = _token.Pos;
			var expr = ParseExpression();
			if (resultType != null)
				if ((expr = PromoteExpression(expr, resultType, true)) == null)
					throw ParseError(exprPos, Res.ExpressionTypeMismatch, GetTypeName(resultType));
			ValidateToken(TokenId.End, Res.SyntaxError);
			return expr;
		}

#pragma warning disable 0219
		public IEnumerable<DynamicOrdering> ParseOrdering()
		{
			var orderings = new List<DynamicOrdering>();
			while (true)
			{
				var expr = ParseExpression();
				var ascending = true;
				if (TokenIdentifierIs("asc") || TokenIdentifierIs("ascending"))
				{
					NextToken();
				}
				else if (TokenIdentifierIs("desc") || TokenIdentifierIs("descending"))
				{
					NextToken();
					ascending = false;
				}
				orderings.Add(new DynamicOrdering { Selector = expr, Parameter = It, Ascending = ascending });
				if (_token.ID != TokenId.Comma)
					break;
				NextToken();
			}
			ValidateToken(TokenId.End, Res.SyntaxError);
			return orderings;
		}
#pragma warning restore 0219

		// ?: operator
		private Expression ParseExpression()
		{
			var errorPos = _token.Pos;
			var expr = ParseLogicalOr();
			if (_token.ID == TokenId.Question)
			{
				NextToken();
				var expr1 = ParseExpression();
				ValidateToken(TokenId.Colon, Res.ColonExpected);
				NextToken();
				var expr2 = ParseExpression();
				expr = GenerateConditional(expr, expr1, expr2, errorPos);
			}
			return expr;
		}

		private Type ParseTypeName()
		{
			var typeNameParts = new List<string>();
			do
			{
				NextToken();
				if (_token.ID != TokenId.Identifier)
				{
					throw ParseError(_token.Pos, "Expected identifier");
				}

				typeNameParts.Add(_token.Text);
				NextToken();
			} while (_token.ID == TokenId.Dot);

			var type = GetType(string.Join(".", typeNameParts));
			return type;
		}

		private Type GetType(string name)
		{
			Type type = null;
			object keyword;
			if (_keywords.TryGetValue(name, out keyword))
			{
				type = keyword as Type;
			}

			if (type == null)
			{
				var assemblies = AppDomain.CurrentDomain.GetAssemblies();

				type = assemblies
					.Select(a => a.GetType(name, throwOnError: false))
					.FirstOrDefault(t => t != null);

				if (type == null)
				{
					throw new TypeLoadException(string.Format("Could not load type '{0}' from any of the following assemblies:{1}", name, string.Join("", assemblies.Select(a => "\n  - " + a.FullName))));
				}
			}

			return type;
		}
		// ||, or operator
		private Expression ParseLogicalOr()
		{
			var left = ParseLogicalAnd();
			while (_token.ID == TokenId.DoubleBar || TokenIdentifierIs("or"))
			{
				var op = _token;
				NextToken();
				var right = ParseLogicalAnd();
				CheckAndPromoteOperands(typeof(ILogicalSignatures), op.Text, ref left, ref right, op.Pos);
				left = Expression.OrElse(left, right);
			}
			return left;
		}

		// &&, and operator
		private Expression ParseLogicalAnd()
		{
			var left = ParseComparison();
			while (_token.ID == TokenId.DoubleAmphersand || TokenIdentifierIs("and"))
			{
				var op = _token;
				NextToken();
				var right = ParseComparison();
				CheckAndPromoteOperands(typeof(ILogicalSignatures), op.Text, ref left, ref right, op.Pos);
				left = Expression.AndAlso(left, right);
			}
			return left;
		}

		// =, ==, !=, <>, >, >=, <, <=, as, is operators
		private Expression ParseComparison()
		{
			var left = ParseAdditive();

			while (_token.ID == TokenId.Equal || _token.ID == TokenId.DoubleEqual ||
				_token.ID == TokenId.ExclamationEqual || _token.ID == TokenId.LessGreater ||
				_token.ID == TokenId.GreaterThan || _token.ID == TokenId.GreaterThanEqual ||
				_token.ID == TokenId.LessThan || _token.ID == TokenId.LessThanEqual ||
				_token.ID == TokenId.AsType || _token.ID == TokenId.IsType)
			{
				var op = _token;

				if (_token.ID == TokenId.AsType)
				{
					var type = ParseTypeName();
					left = Expression.TypeAs(left, type);
				}
				else if (_token.ID == TokenId.IsType)
				{
					var type = ParseTypeName();
					left = Expression.TypeIs(left, type);
				}
				else
				{
					NextToken();
					var right = ParseAdditive();
					var isEquality = op.ID == TokenId.Equal || op.ID == TokenId.DoubleEqual ||
						op.ID == TokenId.ExclamationEqual || op.ID == TokenId.LessGreater;
					if (isEquality && !left.Type.IsValueType && !right.Type.IsValueType)
					{
						if (left.Type != right.Type)
						{
							if (left.Type.IsAssignableFrom(right.Type))
							{
								right = Expression.Convert(right, left.Type);
							}
							else if (right.Type.IsAssignableFrom(left.Type))
							{
								left = Expression.Convert(left, right.Type);
							}
							else
							{
								throw IncompatibleOperandsError(op.Text, left, right, op.Pos);
							}
						}
					}
					else if (IsEnumType(left.Type) || IsEnumType(right.Type))
					{
						if (left.Type != right.Type)
						{
							Expression e;
							if ((e = PromoteExpression(right, left.Type, true)) != null)
							{
								right = e;
							}
							else if ((e = PromoteExpression(left, right.Type, true)) != null)
							{
								left = e;
							}
							else
							{
								throw IncompatibleOperandsError(op.Text, left, right, op.Pos);
							}
						}
					}
					else
					{
						CheckAndPromoteOperands(isEquality ? typeof(IEqualitySignatures) : typeof(IRelationalSignatures),
							op.Text, ref left, ref right, op.Pos);
					}
					switch (op.ID)
					{
						case TokenId.Equal:
						case TokenId.DoubleEqual:
							left = GenerateEqual(left, right);
							break;
						case TokenId.ExclamationEqual:
						case TokenId.LessGreater:
							left = GenerateNotEqual(left, right);
							break;
						case TokenId.GreaterThan:
							left = GenerateGreaterThan(left, right);
							break;
						case TokenId.GreaterThanEqual:
							left = GenerateGreaterThanEqual(left, right);
							break;
						case TokenId.LessThan:
							left = GenerateLessThan(left, right);
							break;
						case TokenId.LessThanEqual:
							left = GenerateLessThanEqual(left, right);
							break;
					}
				}
			}
			return left;
		}

		// +, -, & operators
		private Expression ParseAdditive()
		{
			var left = ParseMultiplicative();
			while (_token.ID == TokenId.Plus || _token.ID == TokenId.Minus ||
				_token.ID == TokenId.Amphersand)
			{
				var op = _token;
				NextToken();
				var right = ParseMultiplicative();
				switch (op.ID)
				{
					case TokenId.Plus:
						if (left.Type == typeof(string) || right.Type == typeof(string))
							goto case TokenId.Amphersand;
						CheckAndPromoteOperands(typeof(IAddSignatures), op.Text, ref left, ref right, op.Pos);
						left = GenerateAdd(left, right);
						break;
					case TokenId.Minus:
						CheckAndPromoteOperands(typeof(ISubtractSignatures), op.Text, ref left, ref right, op.Pos);
						left = GenerateSubtract(left, right);
						break;
					case TokenId.Amphersand:
						left = GenerateStringConcat(left, right);
						break;
				}
			}
			return left;
		}

		// *, /, %, mod operators
		private Expression ParseMultiplicative()
		{
			var left = ParseUnary();
			while (_token.ID == TokenId.Asterisk || _token.ID == TokenId.Slash ||
				_token.ID == TokenId.Percent || TokenIdentifierIs("mod"))
			{
				var op = _token;
				NextToken();
				var right = ParseUnary();
				CheckAndPromoteOperands(typeof(IArithmeticSignatures), op.Text, ref left, ref right, op.Pos);
				switch (op.ID)
				{
					case TokenId.Asterisk:
						left = Expression.Multiply(left, right);
						break;
					case TokenId.Slash:
						left = Expression.Divide(left, right);
						break;
					case TokenId.Percent:
					case TokenId.Identifier:
						left = Expression.Modulo(left, right);
						break;
				}
			}
			return left;
		}

		// -, !, not unary operators
		private Expression ParseUnary()
		{
			if (_token.ID == TokenId.Minus || _token.ID == TokenId.Exclamation ||
				TokenIdentifierIs("not"))
			{
				var op = _token;
				NextToken();
				if (op.ID == TokenId.Minus && (_token.ID == TokenId.IntegerLiteral ||
					_token.ID == TokenId.RealLiteral))
				{
					_token.Text = "-" + _token.Text;
					_token.Pos = op.Pos;
					return ParsePrimary();
				}
				var expr = ParseUnary();
				if (op.ID == TokenId.Minus)
				{
					CheckAndPromoteOperand(typeof(INegationSignatures), op.Text, ref expr, op.Pos);
					expr = Expression.Negate(expr);
				}
				else
				{
					CheckAndPromoteOperand(typeof(INotSignatures), op.Text, ref expr, op.Pos);
					expr = Expression.Not(expr);
				}
				return expr;
			}
			return ParsePrimary();
		}

		private Expression ParsePrimary()
		{
			var expr = ParsePrimaryStart();
			while (true)
			{
				if (_token.ID == TokenId.Dot)
				{
					NextToken();
					expr = ParseMemberAccess(null, expr);
				}
				else if (_token.ID == TokenId.OpenBracket)
				{
					expr = ParseElementAccess(expr);
				}
				else
				{
					break;
				}
			}
			return expr;
		}

		private Expression ParsePrimaryStart()
		{
			switch (_token.ID)
			{
				case TokenId.Identifier:
					return ParseIdentifier();
				case TokenId.StringLiteral:
					return ParseStringLiteral();
				case TokenId.IntegerLiteral:
					return ParseIntegerLiteral();
				case TokenId.RealLiteral:
					return ParseRealLiteral();
				case TokenId.OpenParen:
					return ParseParenExpression();
				default:
					throw ParseError(Res.ExpressionExpected);
			}
		}

		private Expression ParseStringLiteral()
		{
			ValidateToken(TokenId.StringLiteral);
			var quote = _token.Text[0];
			var s = _token.Text.Substring(1, _token.Text.Length - 2);
			var start = 0;
			while (true)
			{
				var i = s.IndexOf(quote, start);
				if (i < 0)
					break;
				s = s.Remove(i, 1);
				start = i + 1;
			}
			if (quote == '\'')
			{
				if (s.Length != 1)
					throw ParseError(Res.InvalidCharacterLiteral);
				NextToken();
				return CreateLiteral(s[0], s);
			}
			NextToken();
			return CreateLiteral(s, s);
		}

		private Expression ParseIntegerLiteral()
		{
			ValidateToken(TokenId.IntegerLiteral);
			var text = _token.Text;
			if (text[0] != '-')
			{
				ulong value;
				if (!ulong.TryParse(text, out value))
					throw ParseError(Res.InvalidIntegerLiteral, text);
				NextToken();
				if (value <= int.MaxValue)
					return CreateLiteral((int)value, text);
				if (value <= uint.MaxValue)
					return CreateLiteral((uint)value, text);
				return value <= long.MaxValue ? CreateLiteral((long)value, text) : CreateLiteral(value, text);
			}
			else
			{
				long value;
				if (!long.TryParse(text, out value))
					throw ParseError(Res.InvalidIntegerLiteral, text);
				NextToken();
				if (value >= int.MinValue && value <= int.MaxValue)
					return CreateLiteral((int)value, text);
				return CreateLiteral(value, text);
			}
		}

		private Expression ParseRealLiteral()
		{
			ValidateToken(TokenId.RealLiteral);
			var text = _token.Text;
			object value = null;
			var last = text[text.Length - 1];
			if (last == 'F' || last == 'f')
			{
				float f;
				if (float.TryParse(text.Substring(0, text.Length - 1), out f))
					value = f;
			}
			else
			{
				double d;
				if (double.TryParse(text, out d))
					value = d;
			}
			if (value == null)
				throw ParseError(Res.InvalidRealLiteral, text);
			NextToken();
			return CreateLiteral(value, text);
		}

		private Expression CreateLiteral(object value, string text)
		{
			var expr = Expression.Constant(value);
			_literals.Add(expr, text);
			return expr;
		}

		private Expression ParseParenExpression()
		{
			ValidateToken(TokenId.OpenParen, Res.OpenParenExpected);
			NextToken();
			var e = ParseExpression();
			ValidateToken(TokenId.CloseParen, Res.CloseParenOrOperatorExpected);
			NextToken();
			return e;
		}

		private Expression ParseIdentifier()
		{
			ValidateToken(TokenId.Identifier);
			object value;

			var match = KeywordParentItParser.Match(_token.Text);
			if (match.Success)
			{
				return ParseParentIt(match);
			}

			if (_keywords.TryGetValue(_token.Text, out value))
			{
				if (value is Type)
					return ParseTypeAccess((Type)value);
				if (value == KeywordIt)
					return ParseIt();
				if (value == KeywordIif)
					return ParseIif();
				if (value == KeywordNew)
					return ParseNew();
				NextToken();
				return (Expression)value;
			}
			if (_symbols.TryGetValue(_token.Text, out value) ||
				_externals != null && _externals.TryGetValue(_token.Text, out value))
			{
				var expr = value as Expression;
				if (expr == null)
				{
					expr = Expression.Constant(value);
				}
				else
				{
					var lambda = expr as LambdaExpression;
					if (lambda != null)
						return ParseLambdaInvocation(lambda);
				}
				NextToken();
				return expr;
			}
			if (It != null)
				return ParseMemberAccess(null, It);
			throw ParseError(Res.UnknownIdentifier, _token.Text);
		}

		private Expression ParseParentIt(Match match)
		{
			var idx = int.Parse(match.Groups["idx"].Value, CultureInfo.InvariantCulture);
			var parentIt = _itStack.Skip(idx).FirstOrDefault();
			if (parentIt == null)
			{
				throw ParseError(Res.NoItInScope);
			}

			NextToken();
			return parentIt;
		}

		private Expression ParseIt()
		{
			if (It == null)
				throw ParseError(Res.NoItInScope);
			NextToken();
			return It;
		}

		private Expression ParseIif()
		{
			var errorPos = _token.Pos;
			NextToken();
			var args = ParseArgumentList();
			if (args.Length != 3)
				throw ParseError(errorPos, Res.IifRequiresThreeArgs);
			return GenerateConditional(args[0], args[1], args[2], errorPos);
		}

		private Expression GenerateConditional(Expression test, Expression expr1, Expression expr2, int errorPos)
		{
			if (test.Type != typeof(bool))
				throw ParseError(errorPos, Res.FirstExprMustBeBool);
			if (expr1.Type != expr2.Type)
			{
				var expr1As2 = expr2 != NullLiteral ? PromoteExpression(expr1, expr2.Type, true) : null;
				var expr2As1 = expr1 != NullLiteral ? PromoteExpression(expr2, expr1.Type, true) : null;
				if (expr1As2 != null && expr2As1 == null)
				{
					expr1 = expr1As2;
				}
				else if (expr2As1 != null && expr1As2 == null)
				{
					expr2 = expr2As1;
				}
				else
				{
					var type1 = expr1 != NullLiteral ? expr1.Type.Name : "null";
					var type2 = expr2 != NullLiteral ? expr2.Type.Name : "null";
					if (expr1As2 != null && expr2As1 != null)
						throw ParseError(errorPos, Res.BothTypesConvertToOther, type1, type2);
					throw ParseError(errorPos, Res.NeitherTypeConvertsToOther, type1, type2);
				}
			}
			return Expression.Condition(test, expr1, expr2);
		}

		private Expression ParseNew()
		{
			NextToken();
			ValidateToken(TokenId.OpenParen, Res.OpenParenExpected);
			NextToken();
			var properties = new List<DynamicProperty>();
			var expressions = new List<Expression>();
			while (true)
			{
				var exprPos = _token.Pos;
				var expr = ParseExpression();
				string propName;
				if (TokenIdentifierIs("alias"))
				{
					NextToken();
					propName = GetIdentifier();
					NextToken();
				}
				else
				{
					var me = expr as MemberExpression;
					if (me == null)
						throw ParseError(exprPos, Res.MissingAsClause);
					propName = me.Member.Name;
				}
				expressions.Add(expr);
				properties.Add(new DynamicProperty(propName, expr.Type));
				if (_token.ID != TokenId.Comma)
					break;
				NextToken();
			}
			ValidateToken(TokenId.CloseParen, Res.CloseParenOrCommaExpected);
			NextToken();
			var type = DynamicExpression.CreateClass(properties);
			var bindings = new MemberBinding[properties.Count];
			for (var i = 0; i < bindings.Length; i++)
				bindings[i] = Expression.Bind(type.GetProperty(properties[i].Name), expressions[i]);
			return Expression.MemberInit(Expression.New(type), bindings);
		}

		private Expression ParseLambdaInvocation(LambdaExpression lambda)
		{
			var errorPos = _token.Pos;
			NextToken();
			var args = ParseArgumentList();
			MethodBase method;
			if (FindMethod(lambda.Type, "Invoke", false, args, out method) != 1)
				throw ParseError(errorPos, Res.ArgsIncompatibleWithLambda);
			return Expression.Invoke(lambda, args);
		}

		private Expression ParseTypeAccess(Type type)
		{
			var errorPos = _token.Pos;
			NextToken();
			if (_token.ID == TokenId.Question)
			{
				if (!type.IsValueType || IsNullableType(type))
					throw ParseError(errorPos, Res.TypeHasNoNullableForm, GetTypeName(type));
				type = typeof(Nullable<>).MakeGenericType(type);
				NextToken();
			}
			if (_token.ID == TokenId.OpenParen)
			{
				var args = ParseArgumentList();
				MethodBase method;
				switch (FindBestMethod(type.GetConstructors(), args, out method))
				{
					case 0:
						if (args.Length == 1)
							return GenerateConversion(args[0], type, errorPos);
						throw ParseError(errorPos, Res.NoMatchingConstructor, GetTypeName(type));
					case 1:
						return Expression.New((ConstructorInfo)method, args);
					default:
						throw ParseError(errorPos, Res.AmbiguousConstructorInvocation, GetTypeName(type));
				}
			}
			ValidateToken(TokenId.Dot, Res.DotOrOpenParenExpected);
			NextToken();
			return ParseMemberAccess(type, null);
		}

		private Expression GenerateConversion(Expression expr, Type type, int errorPos)
		{
			var exprType = expr.Type;
			if (exprType == type)
				return expr;
			if (exprType.IsValueType && type.IsValueType)
			{
				if ((IsNullableType(exprType) || IsNullableType(type)) &&
					GetNonNullableType(exprType) == GetNonNullableType(type))
					return Expression.Convert(expr, type);
				if ((IsNumericType(exprType) || IsEnumType(exprType)) &&
					(IsNumericType(type)) || IsEnumType(type))
					return Expression.ConvertChecked(expr, type);
			}
			if (exprType.IsAssignableFrom(type) || type.IsAssignableFrom(exprType) ||
				exprType.IsInterface || type.IsInterface)
				return Expression.Convert(expr, type);
			throw ParseError(errorPos, Res.CannotConvertValue,
				GetTypeName(exprType), GetTypeName(type));
		}

		private Expression ParseMemberAccess(Type type, Expression instance)
		{
			if (instance != null)
				type = instance.Type;
			var errorPos = _token.Pos;
			var id = GetIdentifier();
			NextToken();
			if (_token.ID == TokenId.OpenParen)
			{
				if (instance != null && type != typeof(string))
				{
					var enumerableType = FindGenericType(typeof(IEnumerable<>), type);
					if (enumerableType != null)
					{
						var elementType = enumerableType.GetGenericArguments()[0];
						return ParseAggregate(instance, elementType, id, errorPos);
					}
				}
				var args = ParseArgumentList();
				MethodBase mb;
				switch (FindMethod(type, id, instance == null, args, out mb))
				{
					case 0:
						throw ParseError(errorPos, Res.NoApplicableMethod,
							id, GetTypeName(type));
					case 1:
						var method = (MethodInfo)mb;
						if (!IsPredefinedType(method.DeclaringType))
							throw ParseError(errorPos, Res.MethodsAreInaccessible, GetTypeName(method.DeclaringType));
						if (method.ReturnType == typeof(void))
							throw ParseError(errorPos, Res.MethodIsVoid,
								id, GetTypeName(method.DeclaringType));
						return Expression.Call(instance, method, args);
					default:
						throw ParseError(errorPos, Res.AmbiguousMethodInvocation,
							id, GetTypeName(type));
				}
			}
			else
			{
				var member = FindPropertyOrField(type, id, instance == null);
				if (member == null)
					throw ParseError(errorPos, Res.UnknownPropertyOrField,
						id, GetTypeName(type));
				return member is PropertyInfo ?
					Expression.Property(instance, (PropertyInfo)member) :
					Expression.Field(instance, (FieldInfo)member);
			}
		}

		private static Type FindGenericType(Type generic, Type type)
		{
			while (type != null && type != typeof(object))
			{
				if (type.IsGenericType && type.GetGenericTypeDefinition() == generic)
					return type;
				if (generic.IsInterface)
				{
					foreach (var intfType in type.GetInterfaces())
					{
						var found = FindGenericType(generic, intfType);
						if (found != null)
							return found;
					}
				}
				type = type.BaseType;
			}
			return null;
		}

		private Expression ParseAggregate(Expression instance, Type elementType, string methodName, int errorPos)
		{
			_itStack.Push(Expression.Parameter(elementType, ""));
			var args = ParseArgumentList();
			var innerIt = _itStack.Pop();

			MethodBase signature;
			if (FindMethod(typeof(IEnumerableSignatures), methodName, false, args, out signature) != 1)
				throw ParseError(errorPos, Res.NoApplicableAggregate, methodName);
			Type[] typeArgs;
			if (signature.Name == "Min" || signature.Name == "Max")
			{
				typeArgs = new[] { elementType, args[0].Type };
			}
			else
			{
				typeArgs = new[] { elementType };
			}
			if (args.Length == 0)
			{
				args = new[] { instance };
			}
			else
			{
				if (signature.Name == "Contains")
				{
					args = new[] { instance, args[0] };
				}
				else
				{
					args = new[] { instance, Expression.Lambda(args[0], innerIt) };
				}
			}
			return Expression.Call(typeof(Enumerable), signature.Name, typeArgs, args);
		}

		private Expression[] ParseArgumentList()
		{
			ValidateToken(TokenId.OpenParen, Res.OpenParenExpected);
			NextToken();
			var args = _token.ID != TokenId.CloseParen ? ParseArguments() : new Expression[0];
			ValidateToken(TokenId.CloseParen, Res.CloseParenOrCommaExpected);
			NextToken();
			return args;
		}

		private Expression[] ParseArguments()
		{
			var argList = new List<Expression>();
			while (true)
			{
				argList.Add(ParseExpression());
				if (_token.ID != TokenId.Comma)
					break;
				NextToken();
			}
			return argList.ToArray();
		}

		private Expression ParseElementAccess(Expression expr)
		{
			var errorPos = _token.Pos;
			ValidateToken(TokenId.OpenBracket, Res.OpenParenExpected);
			NextToken();
			var args = ParseArguments();
			ValidateToken(TokenId.CloseBracket, Res.CloseBracketOrCommaExpected);
			NextToken();
			if (expr.Type.IsArray)
			{
				if (expr.Type.GetArrayRank() != 1 || args.Length != 1)
					throw ParseError(errorPos, Res.CannotIndexMultiDimArray);
				var index = PromoteExpression(args[0], typeof(int), true);
				if (index == null)
					throw ParseError(errorPos, Res.InvalidIndex);
				return Expression.ArrayIndex(expr, index);
			}
			else
			{
				MethodBase mb;
				switch (FindIndexer(expr.Type, args, out mb))
				{
					case 0:
						throw ParseError(errorPos, Res.NoApplicableIndexer,
							GetTypeName(expr.Type));
					case 1:
						return Expression.Call(expr, (MethodInfo)mb, args);
					default:
						throw ParseError(errorPos, Res.AmbiguousIndexerInvocation,
							GetTypeName(expr.Type));
				}
			}
		}

		private bool IsPredefinedType(Type type)
		{
			foreach (var t in _allowedTypes) if (t == type)
					return true;
			return false;
		}

		private static bool IsNullableType(Type type)
		{
			return type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>);
		}

		private static Type GetNonNullableType(Type type)
		{
			return IsNullableType(type) ? type.GetGenericArguments()[0] : type;
		}

		private static string GetTypeName(Type type)
		{
			var baseType = GetNonNullableType(type);
			var s = baseType.Name;
			if (type != baseType)
				s += '?';
			return s;
		}

		private static bool IsNumericType(Type type)
		{
			return GetNumericTypeKind(type) != 0;
		}

		private static bool IsSignedIntegralType(Type type)
		{
			return GetNumericTypeKind(type) == 2;
		}

		private static bool IsUnsignedIntegralType(Type type)
		{
			return GetNumericTypeKind(type) == 3;
		}

		private static int GetNumericTypeKind(Type type)
		{
			type = GetNonNullableType(type);
			if (type.IsEnum)
				return 0;
			switch (Type.GetTypeCode(type))
			{
				case TypeCode.Char:
				case TypeCode.Single:
				case TypeCode.Double:
				case TypeCode.Decimal:
					return 1;
				case TypeCode.SByte:
				case TypeCode.Int16:
				case TypeCode.Int32:
				case TypeCode.Int64:
					return 2;
				case TypeCode.Byte:
				case TypeCode.UInt16:
				case TypeCode.UInt32:
				case TypeCode.UInt64:
					return 3;
				default:
					return 0;
			}
		}

		private static bool IsEnumType(Type type)
		{
			return GetNonNullableType(type).IsEnum;
		}

		private void CheckAndPromoteOperand(Type signatures, string opName, ref Expression expr, int errorPos)
		{
			var args = new[] { expr };
			MethodBase method;
			if (FindMethod(signatures, "F", false, args, out method) != 1)
				throw ParseError(errorPos, Res.IncompatibleOperand,
					opName, GetTypeName(args[0].Type));
			expr = args[0];
		}

		private void CheckAndPromoteOperands(Type signatures, string opName, ref Expression left, ref Expression right, int errorPos)
		{
			var args = new[] { left, right };
			MethodBase method;
			if (FindMethod(signatures, "F", false, args, out method) != 1)
				throw IncompatibleOperandsError(opName, left, right, errorPos);
			left = args[0];
			right = args[1];
		}

		private Exception IncompatibleOperandsError(string opName, Expression left, Expression right, int pos)
		{
			return ParseError(pos, Res.IncompatibleOperands,
				opName, GetTypeName(left.Type), GetTypeName(right.Type));
		}

		private MemberInfo FindPropertyOrField(Type type, string memberName, bool staticAccess)
		{
			var flags = BindingFlags.Public | BindingFlags.DeclaredOnly |
				(staticAccess ? BindingFlags.Static : BindingFlags.Instance);
			foreach (var t in SelfAndBaseTypes(type))
			{
				var members = t.FindMembers(MemberTypes.Property | MemberTypes.Field,
					flags, Type.FilterNameIgnoreCase, memberName);
				if (members.Length != 0)
					return members[0];
			}
			return null;
		}

		private int FindMethod(Type type, string methodName, bool staticAccess, Expression[] args, out MethodBase method)
		{
			var flags = BindingFlags.Public | BindingFlags.DeclaredOnly |
				(staticAccess ? BindingFlags.Static : BindingFlags.Instance);
			foreach (var t in SelfAndBaseTypes(type))
			{
				var members = t.FindMembers(MemberTypes.Method,
					flags, Type.FilterNameIgnoreCase, methodName);
				var count = FindBestMethod(members.Cast<MethodBase>(), args, out method);
				if (count != 0)
					return count;
			}
			method = null;
			return 0;
		}

		private int FindIndexer(Type type, Expression[] args, out MethodBase method)
		{
			foreach (var t in SelfAndBaseTypes(type))
			{
				var members = t.GetDefaultMembers();
				if (members.Length != 0)
				{
					var methods = members.
						OfType<PropertyInfo>().
						Select(p => (MethodBase)p.GetGetMethod()).
						Where(m => m != null);
					var count = FindBestMethod(methods, args, out method);
					if (count != 0)
						return count;
				}
			}
			method = null;
			return 0;
		}

		private static IEnumerable<Type> SelfAndBaseTypes(Type type)
		{
			if (type.IsInterface)
			{
				var types = new List<Type>();
				AddInterface(types, type);
				return types;
			}
			return SelfAndBaseClasses(type);
		}

		private static IEnumerable<Type> SelfAndBaseClasses(Type type)
		{
			while (type != null)
			{
				yield return type;
				type = type.BaseType;
			}
		}

		private static void AddInterface(List<Type> types, Type type)
		{
			if (!types.Contains(type))
			{
				types.Add(type);
				foreach (var t in type.GetInterfaces())
					AddInterface(types, t);
			}
		}

		private class MethodData
		{
			public MethodBase MethodBase;
			public ParameterInfo[] Parameters;
			public Expression[] Args;
		}

		private int FindBestMethod(IEnumerable<MethodBase> methods, Expression[] args, out MethodBase method)
		{
			var applicable = methods.
				Select(m => new MethodData { MethodBase = m, Parameters = m.GetParameters() }).
				Where(m => IsApplicable(m, args)).
				ToArray();
			if (applicable.Length > 1)
			{
				applicable = applicable.
					Where(m => applicable.All(n => m == n || IsBetterThan(args, m, n))).
					ToArray();
			}
			if (applicable.Length == 1)
			{
				var md = applicable[0];
				for (var i = 0; i < args.Length; i++)
					args[i] = md.Args[i];
				method = md.MethodBase;
			}
			else
			{
				method = null;
			}
			return applicable.Length;
		}

		private bool IsApplicable(MethodData method, Expression[] args)
		{
			if (method.Parameters.Length != args.Length)
				return false;
			var promotedArgs = new Expression[args.Length];
			for (var i = 0; i < args.Length; i++)
			{
				var pi = method.Parameters[i];
				if (pi.IsOut)
					return false;
				var promoted = PromoteExpression(args[i], pi.ParameterType, false);
				if (promoted == null)
					return false;
				promotedArgs[i] = promoted;
			}
			method.Args = promotedArgs;
			return true;
		}

		private Expression PromoteExpression(Expression expr, Type type, bool exact)
		{
			if (expr.Type == type)
				return expr;
			if (expr is ConstantExpression)
			{
				var ce = (ConstantExpression)expr;
				if (ce == NullLiteral)
				{
					if (!type.IsValueType || IsNullableType(type))
						return Expression.Constant(null, type);
				}
				else
				{
					string text;
					if (_literals.TryGetValue(ce, out text))
					{
						var target = GetNonNullableType(type);
						object value = null;
						switch (Type.GetTypeCode(ce.Type))
						{
							case TypeCode.Int32:
							case TypeCode.UInt32:
							case TypeCode.Int64:
							case TypeCode.UInt64:
								value = ParseNumber(text, target);
								break;
							case TypeCode.Double:
								if (target == typeof(decimal))
									value = ParseNumber(text, target);
								break;
							case TypeCode.String:
								value = ParseEnum(text, target);
								break;
						}
						if (value != null)
							return Expression.Constant(value, type);
					}
				}
			}
			if (IsCompatibleWith(expr.Type, type))
			{
				if (type.IsValueType || exact)
					return Expression.Convert(expr, type);
				return expr;
			}
			return null;
		}

		private static object ParseNumber(string text, Type type)
		{
			switch (Type.GetTypeCode(GetNonNullableType(type)))
			{
				case TypeCode.SByte:
					sbyte sb;
					if (sbyte.TryParse(text, out sb))
						return sb;
					break;
				case TypeCode.Byte:
					byte b;
					if (byte.TryParse(text, out b))
						return b;
					break;
				case TypeCode.Int16:
					short s;
					if (short.TryParse(text, out s))
						return s;
					break;
				case TypeCode.UInt16:
					ushort us;
					if (ushort.TryParse(text, out us))
						return us;
					break;
				case TypeCode.Int32:
					int i;
					if (int.TryParse(text, out i))
						return i;
					break;
				case TypeCode.UInt32:
					uint ui;
					if (uint.TryParse(text, out ui))
						return ui;
					break;
				case TypeCode.Int64:
					long l;
					if (long.TryParse(text, out l))
						return l;
					break;
				case TypeCode.UInt64:
					ulong ul;
					if (ulong.TryParse(text, out ul))
						return ul;
					break;
				case TypeCode.Single:
					float f;
					if (float.TryParse(text, out f))
						return f;
					break;
				case TypeCode.Double:
					double d;
					if (double.TryParse(text, out d))
						return d;
					break;
				case TypeCode.Decimal:
					decimal e;
					if (decimal.TryParse(text, out e))
						return e;
					break;
			}
			return null;
		}

		private static object ParseEnum(string name, Type type)
		{
			if (type.IsEnum)
			{
				var memberInfos = type.FindMembers(MemberTypes.Field,
					BindingFlags.Public | BindingFlags.DeclaredOnly | BindingFlags.Static,
					Type.FilterNameIgnoreCase, name);
				if (memberInfos.Length != 0)
					return ((FieldInfo)memberInfos[0]).GetValue(null);
			}
			return null;
		}

		private static bool IsCompatibleWith(Type source, Type target)
		{
			if (source == target)
				return true;
			if (!target.IsValueType)
				return target.IsAssignableFrom(source);
			var st = GetNonNullableType(source);
			var tt = GetNonNullableType(target);
			if (st != source && tt == target)
				return false;
			var sc = Type.GetTypeCode(st);
			var tc = tt.IsEnum ? TypeCode.Object : Type.GetTypeCode(tt);
			switch (sc)
			{
				case TypeCode.SByte:
					switch (tc)
					{
						case TypeCode.SByte:
						case TypeCode.Int16:
						case TypeCode.Int32:
						case TypeCode.Int64:
						case TypeCode.Single:
						case TypeCode.Double:
						case TypeCode.Decimal:
							return true;
					}
					break;
				case TypeCode.Byte:
					switch (tc)
					{
						case TypeCode.Byte:
						case TypeCode.Int16:
						case TypeCode.UInt16:
						case TypeCode.Int32:
						case TypeCode.UInt32:
						case TypeCode.Int64:
						case TypeCode.UInt64:
						case TypeCode.Single:
						case TypeCode.Double:
						case TypeCode.Decimal:
							return true;
					}
					break;
				case TypeCode.Int16:
					switch (tc)
					{
						case TypeCode.Int16:
						case TypeCode.Int32:
						case TypeCode.Int64:
						case TypeCode.Single:
						case TypeCode.Double:
						case TypeCode.Decimal:
							return true;
					}
					break;
				case TypeCode.UInt16:
					switch (tc)
					{
						case TypeCode.UInt16:
						case TypeCode.Int32:
						case TypeCode.UInt32:
						case TypeCode.Int64:
						case TypeCode.UInt64:
						case TypeCode.Single:
						case TypeCode.Double:
						case TypeCode.Decimal:
							return true;
					}
					break;
				case TypeCode.Int32:
					switch (tc)
					{
						case TypeCode.Int32:
						case TypeCode.Int64:
						case TypeCode.Single:
						case TypeCode.Double:
						case TypeCode.Decimal:
							return true;
					}
					break;
				case TypeCode.UInt32:
					switch (tc)
					{
						case TypeCode.UInt32:
						case TypeCode.Int64:
						case TypeCode.UInt64:
						case TypeCode.Single:
						case TypeCode.Double:
						case TypeCode.Decimal:
							return true;
					}
					break;
				case TypeCode.Int64:
					switch (tc)
					{
						case TypeCode.Int64:
						case TypeCode.Single:
						case TypeCode.Double:
						case TypeCode.Decimal:
							return true;
					}
					break;
				case TypeCode.UInt64:
					switch (tc)
					{
						case TypeCode.UInt64:
						case TypeCode.Single:
						case TypeCode.Double:
						case TypeCode.Decimal:
							return true;
					}
					break;
				case TypeCode.Single:
					switch (tc)
					{
						case TypeCode.Single:
						case TypeCode.Double:
							return true;
					}
					break;
				default:
					if (st == tt)
						return true;
					break;
			}
			return false;
		}

		private static bool IsBetterThan(Expression[] args, MethodData m1, MethodData m2)
		{
			var better = false;
			for (var i = 0; i < args.Length; i++)
			{
				var c = CompareConversions(args[i].Type,
					m1.Parameters[i].ParameterType,
					m2.Parameters[i].ParameterType);
				if (c < 0)
					return false;
				if (c > 0)
					better = true;
			}
			return better;
		}

		// Return 1 if s -> t1 is a better conversion than s -> t2
		// Return -1 if s -> t2 is a better conversion than s -> t1
		// Return 0 if neither conversion is better
		private static int CompareConversions(Type s, Type t1, Type t2)
		{
			if (t1 == t2)
				return 0;
			if (s == t1)
				return 1;
			if (s == t2)
				return -1;
			var t1T2 = IsCompatibleWith(t1, t2);
			var t2T1 = IsCompatibleWith(t2, t1);
			if (t1T2 && !t2T1)
				return 1;
			if (t2T1 && !t1T2)
				return -1;
			if (IsSignedIntegralType(t1) && IsUnsignedIntegralType(t2))
				return 1;
			if (IsSignedIntegralType(t2) && IsUnsignedIntegralType(t1))
				return -1;
			return 0;
		}

		private Expression GenerateEqual(Expression left, Expression right)
		{
			return Expression.Equal(left, right);
		}

		private Expression GenerateNotEqual(Expression left, Expression right)
		{
			return Expression.NotEqual(left, right);
		}

		private Expression GenerateGreaterThan(Expression left, Expression right)
		{
			if (left.Type == typeof(string))
			{
				return Expression.GreaterThan(
					GenerateStaticMethodCall("Compare", left, right),
					Expression.Constant(0)
				);
			}
			return Expression.GreaterThan(left, right);
		}

		private Expression GenerateGreaterThanEqual(Expression left, Expression right)
		{
			if (left.Type == typeof(string))
			{
				return Expression.GreaterThanOrEqual(
					GenerateStaticMethodCall("Compare", left, right),
					Expression.Constant(0)
				);
			}
			return Expression.GreaterThanOrEqual(left, right);
		}

		private Expression GenerateLessThan(Expression left, Expression right)
		{
			if (left.Type == typeof(string))
			{
				return Expression.LessThan(
					GenerateStaticMethodCall("Compare", left, right),
					Expression.Constant(0)
				);
			}
			return Expression.LessThan(left, right);
		}

		private Expression GenerateLessThanEqual(Expression left, Expression right)
		{
			if (left.Type == typeof(string))
			{
				return Expression.LessThanOrEqual(
					GenerateStaticMethodCall("Compare", left, right),
					Expression.Constant(0)
				);
			}
			return Expression.LessThanOrEqual(left, right);
		}

		private Expression GenerateAdd(Expression left, Expression right)
		{
			if (left.Type == typeof(string) && right.Type == typeof(string))
			{
				return GenerateStaticMethodCall("Concat", left, right);
			}
			return Expression.Add(left, right);
		}

		private Expression GenerateSubtract(Expression left, Expression right)
		{
			return Expression.Subtract(left, right);
		}

		private Expression GenerateStringConcat(Expression left, Expression right)
		{
			return Expression.Call(
				null,
				typeof(string).GetMethod("Concat", new[] { typeof(object), typeof(object) }),
				new[] { left, right });
		}

		private MethodInfo GetStaticMethod(string methodName, Expression left, Expression right)
		{
			return left.Type.GetMethod(methodName, new[] { left.Type, right.Type });
		}

		private Expression GenerateStaticMethodCall(string methodName, Expression left, Expression right)
		{
			return Expression.Call(null, GetStaticMethod(methodName, left, right), new[] { left, right });
		}

		private void SetTextPos(int pos)
		{
			_textPos = pos;
			_ch = _textPos < _textLen ? _text[_textPos] : '\0';
		}

		private void NextChar()
		{
			if (_textPos < _textLen)
				_textPos++;
			_ch = _textPos < _textLen ? _text[_textPos] : '\0';
		}

		private void NextToken()
		{
			while (char.IsWhiteSpace(_ch))
				NextChar();
			TokenId t;
			var tokenPos = _textPos;
			switch (_ch)
			{
				case '!':
					NextChar();
					if (_ch == '=')
					{
						NextChar();
						t = TokenId.ExclamationEqual;
					}
					else
					{
						t = TokenId.Exclamation;
					}
					break;
				case '%':
					NextChar();
					t = TokenId.Percent;
					break;
				case '&':
					NextChar();
					if (_ch == '&')
					{
						NextChar();
						t = TokenId.DoubleAmphersand;
					}
					else
					{
						t = TokenId.Amphersand;
					}
					break;
				case '(':
					NextChar();
					t = TokenId.OpenParen;
					break;
				case ')':
					NextChar();
					t = TokenId.CloseParen;
					break;
				case '*':
					NextChar();
					t = TokenId.Asterisk;
					break;
				case '+':
					NextChar();
					t = TokenId.Plus;
					break;
				case ',':
					NextChar();
					t = TokenId.Comma;
					break;
				case '-':
					NextChar();
					t = TokenId.Minus;
					break;
				case '.':
					NextChar();
					t = TokenId.Dot;
					break;
				case '/':
					NextChar();
					t = TokenId.Slash;
					break;
				case ':':
					NextChar();
					t = TokenId.Colon;
					break;
				case '<':
					NextChar();
					if (_ch == '=')
					{
						NextChar();
						t = TokenId.LessThanEqual;
					}
					else if (_ch == '>')
					{
						NextChar();
						t = TokenId.LessGreater;
					}
					else
					{
						t = TokenId.LessThan;
					}
					break;
				case '=':
					NextChar();
					if (_ch == '=')
					{
						NextChar();
						t = TokenId.DoubleEqual;
					}
					else
					{
						t = TokenId.Equal;
					}
					break;
				case '>':
					NextChar();
					if (_ch == '=')
					{
						NextChar();
						t = TokenId.GreaterThanEqual;
					}
					else
					{
						t = TokenId.GreaterThan;
					}
					break;
				case '?':
					NextChar();
					t = TokenId.Question;
					break;
				case '[':
					NextChar();
					t = TokenId.OpenBracket;
					break;
				case ']':
					NextChar();
					t = TokenId.CloseBracket;
					break;
				case '|':
					NextChar();
					if (_ch == '|')
					{
						NextChar();
						t = TokenId.DoubleBar;
					}
					else
					{
						t = TokenId.Bar;
					}
					break;
				case '"':
				case '\'':
					var quote = _ch;
					do
					{
						NextChar();
						while (_textPos < _textLen && _ch != quote)
							NextChar();
						if (_textPos == _textLen)
							throw ParseError(_textPos, Res.UnterminatedStringLiteral);
						NextChar();
					} while (_ch == quote);
					t = TokenId.StringLiteral;
					break;
				default:
					if (char.IsLetter(_ch) || _ch == '@' || _ch == '_')
					{
						do
						{
							NextChar();
						} while (char.IsLetterOrDigit(_ch) || _ch == '_');
						t = TokenId.Identifier;
						break;
					}
					if (char.IsDigit(_ch))
					{
						t = TokenId.IntegerLiteral;
						do
						{
							NextChar();
						} while (char.IsDigit(_ch));
						if (_ch == '.')
						{
							t = TokenId.RealLiteral;
							NextChar();
							ValidateDigit();
							do
							{
								NextChar();
							} while (char.IsDigit(_ch));
						}
						if (_ch == 'E' || _ch == 'e')
						{
							t = TokenId.RealLiteral;
							NextChar();
							if (_ch == '+' || _ch == '-')
								NextChar();
							ValidateDigit();
							do
							{
								NextChar();
							} while (char.IsDigit(_ch));
						}
						if (_ch == 'F' || _ch == 'f')
							NextChar();
						break;
					}
					if (_textPos == _textLen)
					{
						t = TokenId.End;
						break;
					}
					throw ParseError(_textPos, Res.InvalidCharacter, _ch);
			}
			_token.ID = t;
			_token.Text = _text.Substring(tokenPos, _textPos - tokenPos);
			_token.Pos = tokenPos;

			if (TokenIdentifierIs("as"))
			{
				_token.ID = TokenId.AsType;
			}
			else if (TokenIdentifierIs("is"))
			{
				_token.ID = TokenId.IsType;
			}
		}

		private bool TokenIdentifierIs(string id)
		{
			return _token.ID == TokenId.Identifier && string.Equals(id, _token.Text, StringComparison.OrdinalIgnoreCase);
		}

		private string GetIdentifier()
		{
			ValidateToken(TokenId.Identifier, Res.IdentifierExpected);
			var id = _token.Text;
			if (id.Length > 1 && id[0] == '@')
				id = id.Substring(1);
			return id;
		}

		private void ValidateDigit()
		{
			if (!char.IsDigit(_ch))
				throw ParseError(_textPos, Res.DigitExpected);
		}

		private void ValidateToken(TokenId t, string errorMessage)
		{
			if (_token.ID != t)
				throw ParseError(errorMessage);
		}

		private void ValidateToken(TokenId t)
		{
			if (_token.ID != t)
				throw ParseError(Res.SyntaxError);
		}

		private Exception ParseError(string format, params object[] args)
		{
			return ParseError(_token.Pos, format, args);
		}

		private Exception ParseError(int pos, string format, params object[] args)
		{
			return new ParseException(string.Format(CultureInfo.CurrentCulture, format, args), pos);
		}

		private Dictionary<string, object> CreateKeywords()
		{
		    var d = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase)
		            {
		                {"true", TrueLiteral},
		                {"false", FalseLiteral},
		                {"null", NullLiteral},
		                {KeywordIt, KeywordIt},
		                {KeywordIif, KeywordIif},
		                {KeywordNew, KeywordNew}
		            };
		    foreach (var type in _allowedTypes)
			{
				d.Add(type.Name, type);
			}
			return d;
		}
	}
}
