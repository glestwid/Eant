using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Security;

namespace Valeant.Sp.UprsWeb.Controllers
{
    [ValeantAuthorize(RoleCodes = "R-00000006")]
    public class VehicleTypesController : JsonNetController
    {
        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            var data = (await DataProvider.ReadSimpleDictionaryFullAsync("VehicleTypes")).Select(x => ReferencesController.ConvertVehicleType(x.Value));
            return Json(data);
        }

        [HttpPost]
        [Route("create")]
        public Task Create([ModelBinder(typeof(JsonNetModelBinder))] VehicleTypeReference item)
        {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, true), "VehicleTypes");
        }

        [HttpPost]
        [Route("update")]
        public Task Update([ModelBinder(typeof(JsonNetModelBinder))] VehicleTypeReference item)
        {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, false), "VehicleTypes");
        }

        [HttpPost]
        [Route("delete")]
        public Task Delete([ModelBinder(typeof(JsonNetModelBinder))] VehicleTypeReference item)
        {
            return DataProvider.DeleteSimpleDictionaryAsync(item.Id, "VehicleTypes");
        }

        static SimpleDictionaryItem Convert(VehicleTypeReference item, bool addItem)
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
