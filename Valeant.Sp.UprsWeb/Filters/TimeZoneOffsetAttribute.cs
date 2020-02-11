using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Valeant.Sp.UprsWeb.Filters
{
    public class TimeZoneOffsetFilter : IActionFilter
    {
        public void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var timeZoneCookie = filterContext.RequestContext.HttpContext.Request.Cookies["_timeZoneOffset"];
            if (timeZoneCookie != null)
            {
                double offsetMinutes = 0;
                if (double.TryParse(timeZoneCookie.Value, out offsetMinutes))
                {
                    filterContext.Controller.TempData["TimeZoneOffset"] = TimeSpan.FromMinutes(offsetMinutes);
                }
            }
            else
            {
                // Default offset (Utc) if cookie is missing.
                filterContext.Controller.TempData["TimeZoneOffset"] = TimeZoneInfo.Local.BaseUtcOffset;
            }
            
        }

        public void OnActionExecuted(ActionExecutedContext filterContext)
        {
           
        }
    }
}