using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;

namespace Valeant.Sp.UprsWeb.Controllers
{
    public class LoginController : JsonNetController
    {

        [AllowJsonGet]
        [HttpGet]
        [Route("getUser")]
        public async Task<JsonResult> GetUser()
        {
            return await Task.Run(() =>
            {

                return Json(HttpContext.User.Identity.Name);
            });
        }


    }
}