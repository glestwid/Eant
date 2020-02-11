using System.Linq.Expressions;

namespace Valeant.Sp.UprsWeb.Data.Dynamic
{
	internal class DynamicOrdering
	{
		public Expression Selector;
		public ParameterExpression Parameter;
		public bool Ascending;
	}
}
