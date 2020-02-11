using System.Globalization;
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
    public class DailyLimitsBaseController : JsonNetController
    {
        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            var data = (await DataProvider.ReadSimpleDictionaryFullAsync("DailyLimits")).Select(x => ReferencesController.ConvertDailyLimit(x.Value));
            return Json(data);
        }

        [HttpPost]
        [Route("create")]
        public Task Create([ModelBinder(typeof(JsonNetModelBinder))] DailyLimitsBaseReference item)
        {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, true), "DailyLimits");
        }

        [HttpPost]
        [Route("update")]
        public Task Update([ModelBinder(typeof(JsonNetModelBinder))] DailyLimitsBaseReference item)
        {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, false), "DailyLimits");
        }

        [HttpPost]
        [Route("delete")]
        public Task Delete([ModelBinder(typeof(JsonNetModelBinder))] DailyLimitsBaseReference item)
        {
            return DataProvider.DeleteSimpleDictionaryAsync(item.Id, "DailyLimits");
        }

        static SimpleDictionaryItem Convert(DailyLimitsBaseReference item, bool addItem)
        {
            var newSimpleDictionaryItem = new SimpleDictionaryItem
            {
                Id = addItem ? -1 : item.Id,
                Value = item.RateName
            };
            newSimpleDictionaryItem.Advanced = item.Limit.ToString(CultureInfo.InvariantCulture);
            return newSimpleDictionaryItem;
        }
    }
}
