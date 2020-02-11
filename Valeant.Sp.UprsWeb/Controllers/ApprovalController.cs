using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using NLog;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Helpers;

namespace Valeant.Sp.UprsWeb.Controllers {
    public class ApprovalsController : JsonNetController {
        private readonly Logger _logger = LogManager.GetCurrentClassLogger();

        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll(string statusFilter, string dateRangeFilter, string search) {
            var items = await DocumentHelper.GetAll(statusFilter, dateRangeFilter, HttpContext.User.Identity.Name, Convert);
            items = items.Where(x => x.Number.ToString().Contains(search)).ToArray();
            return Json(items);
        }

        private ApprovalData Convert(AdvanceVersion3 data)
        {
            return new ApprovalData
            {
                Id = data.Id,
                Number = data.Number,
                Date = data.Date.Date,
                Status = data.Status,
                Type = data.Type,
                Person = data.FullName,
                Division = data.DepartmentName,
                IsApproved = false
            };
        }
    }
}