using System;
using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Security;

namespace Valeant.Sp.UprsWeb.Controllers.Settings
{
    [ValeantAuthorize(RoleCodes = "R-00000006")]
    public class CostCentersController : JsonNetController
    {
        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            var expenditures = await DataProvider.ReadCostcenterAsync();
            return Json(expenditures);
        }

        [HttpPost]
        [Route("delete")]
        public async Task Delete([ModelBinder(typeof(JsonNetModelBinder))] Costcenter item)
        {
            await DataProvider.DeleteCostCenterAsync(item);
        }

        [HttpPost]
        [Route("create")]
        public async Task Create([ModelBinder(typeof(JsonNetModelBinder))] Costcenter item)
        {
            await DataProvider.InsertOrUpdateCostCenterAsync(item);
        }

        [HttpPost]
        [Route("update")]
        public async Task Update([ModelBinder(typeof(JsonNetModelBinder))] Costcenter item)
        {
            await DataProvider.InsertOrUpdateCostCenterAsync(item);
        }
    }
}