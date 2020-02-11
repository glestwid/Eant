using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.UprsWeb.Filters;

namespace Valeant.Sp.UprsWeb.Controllers
{
    public class TestingController : Controller
    {
        [AllowJsonGet]
        [HttpGet]
        [Route("success")]
        public async Task<JsonResult> Success()
        {
            return Json(new {});
        }

        [HttpGet]
        [Route("error")]
        public async Task<HttpResponseMessage> Error()
        {
            throw new WebException();
        }
    }
}