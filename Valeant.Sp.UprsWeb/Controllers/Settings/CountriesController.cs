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
    [ValeantAuthorize(RoleCodes = "R-00000004")]
    public class CountriesController : JsonNetController
    {
        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            var data = (await DataProvider.ReadSimpleDictionaryFullAsync("Countries")).Select(x => ReferencesController.ConvertCountry(x.Value));
            // https://ontec.tpondemand.com/entity/614
            // Добавить Россию вверх списка выбора стран - проставлять россию по умолчанию
            var data2 = data.OrderBy(c => c.IsForeign).AsEnumerable();
            return Json(data2);
        }

        [HttpPost]
        [Route("create")]
        public Task Create([ModelBinder(typeof(JsonNetModelBinder))] CountryReference item) {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, true), "Countries");
        }

        [HttpPost]
        [Route("update")]
        public Task Update([ModelBinder(typeof(JsonNetModelBinder))] CountryReference item) {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, false), "Countries");
        }

        [HttpPost]
        [Route("delete")]
        public Task Delete([ModelBinder(typeof(JsonNetModelBinder))] CountryReference item) {
            return DataProvider.DeleteSimpleDictionaryAsync(item.Id, "Countries");
        }

        static SimpleDictionaryItem Convert(CountryReference item, bool addItem) {
            var newSimpleDictionaryItem = new SimpleDictionaryItem {
                Id = addItem ? -1 : item.Id,
                Value = item.Name
            };
            if (item.IsForeign) newSimpleDictionaryItem.Flag = true;
            if (item.IsCis) newSimpleDictionaryItem.Flag1 = true;
            return newSimpleDictionaryItem;
        }
    }
}