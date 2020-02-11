﻿using Microsoft.SharePoint.Client;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.UprsWeb.Security;

namespace Valeant.Sp.UprsWeb.Controllers {
    public class HomeController : Controller {
      //  [SharePointContextFilter]
        public ActionResult Index() {

            //User spUser = null;
            //var spContext = SharePointContextProvider.Current.GetSharePointContext(HttpContext);
            //using (var clientContext = spContext.CreateUserClientContextForSPHost()) {
            //    if (clientContext != null) {
            //        spUser = clientContext.Web.CurrentUser;
            //        clientContext.Load(spUser, user => user.Title);
            //        clientContext.ExecuteQuery();
            //        ViewBag.UserName = spUser.Title;
            //    }
            //}
            

            if (DataProvider.GetHuman(HttpContext.User.Identity.Name) == null)
                return RedirectToAction("Index", "Forbidden");
            else
                return View();
        }
    }
}
