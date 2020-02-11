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
    public class AccountGroupsController : JsonNetController
    {
        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            var data = (await DataProvider.ReadSimpleDictionaryFullAsync("AccountGroups")).Select(x => ReferencesController.ConvertAccountGroup(x.Value));
            return Json(data);
        }

        [ValeantAuthorize(RoleCodes = "R-00000006")]
        [HttpPost]
        [Route("create")]
        public Task Create([ModelBinder(typeof(JsonNetModelBinder))] AccountGroupReference item)
        {
           return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, true), "AccountGroups");
        }

        [ValeantAuthorize(RoleCodes = "R-00000006")]
        [HttpPost]
        [Route("update")]
        public Task Update([ModelBinder(typeof(JsonNetModelBinder))] AccountGroupReference item)
        {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, false), "AccountGroups");
        }

        [ValeantAuthorize(RoleCodes = "R-00000006")]
        [HttpPost]
        [Route("delete")]
        public Task Delete([ModelBinder(typeof(JsonNetModelBinder))] AccountGroupReference item)
        {
            return DataProvider.DeleteSimpleDictionaryAsync(item.Id, "AccountGroups");
        }

        static SimpleDictionaryItem Convert(AccountGroupReference item, bool addItem)
        {
            var newSimpleDictionaryItem = new SimpleDictionaryItem
            {
                Id = addItem ? -1 : item.Id,
                Value = item.AccountGroupName,
                Advanced = string.Format("{0}", item.AccountingRecords)

            };

            return newSimpleDictionaryItem;
        }
    }
}
