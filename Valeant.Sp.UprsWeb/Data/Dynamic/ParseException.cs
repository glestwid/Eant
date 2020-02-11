using System;

namespace Valeant.Sp.UprsWeb.Data.Dynamic
{
	public sealed class ParseException : Exception
	{
	    public ParseException(string message, int position)
			: base(message)
		{
			Position = position;
		}

		public int Position { get; }

	    public override string ToString()
		{
			return string.Format(Res.ParseExceptionFormat, Message, Position);
		}
	}
}
