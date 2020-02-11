using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Hosting;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Report;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Helpers;

namespace Valeant.Sp.UprsWeb.Controllers {
    public class HistoryController : JsonNetController {

        readonly Logger _logger = LogManager.GetCurrentClassLogger();

        [AllowJsonGet]
        [HttpPost]
        [Route("getHistory")]
        public async Task<JsonResult> GetHistory(string requestType, long id) {
            var data = await DataProvider.ReadHistoryItemCollectionAsync(id, requestType);
            return Json(data.Select(Convert));
        }

        [HttpGet]
        [Route("export")]
        public async Task<FileContentResult> Export(string requestType, long id)
        {
       

            try
            {
                var re = await DataProvider.ReadAdvanceSimple(id);

                
                var format = "PDF";
                var data = await DataProvider.ReadHistoryItemCollectionAsync(id, requestType);
                var reportItems = data.Select(Convert);
                var owner = await DataProvider.ReadAdvanceCreatorAsync(re.Id);

                var header = new Valeant.Sp.Uprs.Report.Data.RequestHistoryHeader
                {
                    Number = re.Number,
                    Date   = re.DateCreate.DateTime,
                    Human  = owner.FullName,
                    Position = owner.Position,
                    Department = owner.DepartmentName

                };
                var h = new List<Valeant.Sp.Uprs.Report.Data.RequestHistoryHeader> { header };


                var report = "ApproveHistory.rdlc";
                var path = HostingEnvironment.MapPath($"~/{AppSettings.ReportTemplatesFolder}/{report}");
                var reportData = ReportBuilder.BuildReport(path, new List<object> { reportItems, h }, format);
                var r = new FileContentResult(reportData.Item2, "application/octet-stream") { FileDownloadName = Server.UrlPathEncode("История заявки.pdf") };
                return r;
            }
            catch (Exception exception)
            {
                _logger.Log(LogLevel.Error, exception);
                throw;
            }


        }

            static RequestHistoryData Convert(HistoryItem item) {
            return new RequestHistoryData {
                Number = item.Number,
                CreateDate = item.Date.UtcDateTime,
                Initiator = item.FullName,
                Message = item.History,
                Comment = item.Comment
            };
        }
    }
}