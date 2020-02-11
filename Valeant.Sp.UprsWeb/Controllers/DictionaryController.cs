using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;

namespace Valeant.Sp.UprsWeb.Controllers {
    public class DictionaryController : JsonNetController {
        private static readonly DataProvider DataProvider;

        static DictionaryController() {
            DataProvider = new DataProvider();
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getSimpleDictionary")]
        public async Task<JsonResult> AddNew( /*[FromBody]*/ string type) {
            var result = await DataProvider.ReadSimpleDictionaryCollectionAsync(type);
            return Json(result.Select(x=> new ReferenceBase() {Id = x.Key, Name = x.Value}));
        }
    }
}