using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Web.Mvc;
using AutoMapper;
using NLog;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Report;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Helpers;
using System.IO;

namespace Valeant.Sp.UprsWeb.Controllers
{
    public class PrintingController : JsonNetController
    {
        private readonly Logger _logger = LogManager.GetCurrentClassLogger();

        [HttpGet]
        [Route("getForm")]
        public async Task<FileContentResult> GetForm(long id, string format)
        {
            try
            {
                var contentData = await DataProvider.ReadAdvanceContent(id);
                var objs = await ContentFactory.ConvertReport(contentData.ContentType, contentData.Content);
                var report = ContentFactory.Report(contentData.ContentType);
                var path = HostingEnvironment.MapPath($"~/{AppSettings.ReportTemplatesFolder}/{report}");
                var reportData = ReportBuilder.BuildReport(path, objs, format);
                var pdfFileName = Path.ChangeExtension(report, "PDF");
                var r = new FileContentResult(reportData.Item2, reportData.Item1) { FileDownloadName = pdfFileName };
                return r;
            }
            catch (Exception exception)
            {
                _logger.Log(LogLevel.Error, exception);
                throw;
            }
        }

        [HttpGet]
        [Route("export")]
        public async Task<FileContentResult> Export(string statusesString, string search)
        {
            if (search == null || search == "undefined")
                search = string.Empty;
            try
            {
                var format = "EXCELOPENXML";
                List<Human> contentData;
                if (string.IsNullOrWhiteSpace(search))
                    contentData = DataProvider.Humans.ToList();
                else
                    contentData =
                        DataProvider.Humans.Where(
                            x => x.FullName.Contains(search, StringComparison.InvariantCultureIgnoreCase)).ToList();
                if (contentData.Any())
                {
                    var m2 = Mapper.Map<List<Human>, List<HumanLight>>(contentData);

                    var report = "AllUsers.rdlc";
                    var path = HostingEnvironment.MapPath($"~/{AppSettings.ReportTemplatesFolder}/{report}");
                    var reportData = ReportBuilder.BuildReport(path, m2, format);
                    var r = new FileContentResult(reportData.Item2, reportData.Item1) { FileDownloadName = "Report.XLSX" };
                    return r;
                }
                throw new HttpException((int)HttpStatusCode.NotFound, $"{search} not found");
            }
            catch (Exception exception)
            {
                _logger.Log(LogLevel.Error, exception);
                throw;
            }
        }
    }
}