using System.Web.Mvc;

namespace Valeant.Sp.UprsWeb.Filters {
    public class AllowJsonGetAttribute : ActionFilterAttribute {
        public override void OnResultExecuting(ResultExecutingContext filterContext) {
            var result = filterContext.Result as JsonResult;
            if (result != null) result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
        }
    }
}