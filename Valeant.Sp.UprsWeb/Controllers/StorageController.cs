using System.Net;
using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.UprsWeb.Helpers;

namespace Valeant.Sp.UprsWeb.Controllers {
    public class StorageController : Controller {
        [HttpGet]
        [Route("get")]
        public async Task<FileContentResult> Get(string urn) {
            var attachment = await DataProvider.ReadAttachment(urn);
            if (attachment == null) {
                Response.StatusCode = (int)HttpStatusCode.NotFound;
                return null;
            }
            var buffer = StorageHelper.Read(urn);
            if (buffer == null) {
                Response.StatusCode = (int)HttpStatusCode.NotFound;
                return null;
            }
            return new FileContentResult(buffer, attachment.ContentType);
        }
    }
} 