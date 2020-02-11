using System;

namespace Valeant.Sp.UprsWeb.Controllers.Utils
{
    public static class UtilsExtensions
    {
        public static bool Contains(this string source, string toCheck, StringComparison comp)
        {
            return source != null && toCheck != null && source.IndexOf(toCheck, comp) >= 0;
        }
    }
}