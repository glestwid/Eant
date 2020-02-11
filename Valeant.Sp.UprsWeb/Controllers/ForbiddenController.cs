using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Valeant.Sp.UprsWeb.Controllers
{
    public class ForbiddenController : Controller
    {
        // GET: Forbidden
       // [Route("Forbidden")]
        public ActionResult Index()
        {
            return View();
        }
    }
}