using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Security;

namespace Valeant.Sp.UprsWeb.Controllers
{
    [ValeantAuthorize(RoleCodes = "R-00000006")]
    public class DocumentTypesController: JsonNetController
    {
        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            var data = (await DataProvider.ReadSimpleDictionaryFullAsync("DocumentTypes") ).Select(x => ReferencesController.ConvertDocumentType(x.Value));
            return Json(data);
        }

        [HttpPost]
        [Route("create")]
        public Task Create([ModelBinder(typeof(JsonNetModelBinder))] DocumentTypeReference item)
        {
           return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, true), "DocumentTypes");
        }

        [HttpPost]
        [Route("update")]
        public Task Update([ModelBinder(typeof(JsonNetModelBinder))] DocumentTypeReference item)
        {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, false), "DocumentTypes");
        }

        [HttpPost]
        [Route("delete")]
        public Task Delete([ModelBinder(typeof(JsonNetModelBinder))] DocumentTypeReference item)
        {
            return DataProvider.DeleteSimpleDictionaryAsync(item.Id, "DocumentTypes");
        }

        static SimpleDictionaryItem Convert(DocumentTypeReference item, bool addItem)
        {
            var newSimpleDictionaryItem = new SimpleDictionaryItem
            {
                Id = addItem ? -1 : item.Id,
                Value = item.Name
            };
            return newSimpleDictionaryItem;
        }
    }
}
