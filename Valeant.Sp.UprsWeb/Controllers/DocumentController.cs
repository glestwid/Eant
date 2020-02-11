using System.EnterpriseServices;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Mvc;
using Microsoft.SharePoint.Client;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.UprsWeb.Data;
using Valeant.Sp.UprsWeb.Filters;

namespace Valeant.Sp.UprsWeb.Controllers {
    public class DocumentController : Controller {
        static readonly DataProvider DataProvider;
        static DocumentController() {
            DataProvider = new DataProvider();
        }

        //[AllowJsonGet]
        [SharePointContextFilter]
        public ActionResult TestJSon()
        {
            User spUser = null;

            //var spContext = SharePointContextProvider.Current.GetSharePointContext(HttpContext);

            //using (var clientContext = spContext.CreateUserClientContextForSPHost())
            //{
            //    if (clientContext != null)
            //    {
            //        spUser = clientContext.Web.CurrentUser;

            //        clientContext.Load(spUser, user => user.Title);

            //        clientContext.ExecuteQuery();

            //        ViewBag.UserName = spUser.Title;
            //    }
            //}

            //return Json(new SampleObject {Id = 110, Name = "Test"});
            return View();
        }

        [AllowJsonGet]
        [AsyncTimeout(15000)]
        //[SharePointContextFilter]
        public async Task<JsonResult> JSonQueryAsync(CancellationToken cancellationToken) {

            /*
            User spUser = null;

            var spContext = SharePointContextProvider.Current.GetSharePointContext(HttpContext);

            using (var clientContext = spContext.CreateUserClientContextForSPHost())
            {
                if (clientContext != null)
                {
                    spUser = clientContext.Web.CurrentUser;

                    clientContext.Load(spUser, user => user.Title);

                    clientContext.ExecuteQuery();

                    ViewBag.UserName = spUser.Title;
                }
            }
            */
            var roles = DataProvider.ReadRoles();
            return Json(new SampleObject { Id = 110, Name = roles.First().Name});
        }
	}
}