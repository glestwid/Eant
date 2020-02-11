using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Monads;
using System.Net;
using System.Threading.Tasks;
using System.Web.Mvc;
using System.Dynamic;
using System.Web;
using System.Web.Hosting;

using AutoMapper;
using Newtonsoft.Json;
using NLog;

using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Consts;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Data.Matrix;
using Valeant.Sp.Uprs.Data.Query;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Helpers;
using Valeant.Sp.UprsWeb.Mail;
using Valeant.Sp.UprsWeb.Matrix;
using Valeant.Sp.Uprs.Report;
using Valeant.Sp.Uprs.Report.Data;



namespace Valeant.Sp.UprsWeb.Controllers
{
    public class TripAdvanceReportsController: JsonNetController {
        readonly Logger _logger = LogManager.GetCurrentClassLogger();
        internal const string DocumentName = "Авансовый отчет по командировке/служебной поездке";
        private static readonly MatrixVersion3Decorator Matrix;

        private static readonly List<Type> ConditionAdditionalTypes = new List<Type> {
                                                                           typeof (StringComparison),
                                                                           typeof (EntitiesBase),
                                                                           typeof (AdvanceTripReportDataEx),
                                                                           typeof (Human)
                                                                       };

        private static readonly List<Type> PostFuncAdditionalTypes = new List<Type> {
                                                                           typeof (StringComparison),
                                                                           typeof (DataProvider),
                                                                           typeof (AdvanceTripReportDataEx),
                                                                           typeof (Human)
                                                                       };

        private static readonly ParameterExpression[] ConditionParameters = {
                                                                        Expression.Parameter(typeof (string), "action"),
                                                                        Expression.Parameter(typeof (Human), "owner"),
                                                                        Expression.Parameter(typeof (Human), "actor"),
                                                                        Expression.Parameter(typeof (AdvanceTripReportDataEx), "document"),
                                                                        Expression.Parameter(typeof (MatrixVersion3Decorator), "matrix"),
                                                                        Expression.Parameter(typeof(TokenCollection), "tokens")
                                                                    };

        private static readonly ParameterExpression[] PostFuncParameters = {
                                                                                Expression.Parameter(typeof (AdvanceTripReportDataEx), "document"),
                                                                                Expression.Parameter(typeof (Human), "owner"),
                                                                                Expression.Parameter(typeof (Human), "actor")
                                                                            };

        static TripAdvanceReportsController() {
            //ContentFactory.Register(typeName, typeof(AdvanceReportDataEx), ReportConvert, "AdvanceReport.rdlc");
            var documentTypeId = DataProvider.DocumentTypesByName[DocumentName];
            Matrix = Matrixs.Get(documentTypeId, ConditionAdditionalTypes, ConditionParameters, PostFuncAdditionalTypes, PostFuncParameters);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll(string statusFilter, string dateRangeFilter) {
            var d =
                await
                    DocumentHelper.GetAll(statusFilter, dateRangeFilter, HttpContext.User.Identity.Name, DocumentName,
                        Convert);
            return Json(d);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("get")]
        public async Task<JsonResult> Get(long id) {
            return Json(await DocumentHelper.Get<AdvanceTripReportDataEx>(id, HttpContext.User.Identity.Name, DocumentName, Matrix));
        }

        [HttpPost]
        [Route("save")]
        public async Task<JsonResult> Save([ModelBinder(typeof(JsonNetModelBinder))] ReportDataExRequest request) {
            try {
                await SaveAdvanceReportDataEx(request.Data, request.Action);
                return Json(true);
            }
            catch (Exception exception) {
                _logger.Log(LogLevel.Error, exception);
                Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                return Json(exception);
            }
        }

        private static AdvanceReportEntity Convert(AdvanceVersion3 data) {
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

        private async Task SaveAdvanceReportDataEx(AdvanceTripReportDataEx data, string action)
        {
            var actor = DataProvider.GetHuman(HttpContext.User.Identity.Name);
            var attachments = new List<AttachmentVersion2>();
            if (data.ScanPdfsData != null && data.ScanPdfsData.Rows != null && data.ScanPdfsData.Rows.Any())
            {
                foreach (var row in data.ScanPdfsData.Rows)
                {
                    if (row.Data != null && row.Data.Any())
                    {
                        if (row.Urn == null)
                            row.Urn = StorageHelper.SaveFile(row.Name, row.Data);
                        else
                            StorageHelper.Update(row.Urn, row.Data);
                    }
                    row.Url = HttpContext.Request.UrlReferrer.AbsoluteUri + string.Format("Storage/Get?urn={0}", row.Urn);
                    row.Data = null;
                    var attachment = new AttachmentVersion2
                    {
                        Urn = row.Urn,
                        ContentType = DataProvider.GetMime(System.IO.Path.GetExtension(row.Name).TrimStart('.'))
                    };
                    attachments.Add(attachment);
                }
            }
            var insertData = await DocumentHelper.ProcessDocument(data, DocumentName, data.MainData.Date.HasValue ? new DateTimeOffset(data.MainData.Date.Value) : DateTimeOffset.Now,
                data.TripCostsData.Options.Sum, DocumentName, action, actor,
                HttpContext.Request.UrlReferrer.AbsoluteUri, data.DenyReason, Matrix, SubProcessResolver);
            data.Id = insertData.Id;
            data.Number = insertData.Number;
            if (attachments.Any())
            {
                var list = await DataProvider.UpdateAttachments(insertData.Id, attachments);
                foreach (var item in list) StorageHelper.Delete(item);
            }
            if (insertData.Notifications != null && insertData.Notifications.Any())
            {
                foreach (var item in insertData.Notifications)
                {
                    var owner = await DataProvider.ReadAdvanceCreatorAsync(data.Id);
                    var maildata = AdvanceTripReportMailData.Create(HttpContext.Request.UrlReferrer.AbsoluteUri, item.Notification, action, owner, actor, data.DenyReason, data);
                    MailWorker.Queuing(maildata, typeof(AdvanceTripReportMailData), item);
                }
            }
        }

        string SubProcessResolver(Human human) {
            return "A";
        }


        [HttpGet]
        [Route("printMemo")]
        public async Task<FileContentResult> PrintMemo(long id)
        {
            try
            {
                var format = "EXCELOPENXML";
                MemorandumReportData datHdr;

                var re1 = await DocumentHelper.Get<AdvanceTripReportDataEx>(id, HttpContext.User.Identity.Name, DocumentName, Matrix);

                var re2 = await DataProvider.ReadAdvanceSimple(re1.MainData.TripRequest.Id);

                datHdr = Mapper.Map<Advance, MemorandumReportData>(re2);
                Mapper.Map<AdvanceTripReportDataEx, MemorandumReportData>(re1, datHdr);
                if (datHdr != null)
                {
                    var m2 = new List<MemorandumReportData> { datHdr };
                    var m3 = datHdr.Scans;

                    var report = "Memorandum.rdlc";
                    var path = HostingEnvironment.MapPath($"~/{AppSettings.ReportTemplatesFolder}/{report}");
                    var reportData = ReportBuilder.BuildReport(path, new List<object> { m2, m3 }, format);
                    var r = new FileContentResult(reportData.Item2, "application/octet-stream") { FileDownloadName = Server.UrlPathEncode("Служебная записка.XLSX") };
                    return r;
                }
                throw new HttpException((int)HttpStatusCode.NotFound, $"{id} not found");
            }
            catch (Exception exception)
            {
                _logger.Log(LogLevel.Error, exception);
                throw;
            }
        }
    }

    public class ReportDataExRequest: EntitiesBase {
        [JsonProperty(PropertyName = "action")]
        public string Action { get; set; }
        [JsonProperty(PropertyName = "data")]
        public AdvanceTripReportDataEx Data { get; set; }
    }
    
    public class AdvanceTripReportMailData : MailData {
        private decimal Sum { get; set; }
        public static AdvanceTripReportMailData Create(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, AdvanceTripReportDataEx data) {
            return new AdvanceTripReportMailData(baseUrl, notificationItem, action, owner, actor, comment, data) {
                Number = data.Number,
                Sum = 0
            };
        }

        private AdvanceTripReportMailData(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, EntitiesBase entiti)
            : base(baseUrl, notificationItem, action, owner, actor, comment, entiti) { }
    }

    public class AdvanceTripReportDataEx : EntitiesBase {
        public AdvanceTripReportDataEx() {
            MainData = new TripReportMainData();
            TripCostsData = new RowOptionsDataCollection<TripCostsRow, TripCostsOptions>();
            ScanPdfsData = new RowOptionsDataCollection<TripRequestDataEx.ScanPdfRow, TripReportScanPdfOptions>();
        }
        [JsonProperty(PropertyName = "reportMainData")]
        public TripReportMainData MainData { get; set; }

        [JsonProperty(PropertyName = "tripCostsData")]
        public RowOptionsDataCollection<TripCostsRow, TripCostsOptions> TripCostsData { get; set; }

        [JsonProperty(PropertyName = "scanPdfsData")]
        public RowOptionsDataCollection<TripRequestDataEx.ScanPdfRow, TripReportScanPdfOptions> ScanPdfsData { get; set; }

        [JsonProperty(PropertyName = "isFlagAccountant")]
        public bool IsFlagAccountant { get; set; }

        /*
            UPDATE [valeant].[matrix_version_3] SET condition = 'iif(owner.FlagOne AND document.Check2NdLevel(owner), true, false)' WHERE id = 106
            UPDATE [valeant].[matrix_version_3] SET condition = 'iif(owner.FlagOne AND document.Check2NdLevel(owner), false, true)' WHERE id = 107 
        */
        public bool Check2NdLevel(Human owner) {
            var limits = DataProvider.ReadLimitItemCollection(DocumentType.TripReport, owner.PositionGroupId);
            if (TripCostsData.Rows.Any(x => limits.Any(y => y.Name == x.CostItem.Name & x.Sum > y.Limit))) 
                return true;
            var absenseCostItems = TripCostsData.Rows.Where(x => x.Adbsense);
            return absenseCostItems.Any(x => x.Sum > (decimal)500.00);
        }

        public bool CheckOtherCosts() {
            return TripCostsData.Rows.FirstOrDefault(x => x.CostItem.Name.Equals("Прочие расходы", StringComparison.InvariantCultureIgnoreCase)) != null;
        }

        public bool CheckHwoIs(Human owner) {
            var commercialDepartmentCode = DataProvider.Settings["commercial_department_code"].Value;
            var commdepartment = owner.DepartmentParentsCodes.Contains(commercialDepartmentCode);
            var maxSumm = decimal.Parse(DataProvider.Settings["commercial_department_cost_max"].Value);
            var sum = TripCostsData.Rows.Sum(x => x.Sum);
            if (sum < maxSumm)
                return !commdepartment;
            return true;
        }

        public bool UpdateFlagAccountant(bool flagValue)
        {
            IsFlagAccountant = flagValue;
            return flagValue;
        }
    }

    public class TripReportScanPdfOptions : IOptions
    {
    }

    public class TripReportMainData {
        public TripReportMainData()
        {
            Date = DateTime.Now;
        }

        [JsonProperty(PropertyName = "tripRequest")]
        public TripRequestData TripRequest { get; set; }

        [JsonProperty(PropertyName = "tripType")]
        public string TripType { get; set; }

        [JsonProperty(PropertyName = "serviceVehicle")]
        public bool ServiceVehicle { get; set; }

        [JsonProperty(PropertyName = "date")]
        public DateTime? Date { get; set; }

        [JsonProperty(PropertyName = "comment")]
        public string Comment { get; set; }

        [JsonProperty(PropertyName = "person")]
        public Human Person { get; set; }
    }

    public class TripCostsOptions : IOptions {
        public TripCostsOptions()
        {
            Sum = 0;
        }

        [JsonProperty(PropertyName = "sum")]
        public decimal Sum { get; set; }
    }

    public class TripCostsRow : IRow {
        [JsonProperty(PropertyName = "index")]
        public int Order { get; set; }

        [JsonProperty(PropertyName = "documentType")]
        public DocumentTypeReference DocumentType { get; set; }

        [JsonProperty(PropertyName = "costItem")]
        public CostItemReference CostItem { get; set; }

        [JsonProperty(PropertyName = "accountGroup")]
        public AccountGroupReference AccountGroup { get; set; }

        [JsonProperty(PropertyName = "date")]
        public DateTime? Date { get; set; }

        [JsonProperty(PropertyName = "documentNumber")]
        public string DocumentNumber { get; set; }

        [JsonProperty(PropertyName = "sum")]
        public decimal Sum { get; set; }

        [JsonProperty(PropertyName = "absence")]
        public bool Adbsense { get; set; }

        [JsonProperty(PropertyName = "fiscal")]
        public bool Fiscal { get; set; }

        [JsonProperty(PropertyName = "credit")]
        public string Credit { get; set; }

        [JsonProperty(PropertyName = "debit")]
        public string Debit { get; set; }

    }
}
