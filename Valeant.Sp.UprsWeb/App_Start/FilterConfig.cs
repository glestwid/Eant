using System.Web;
using System.Web.Mvc;
using Valeant.Sp.UprsWeb.Filters;

namespace Valeant.Sp.UprsWeb
{
    public static class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
            filters.Add(new TimeZoneOffsetFilter());
        }
    }
}
