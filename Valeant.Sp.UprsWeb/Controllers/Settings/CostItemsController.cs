using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain.Expenditure;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Security;

namespace Valeant.Sp.UprsWeb.Controllers.Settings
{
    [ValeantAuthorize(RoleCodes = "R-00000006")]
    public class CostItemsController : JsonNetController
    {
        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            var expenditures = await DataProvider.GetAllExpendituresAsync();
            return Json(expenditures);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getDocumentLimits")]
        public async Task<JsonResult> GetDocumentLimits(string documentType, long? documentId) {
            var user = (documentId == null) ? DataProvider.GetHuman(HttpContext.User.Identity.Name) : await DataProvider.ReadAdvanceCreatorAsync(documentId.Value);
            var expenditures = await DataProvider.ReadLimitItemCollectionAsync(documentType, user.PositionGroupId);
            return Json(expenditures);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("limits")]
        public async Task<JsonResult> GetLimits(long expenditureId)
        {
            var limits = await DataProvider.GetExpenditureLimitsAsync(expenditureId);
            return Json(limits);
        }

        [HttpPost]
        [Route("delete")]
        public async Task<int> Delete([ModelBinder(typeof(JsonNetModelBinder))] long itemId)
        {
            return await DataProvider.DeleteExpenditureAsync(itemId);
        }

        [HttpPost]
        [Route("create")]
        public async Task Create([ModelBinder(typeof(JsonNetModelBinder))] ChangeExpenditureCommand item)
        {
            await DataProvider.CreateExpenditureAsync(item);
        }

        [HttpPost]
        [Route("update")]
        public async Task Update([ModelBinder(typeof(JsonNetModelBinder))] ChangeExpenditureCommand item)
        {
            await DataProvider.UpdateExpenditureAsync(item);
        }
    }
}