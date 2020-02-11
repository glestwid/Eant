using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Net;
using System.Threading.Tasks;
using System.Web.Mvc;
using Newtonsoft.Json;
using NLog;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Data.Matrix;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Helpers;
using Valeant.Sp.UprsWeb.Mail;
using Valeant.Sp.UprsWeb.Matrix;

namespace Valeant.Sp.UprsWeb.Controllers
{
    public class RepresentativeAdvanceReportController : JsonNetController {
        readonly Logger _logger = LogManager.GetCurrentClassLogger();
        private const string DocumentName = "Авансовый отчет по представительским и текущим расходам";
        private static readonly MatrixVersion3Decorator Matrix;

        private static readonly List<Type> ConditionAdditionalTypes = new List<Type> {
                                                                           typeof (StringComparison),
                                                                           typeof (EntitiesBase),
                                                                           typeof (AdvanceRepresentativeReportDataEx),
                                                                           typeof (Human)
                                                                       };

        private static readonly List<Type> PostFuncAdditionalTypes = new List<Type> {
                                                                           typeof (StringComparison),
                                                                           typeof (DataProvider),
                                                                           typeof (AdvanceRepresentativeReportDataEx),
                                                                           typeof (Human)
                                                                       };

        private static readonly ParameterExpression[] ConditionParameters = {
                                                                        Expression.Parameter(typeof (string), "action"),
                                                                        Expression.Parameter(typeof (Human), "owner"),
                                                                        Expression.Parameter(typeof (Human), "actor"),
                                                                        Expression.Parameter(typeof (AdvanceRepresentativeReportDataEx), "document"),
                                                                        Expression.Parameter(typeof (MatrixVersion3Decorator), "matrix"),
                                                                        Expression.Parameter(typeof(TokenCollection), "tokens")
                                                                    };

        private static readonly ParameterExpression[] PostFuncParameters = {
                                                                                Expression.Parameter(typeof (AdvanceRepresentativeReportDataEx), "document"),
                                                                                Expression.Parameter(typeof (Human), "owner"),
                                                                                Expression.Parameter(typeof (Human), "actor")
                                                                            };

        static RepresentativeAdvanceReportController() {
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
        public async Task<JsonResult> Get(long id)
        {
            return Json(await DocumentHelper.Get<AdvanceRepresentativeReportDataEx>(id, HttpContext.User.Identity.Name, DocumentName, Matrix));
        }

        [HttpPost]
        [Route("save")]
        public async Task<JsonResult> Save([ModelBinder(typeof(JsonNetModelBinder))] RepresentativeReportDataExRequest request) {
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

        private async Task SaveAdvanceReportDataEx(AdvanceRepresentativeReportDataEx data, string action) {
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
                data.CostsData.Options.SumFiscal + data.CostsData.Options.SumNoFiscal, DocumentName, action, actor,
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
                    var maildata = RepresentativeReportMailData.Create(HttpContext.Request.UrlReferrer.AbsoluteUri, item.Notification, action, owner, actor, data.DenyReason, data);
                    MailWorker.Queuing(maildata, typeof(RepresentativeReportMailData), item);
                }
            }
        }

        string SubProcessResolver(Human human) {
            return "A";
        }

        private static AdvanceReportEntity Convert(AdvanceVersion3 data) {
            return new AdvanceReportEntity {
                Id = data.Id,
                Date = data.Date.DateTime,
                Number = data.Number,
                Status = data.Status,
                Sum = data.Sum,
                Type = data.Type
            };
        }
    }

    public class RepresentativeReportDataExRequest
    {
        [JsonProperty(PropertyName = "action")]
        public string Action { get; set; }
        [JsonProperty(PropertyName = "data")]
        public AdvanceRepresentativeReportDataEx Data { get; set; }
    }

    public class RepresentativeReportMailData : MailData
    {
        private decimal Sum { get; set; }
        public static RepresentativeReportMailData Create(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, AdvanceRepresentativeReportDataEx data)
        {
            return new RepresentativeReportMailData(baseUrl, notificationItem, action, owner, actor, comment, data)
            {
                Number = data.Number,
                Sum = 0
            };
        }

        private RepresentativeReportMailData(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, EntitiesBase entiti)
            : base(baseUrl, notificationItem, action, owner, actor, comment, entiti)
        { }
    }

    public class AdvanceRepresentativeReportDataEx : EntitiesBase
    {
        public AdvanceRepresentativeReportDataEx()
        {
            MainData = new RepresentativeReportMainData();
            ScanPdfsData = new RowOptionsDataCollection<TripRequestDataEx.ScanPdfRow, TripReportScanPdfOptions>();
            CostsData = new RowOptionsDataCollection<CostsRow, CostsOptions>();
            ThirdPartyOccasionsData = new RowOptionsDataCollection<ThirdPartyRow, ThirdPartyOptions>();
            CorporateOccasionsData = new RowOptionsDataCollection<CorporateOccasionRow, CorporateOccasionOptions>();
            GiftsData = new RowOptionsDataCollection<GiftRow, GiftOptions>();
        }
        [JsonProperty(PropertyName = "reportMainData")]
        public RepresentativeReportMainData MainData { get; set; }

        [JsonProperty(PropertyName = "scanPdfsData")]
        public RowOptionsDataCollection<TripRequestDataEx.ScanPdfRow, TripReportScanPdfOptions> ScanPdfsData { get; set; }

        [JsonProperty(PropertyName = "costsData")]
        public RowOptionsDataCollection<CostsRow, CostsOptions> CostsData { get; set; }

        [JsonProperty(PropertyName = "thirdPartyOccasionsData")]
        public RowOptionsDataCollection<ThirdPartyRow, ThirdPartyOptions> ThirdPartyOccasionsData { get; set; }

        [JsonProperty(PropertyName = "corporateOccasionsData")]
        public RowOptionsDataCollection<CorporateOccasionRow, CorporateOccasionOptions> CorporateOccasionsData { get; set; }

        // todo: добавить коллекцию строк подарков
        [JsonProperty(PropertyName = "giftsData")]
        public RowOptionsDataCollection<GiftRow, GiftOptions> GiftsData { get; set; }

        public bool UpdateCost() {
            var result = false;
            foreach (var item in from item in CostsData.Rows let r = item.CostItem select item) {
                //item.CostItem.RoleCode = DataProvider.CheckCostItem(item.CostItem.Name);
                item.CostItem.Approve = item.CostItem.RoleCode == null;
                result = true;
            }
            return result;
        }

        public bool UpdateCost(Human human) {
            var result = false;
            var costs = from item in CostsData.Rows let r = item.CostItem where !r.Approve select r;
            foreach (var cost in costs) {
                if (human.Tokens.Select(x => x.Value).Contains(cost.RoleCode)) cost.Approve = true;
                result = true;
            }
            return result;
        }

        public bool RoCheck(TokenCollection tokens) {
            var firstNotApproved = (from item in CostsData.Rows let r = item.CostItem select item).FirstOrDefault(x => !x.CostItem.Approve);
            if (firstNotApproved != null) {
                tokens.Add(new Token { Value = firstNotApproved.CostItem.RoleCode, Type = "R" });
                return true;
            }
            return false;
        }

        public bool IsFlagAccountant { get; set; }

        public bool Check2NdLevel()
        {
            return true;
        }

        public bool CheckOtherCosts()
        {
            return true;
        }

        public bool CheckHwoIs()
        {
            return true;
        }

        public bool UpdateFlagAccountant(bool flagValue) {
            IsFlagAccountant = flagValue;
            return flagValue;
        }
    }

    public class GiftOptions : IOptions
    {
    }

    public class GiftRow : IRow
    {
        [JsonProperty(PropertyName = "index")]
        public int Order { get; set; }
        [JsonProperty(PropertyName = "date")]
        public DateTime? Date { get; set; }
        [JsonProperty(PropertyName = "description")]
        public string Description { get; set; }
        [JsonProperty(PropertyName = "reason")]
        public string Reason { get; set; }
        [JsonProperty(PropertyName = "sum")]
        public decimal Sum { get; set; }
        [JsonProperty(PropertyName = "giftReciever")]
        public GiftRecieverReference GiftReciver { get; set; }
        [JsonProperty(PropertyName = "giftRequest")]
        public GiftRequestMetadata GiftRequestMetadata { get; set; }
    }

    public class CorporateOccasionOptions : IOptions
    {
    }

    public class CorporateOccasionRow : IRow
    {
        [JsonProperty(PropertyName = "index")]
        public int Order { get; set; }

        [JsonProperty(PropertyName = "date")]
        public DateTime? Date { get; set; }

        [JsonProperty(PropertyName = "place")]
        public string Place { get; set; }

        [JsonProperty(PropertyName = "aim")]
        public string Aim { get; set; }

        [JsonProperty(PropertyName = "sum")]
        public decimal Sum { get; set; }

        [JsonProperty(PropertyName = "count")]
        public int ParticipantsCount { get; set; }

        [JsonProperty(PropertyName = "average")]
        public decimal Average { get; set; }

    }

    public class ThirdPartyOptions : IOptions
    {
    }

    public class ThirdPartyRow : IRow
    {
        [JsonProperty(PropertyName = "index")]
        public int Order { get; set; }

        [JsonProperty(PropertyName = "date")]
        public DateTime? Date { get; set; }

        [JsonProperty(PropertyName = "city")]
        public string City { get; set; }

        [JsonProperty(PropertyName = "address")]
        public string Address { get; set; }

        [JsonProperty(PropertyName = "organization")]
        public string Organization { get; set; }

        [JsonProperty(PropertyName = "occasionType")]
        public OccasionType OccasionType { get; set; }

        [JsonProperty(PropertyName = "sum")]
        public decimal Sum { get; set; }

        [JsonProperty(PropertyName = "representatives")]
        public int Representatives { get; set; }

        [JsonProperty(PropertyName = "representativesPosition")]
        public string RepresentativesPosition { get; set; }

        [JsonProperty(PropertyName = "theme")]
        public string Theme { get; set; }

        [JsonProperty(PropertyName = "employeeParticipats")]
        public string EmployeeParticipats { get; set; }

    }

    public class OccasionType
    {
        [JsonProperty(PropertyName = "id")]
        public int Id { get; set; }
        [JsonProperty(PropertyName = "Name")]
        public string Name { get; set; }
    }

    public class CostsOptions : IOptions
    {
        public CostsOptions()
        {
            SumFiscal = 0;
            SumNoFiscal = 0;
        }

        [JsonProperty(PropertyName = "sumFiscal")]
        public decimal SumFiscal { get; set; }

        [JsonProperty(PropertyName = "sumNoFiscal")]
        public decimal SumNoFiscal { get; set; }
    }

    public class CostsRow : IRow
    {
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
        public bool Absence{ get; set; }

        [JsonProperty(PropertyName = "fiscal")]
        public bool Fiscal { get; set; }

        [JsonProperty(PropertyName = "credit")]
        public string Credit{ get; set; }

        [JsonProperty(PropertyName = "debit")]
        public string Debit { get; set; }

    }

    public class RepresentativeReportMainData
    {
        public RepresentativeReportMainData()
        {
            Date = DateTime.Now;
        }

        [JsonProperty(PropertyName = "date")]
        public DateTime? Date { get; set; }

        [JsonProperty(PropertyName = "comment")]
        public string Comment { get; set; }

        [JsonProperty(PropertyName = "person")]
        public Human Person { get; set; }
    }
}
