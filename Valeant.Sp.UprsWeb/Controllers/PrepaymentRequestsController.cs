using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Web.Mvc;
using System.Xml.Linq;
using Newtonsoft.Json;
using NLog;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Data.Matrix;
using Valeant.Sp.Uprs.Report;
using Valeant.Sp.Uprs.Report.Data;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Helpers;
using Valeant.Sp.UprsWeb.Mail;
using Valeant.Sp.UprsWeb.Matrix;
using AdvanceReportEntity = Valeant.Sp.UprsWeb.Controllers.Entities.AdvanceReportEntity;

namespace Valeant.Sp.UprsWeb.Controllers
{
    /// <summary>
    /// API controller used for prepayment requests processing.
    /// </summary>
    public class PrepaymentRequestsController : JsonNetController
    {
        private readonly Logger _logger = LogManager.GetCurrentClassLogger();

        private const string DocumentName = "Заявка на аванс";

        private const string ApprovedStatus = "Утверждена";

        private const string PaidStatus = "Оплачена";
        
        private static readonly MatrixVersion3Decorator Matrix;

        private static readonly List<Type> ConditionAdditionalTypes = new List<Type>
                                                                       {
                                                                           typeof (StringComparison),
                                                                           typeof (EntitiesBase),
                                                                           typeof (AdvanceReportDataEx),
                                                                           typeof (Human)
                                                                       };

        private static readonly List<Type> PostFuncAdditionalTypes = new List<Type>
                                                                       {
                                                                           typeof (StringComparison),
                                                                           typeof (DataProvider), 
                                                                           typeof (AdvanceReportDataEx),
                                                                           typeof (Human)
                                                                       };

        private static readonly ParameterExpression[] ConditionParameters = {
                                                                        Expression.Parameter(typeof (string), "action"),
                                                                        Expression.Parameter(typeof (Human), "owner"),
                                                                        Expression.Parameter(typeof (Human), "actor"),
                                                                        Expression.Parameter(typeof (AdvanceReportDataEx), "document"),
                                                                        Expression.Parameter(typeof (MatrixVersion3Decorator), "matrix"),
                                                                        Expression.Parameter(typeof(TokenCollection), "tokens")
                                                                    };

        private static readonly ParameterExpression[] PostFuncParameters = {
                                                                                Expression.Parameter(typeof (AdvanceReportDataEx), "document"),
                                                                                Expression.Parameter(typeof (string), "action"),
                                                                                Expression.Parameter(typeof (Human), "owner"),
                                                                                Expression.Parameter(typeof (Human), "actor")
                                                                            };


        static PrepaymentRequestsController()
        {
            var typeName = typeof (AdvanceReportDataEx).FullName;
            ContentFactory.Register(typeName, typeof (AdvanceReportDataEx), ReportConvert, "AdvanceReport.rdlc");
            var documentTypeId = DataProvider.DocumentTypesByName[DocumentName];
            Matrix = Matrixs.Get(documentTypeId, ConditionAdditionalTypes, ConditionParameters, PostFuncAdditionalTypes, PostFuncParameters);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll(string statusFilter, string dateRangeFilter, string search)
        {
            var items = await DocumentHelper.GetAll(statusFilter, dateRangeFilter, HttpContext.User.Identity.Name, DocumentName, Convert);
            items = items.Where(x => x.Number.ToString().Contains(search)).ToArray();
            return Json(items);
        }

        /// <summary>
        /// Returns all approved prepayment requests.
        /// </summary>
        /// <param name="dateRangeFilter">Folter by date period.</param>
        /// <returns>Collection of payment requests as JsonResult.</returns>
        [AllowJsonGet]
        [HttpGet]
        [Route("getApproved")]
        public async Task<ActionResult> GetApproved(string dateRangeFilter)
        {
            _logger.Trace($"{HttpContext.User.Identity.Name} requested {nameof(GetApproved)} action with {nameof(dateRangeFilter)}: '{dateRangeFilter}'");
            var items = await DocumentHelper.GetAllApprovedAsync(ApprovedStatus, dateRangeFilter, HttpContext.User.Identity.Name, DocumentName,
                data => new
                {
                    Id = data.Id,
                    Date = data.Date.DateTime,
                    Number = data.Number,
                    Status = data.Status,
                    Sum = data.Sum,
                    Type = data.Type,
                    Paid = data.Status == PaidStatus,
                    Person = data.FullName,
                    Division = data.DepartmentName
                });
            return Json(items);
        }

        /// <summary>
        /// Marks a prepayment request as paid.
        /// </summary>
        /// <param name="id">Unique identifier of a prepayment request.</param>
        /// <returns>True if success, otherwise false.</returns>
        [HttpPost]
        [Route("markPaid")]
        public async Task<ActionResult> MarkPaid(long documentId)
        {
            _logger.Trace($"{HttpContext.User.Identity.Name} requested {nameof(MarkPaid)} action with {nameof(documentId)}: '{documentId}'");
            var actor = DataProvider.GetHuman(HttpContext.User.Identity.Name);
            if (actor == null || !actor.IsAccountant)
            {
                _logger.Warn("User is null");
                return HttpNotFound("user must be an accountant");
            }

            var document = await DocumentHelper.Get<AdvanceReportDataEx>(documentId, HttpContext.User.Identity.Name, DocumentName, Matrix);
            var request = new AdvanceReportDataExRequest {Data = document, Action = "Оплатить"};
            return await Save(request);
        }

        /// <summary>
        /// Marks a prepayment request as unpaid.
        /// </summary>
        /// <param name="id">Unique identifier of a prepayment request.</param>
        /// <returns>True if success, otherwise false.</returns>
        [HttpPost]
        [Route("markUnpaid")]
        public async Task<ActionResult> MarkUnpaid(long documentId)
        {
            _logger.Trace($"{HttpContext.User.Identity.Name} requested {nameof(MarkUnpaid)} action with {nameof(documentId)}: '{documentId}'");
            var human = DataProvider.GetHuman(HttpContext.User.Identity.Name);

            if (human == null || !human.IsAccountant)
            {
                _logger.Warn("User is null");
                return HttpNotFound("user must be an accountant");
            }

            var document = await DocumentHelper.Get<AdvanceReportDataEx>(documentId, HttpContext.User.Identity.Name, DocumentName, Matrix);
            var request = new AdvanceReportDataExRequest { Data = document, Action = "Снять пометку об оплате" };
            return await Save(request);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("get")]
        public async Task<JsonResult> Get(long id)
        {
            try
            {
                return Json(await DocumentHelper.Get<AdvanceReportDataEx>(id, HttpContext.User.Identity.Name, DocumentName, Matrix));
            }
            catch (Exception exception)
            {
                _logger.Log(LogLevel.Error, exception);
                Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                return Json(exception);
            }
        }

        [HttpPost]
        [Route("save")]
        public async Task<JsonResult> Save([ModelBinder(typeof (JsonNetModelBinder))] AdvanceReportDataExRequest request)
        {
            try
            {
                await SaveAdvanceReportDataEx(request.Data, request.Action);
                return Json(true);
            }
            catch (Exception ex)
            {
                Response.StatusCode = (int) HttpStatusCode.InternalServerError;
                return Json(ex);
            }
        }

        private static AdvanceReportEntity Convert(AdvanceVersion3 data)
        {
            return new AdvanceReportEntity
            {
                Id = data.Id,
                Date = data.Date.DateTime,
                Number = data.Number,
                Status = data.Status,
                Sum = data.Sum,
                Type = data.Type
            };
        }

        private async Task SaveAdvanceReportDataEx(AdvanceReportDataEx data, string action)
        {
            data.AdvanceRequestsData.Options.AdvanceDate =
                data.AdvanceRequestsData.Options.AdvanceDate.ToUniversalTime();

            var actor = DataProvider.GetHuman(HttpContext.User.Identity.Name);
            var insertData = await DocumentHelper.ProcessDocument(data, DocumentName, new DateTimeOffset(data.AdvanceRequestsData.Options.AdvanceDate),
                data.AdvanceRequestsData.Options.Sum, DocumentName, action, actor, 
                HttpContext.Request.UrlReferrer.AbsoluteUri, data.DenyReason, Matrix, SubProcessResolver);
            data.Id = insertData.Id;
            data.Number = insertData.Number;

            if (insertData.Notifications != null && insertData.Notifications.Any())
            {
                foreach (var item in insertData.Notifications)
                {
                    try
                    {
                        var owner = await DataProvider.ReadAdvanceCreatorAsync(data.Id);
                        var maildata = AdvanceMailData.Create(HttpContext.Request.UrlReferrer.AbsoluteUri,
                            item.Notification, action, owner, actor, data.DenyReason, data);
                        MailWorker.Queuing(maildata, typeof(AdvanceMailData), item);
                    }
                    catch (Exception ex)
                    {
                        
                    }
                }
            }
        }

        string SubProcessResolver(Human human)
        {
            return "A";
        }

        public static async Task<object[]> ReportConvert(XElement element)
        {
            var data = DocumentHelper.GetDocumentContent<AdvanceReportDataEx>(element);
            var owner = await DataProvider.ReadAdvanceCreatorAsync(data.Id);
            var list = (await DataProvider.ReadApprovedHistoryItemCollectionAsync(data.Id, DocumentName))
                .Aggregate(string.Empty, (current, item) => $"{current}{item.Date.ToString("dd.MM.yyyy HH:mm")} {item.FullName} - {item.Position} - согласовано\r\n");

        var advanceReport = new AdvancesReportData
                                {
                                    new Uprs.Report.Data.AdvanceReportData
                                    {
                                        Date = data.AdvanceRequestsData.Options.AdvanceDate,
                                        HumanFrom = owner.FullName,
                                        PositionFrom = owner.Position,
                                        DepartmentFrom = owner.DepartmentName,
                                        CodeFrom = owner.NavisionCode,
                                        HumanTo = owner.ManagerName,
                                        Id = data.Id,
                                        State = data.Status,
                                        ApprovedList = list
                                    }
                                };

            var advanceReportDetails = new AdvanceReportDataDetails();
            advanceReportDetails.AddRange(data.AdvanceRequestsData.Rows.Select(row => new AdvanceReportDataDetail
                {
                    Id = row.Order,
                    CostItem = row.CostItem.Name,
                    AdvanceId = data.Id,
                    Sum = row.Advance,
                    Comment = row.Comment
                }));

            return new object[]
                   {
                       advanceReport,
                       advanceReportDetails
                   };
        }

        [HttpGet]
        [Route("export")]
        public async Task<FileContentResult> Export()
        {
            try
            {
                var format = "EXCELOPENXML";
                var items = (await DataProvider.GetPrepaymentRequestsReportAsync()).ToList();

                foreach (var prepaymentRequestReportLine in items)
                {
                    prepaymentRequestReportLine.RequestDate = ToUserOffset(prepaymentRequestReportLine.RequestDate);
                }

                var report = "PrepaymentRequests.rdlc";
                var path = HostingEnvironment.MapPath($"~/{AppSettings.ReportTemplatesFolder}/{report}");
                var reportData = ReportBuilder.BuildReport(path, items, format);
                var r = new FileContentResult(reportData.Item2, reportData.Item1) { FileDownloadName = "PrepaymentRequests.xlsx" };
                return r;
            }
            catch (Exception exception)
            {
                _logger.Log(LogLevel.Error, exception);
                throw;
            }
        }

        public class AdvanceMailData : MailData
        {
            public decimal AdvanceSumma { get; set; }

            public static AdvanceMailData Create(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, AdvanceReportDataEx data)
            {
                return new AdvanceMailData(baseUrl, notificationItem, action, owner, actor, comment, data)
                {
                    Number = data.Number,
                    AdvanceSumma = data.AdvanceRequestsData.Options.Sum,
                    Date = data.AdvanceRequestsData.Options.AdvanceDate.Date
                };
            }

            public DateTime Date { get; set; }

            private AdvanceMailData(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, EntitiesBase entiti)
                : base(baseUrl, notificationItem, action, owner, actor, comment, entiti)
            {
            }
        }

        public class AdvanceReportDataExRequest
        {
            [JsonProperty(PropertyName = "action")]
            public string Action { get; set; }

            [JsonProperty(PropertyName = "data")]
            public AdvanceReportDataEx Data { get; set; }
        }
    }
}