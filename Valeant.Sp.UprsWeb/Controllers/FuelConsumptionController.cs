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
    [ValeantAuthorize(RoleCodes = "R-00000008")]
    public class FuelConsumptionController : JsonNetController
    {
        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            var data = (await DataProvider.ReadSimpleDictionaryFullAsync("FuelConsumption")).Select(x => ReferencesController.ConvertFuelConsumption(x.Value));
            return Json(data);
        }

        [HttpPost]
        [Route("create")]
        public Task Create([ModelBinder(typeof(JsonNetModelBinder))] FuelConsumptionReference item) {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, true), "FuelConsumption");
        }

        [HttpPost]
        [Route("update")]
        public Task Update([ModelBinder(typeof(JsonNetModelBinder))] FuelConsumptionReference item) {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, false), "FuelConsumption");
        }

        [HttpPost]
        [Route("delete")]
        public Task Delete([ModelBinder(typeof(JsonNetModelBinder))] FuelConsumptionReference item) {
            return DataProvider.DeleteSimpleDictionaryAsync(item.Id, "FuelConsumption");
        }

        static SimpleDictionaryItem Convert(FuelConsumptionReference item, bool addItem) {
            var newSimpleDictionaryItem = new SimpleDictionaryItem
            {
                Id = addItem ? -1 : item.Id,
                Value = item.Name,
                Advanced = string.Format("{0};{1};{2}",item.FuelGrade,item.ConsumptionSummer,item.ConsumptionWinter)

            };
           
            return newSimpleDictionaryItem;
        }
    }
}