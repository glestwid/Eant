using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Web.Mvc;
using Newtonsoft.Json;
using NLog;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Report;
using Valeant.Sp.Uprs.Report.Data;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Helpers;
using Valeant.Sp.UprsWeb.Matrix;
using System.Xml.Linq;
using Valeant.Sp.Uprs.Data.Matrix;
using Valeant.Sp.UprsWeb.Mail;

namespace Valeant.Sp.UprsWeb.Controllers
{
    public class GiftRequestsController : JsonNetController
    {
        private readonly Logger _logger = LogManager.GetCurrentClassLogger();
        public const string DocumentName = "Заявка на подарок";

        public static readonly MatrixVersion3Decorator Matrix;

        public static readonly List<Type> ConditionAdditionalTypes = new List<Type>
                                                                       {
                                                                           typeof (StringComparison),
                                                                           typeof (EntitiesBase),
                                                                           typeof (GiftRequestDataEx),
                                                                           typeof (Human)
                                                                       };

        public static readonly List<Type> PostFuncAdditionalTypes = new List<Type>
                                                                       {
                                                                           typeof (StringComparison),
                                                                           typeof (DataProvider),
                                                                           typeof (GiftRequestDataEx),
                                                                           typeof (Human)
                                                                       };

        public static readonly ParameterExpression[] ConditionParameters = {
                                                                        Expression.Parameter(typeof (string), "action"),
                                                                        Expression.Parameter(typeof (Human), "owner"),
                                                                        Expression.Parameter(typeof (Human), "actor"),
                                                                        Expression.Parameter(typeof (GiftRequestDataEx), "document"),
                                                                        Expression.Parameter(typeof (MatrixVersion3Decorator), "matrix"),
                                                                        Expression.Parameter(typeof(TokenCollection), "tokens")
                                                                    };

        public static readonly ParameterExpression[] PostFuncParameters = {
                                                                                Expression.Parameter(typeof (GiftRequestDataEx), "document"),
                                                                                Expression.Parameter(typeof (Human), "owner"),
                                                                                Expression.Parameter(typeof (Human), "actor")
                                                                            };


        static GiftRequestsController()
        {
            var typeName = typeof(GiftRequestDataEx).FullName;
            ContentFactory.Register(typeName, typeof(GiftRequestDataEx), ReportConvert, "GiftReport.rdlc");
            var documentTypeId = DataProvider.DocumentTypesByName[DocumentName];
            Matrix = Matrixs.Get(documentTypeId, ConditionAdditionalTypes, ConditionParameters, PostFuncAdditionalTypes, PostFuncParameters);
        }

        public static async Task<object[]> ReportConvert(XElement element)
        {
            var data = DocumentHelper.GetDocumentContent<GiftRequestDataEx>(element);
            var owner = await DataProvider.ReadAdvanceCreatorAsync(data.Id);
            var list = (await DataProvider.ReadApprovedHistoryItemCollectionAsync(data.Id, DocumentName))
                .Aggregate(string.Empty, (current, item) => $"{current}{item.Date.ToString("dd.MM.yyyy HH:mm")} {item.FullName} - {item.Position} - согласовано\r\n");

            var giftReport = new GiftReportData
            {
                Number = data.Number,
                Date = data.Date,

                Reason = data.Reason,
                Description = data.Description,
                GiftReciever = data.GiftReciever.SecondName + " " + data.GiftReciever.Name + " " + data.GiftReciever.MiddleName,
                AgreementNumber = data.GiftReciever.AgreementNumber,
                Position = data.GiftReciever.Position,
                GiftDate = data.GiftDate,
                HumanFrom = owner.FullName,
                Sum = data.Sum,
                Organization = data.GiftReciever.Organization,

                Inn = "",

                OtherGiftsExist = data.OtherGiftsExist,
                OtherGiftsComment = data.OtherGiftsComment,

                ApprovedList = list
            };

            return new object[] { giftReport };
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll(string statusFilter, string dateRangeFilter)
        {
            var items = await DocumentHelper.GetAll(statusFilter, dateRangeFilter, HttpContext.User.Identity.Name, DocumentName, Convert);
            return Json(items);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("get")]
        public async Task<JsonResult> Get(long id)
        {
            try
            {
                var item = await DocumentHelper.Get<GiftRequestDataEx>(id, HttpContext.User.Identity.Name, DocumentName, Matrix);
                return Json(item);
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
        public async Task<JsonResult> Save([ModelBinder(typeof(JsonNetModelBinder))] GiftRequestDataExRequest request)
        {
            try
            {
                if (request.Data.GiftReciever.PreviousGifts == null)
                    request.Data.GiftReciever.PreviousGifts = new List<PreviousGiftReference>(0);
                var giftList = request.Data.GiftReciever.PreviousGifts != null ?
                    request.Data.GiftReciever.PreviousGifts.Where(
                        gift => gift.GiftDate.Value.Year == DateTime.Now.Year).ToList() : new List<PreviousGiftReference>(0);
                var currentYearSum = giftList.Select(u => u.Sum).DefaultIfEmpty(0).Sum();
                var giftSumLimitStr = await DataProvider.ReadSimpleDictionaryFullAsync("GiftSumLimit");
                var giftSumLimit = decimal.Parse(giftSumLimitStr.FirstOrDefault().Value.Advanced);
                var currentGiftSum = request.Data.Sum;
                if (currentYearSum + currentGiftSum + request.Data.OtherGiftsSum > giftSumLimit)
                {
                    //Response.StatusCode = (int) HttpStatusCode.Forbidden;
                    return Json(new {limitErr = "Невозможно создать заявку на подарок из-за превышения лимита подарков данного получателя" }, JsonRequestBehavior.AllowGet);
                }
                await SaveGiftRequestDataEx(request.Data, request.Action);
                return Json(true);
            }
            catch (Exception ex)
            {
                Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                return Json(ex);
            }
        }

        private static GiftRequestMetadata Convert(AdvanceVersion3 data)
        {
            return new GiftRequestMetadata
            {
                Id = data.Id,
                Date = data.Date.DateTime,
                Number = data.Number.ToString(),
                Status = data.Status,
                Sum = data.Sum,
                Fio = data.Metadata != null && data.Metadata.ContainsKey("GiftReciever.FullName") ? data.Metadata["GiftReciever.FullName"] : "Не заполнено",
                Organization = data.Metadata != null && data.Metadata.ContainsKey("GiftReciever.Organization") ? data.Metadata["GiftReciever.Organization"] : "Не заполнено",
                Position = data.Metadata != null && data.Metadata.ContainsKey("GiftReciever.Position") ? data.Metadata["GiftReciever.Position"] : "Не заполнено",
                //Type = data.Type
            };
        }

        private async Task SaveGiftRequestDataEx(GiftRequestDataEx data, string action)
        {
            var actor = DataProvider.GetHuman(HttpContext.User.Identity.Name);
            var metadata = new MetadataCollection {
                                                      {
                                                          "GiftReciever.Position",
                                                          data.GiftReciever.Position ?? "Не заполнено"
                                                      }, {
                                                             "GiftReciever.Organization",
                                                             data.GiftReciever.Organization ?? "Не заполнено"
                                                         }, {
                                                                "GiftReciever.FullName",
                                                                $"{data.GiftReciever.Name} {data.GiftReciever.MiddleName} {data.GiftReciever.SecondName}"
                                                            }
                                                  };


            var insertData = await DocumentHelper.ProcessDocument(data, DocumentName, new DateTimeOffset(data.Date),
                data.Sum, DocumentName, action, actor, HttpContext.Request.UrlReferrer.AbsoluteUri, data.DenyReason, Matrix, SubProcessResolver, metadata);
            data.Id = insertData.Id;
            data.Number = insertData.Number;

            // обновляем получателя
            var giftReciever = data.GiftReciever;
            if (giftReciever.GiftRequestIds == null) giftReciever.GiftRequestIds = new List<long>();
            if (!giftReciever.GiftRequestIds.Contains(data.Id))
            {
                giftReciever.GiftRequestIds.Add(data.Id);
                await DataProvider.InsertOrUpdateSimpleDictionaryAsync(GiftRecieversController.Convert(giftReciever, false), "GiftRecievers");
            }

            if (insertData.Notifications != null && insertData.Notifications.Any())
            {
                foreach (var item in insertData.Notifications)
                {
                    var owner = await DataProvider.ReadAdvanceCreatorAsync(data.Id);
                    var maildata = GiftRequestMailData.Create(HttpContext.Request.UrlReferrer.AbsoluteUri, item.Notification, action, owner, actor, data.DenyReason, data);
                    MailWorker.Queuing(maildata, typeof(GiftRequestMailData), item);
                }
            }
        }

        string SubProcessResolver(Human human)
        {
            return "A";
        }




        [HttpGet]
        [Route("export")]
        public async Task<FileContentResult> Export(string dateRangeFilter)
        {
            if (dateRangeFilter == null || dateRangeFilter == "undefined")
                dateRangeFilter = string.Empty;
            try
            {
                var format = "EXCELOPENXML";
                var contentData = await DocumentHelper.ReadAllGiftRequestMetadataForReport(dateRangeFilter);
                if (contentData.Any())
                {
                    var report = "GiftRequests.rdlc";
                    var path = HostingEnvironment.MapPath($"~/{AppSettings.ReportTemplatesFolder}/{report}");
                    var reportData = ReportBuilder.BuildReport(path, contentData, format);
                    var r = new FileContentResult(reportData.Item2, reportData.Item1) { FileDownloadName = "Report.XLSX" };
                    return r;
                }
                throw new HttpException((int)HttpStatusCode.NotFound, $"Nothing was found");
            }
            catch (Exception exception)
            {
                _logger.Log(LogLevel.Error, exception);
                throw;
            }
        }
    }


    public class GiftRequestMailData : MailData
    {
        private decimal Sum { get; set; }
        public static GiftRequestMailData Create(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, GiftRequestDataEx data)
        {
            return new GiftRequestMailData(baseUrl, notificationItem, action, owner, actor, comment, data)
            {
                Number = data.Number,
                Sum = 0
            };
        }

        private GiftRequestMailData(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, EntitiesBase entiti)
            : base(baseUrl, notificationItem, action, owner, actor, comment, entiti)
        { }
    }



    public class GiftRequestMetadata
    {
        [JsonProperty(PropertyName = "Id")]
        public long Id { get; set; }
        [JsonProperty(PropertyName = "Number")]
        public string Number { get; set; }
        [JsonProperty(PropertyName = "Date")]
        public DateTime? Date { get; set; }
        [JsonProperty(PropertyName = "Fio")]
        public string Fio { get; set; }
        [JsonProperty(PropertyName = "Position")]
        public string Position { get; set; }
        [JsonProperty(PropertyName = "Organization")]
        public string Organization { get; set; }
        [JsonProperty(PropertyName = "Sum")]
        public decimal Sum { get; set; }
        [JsonProperty(PropertyName = "Status")]
        public string Status { get; set; }
    }


    public class GiftRequestDataExRequest
    {
        [JsonProperty(PropertyName = "action")]
        public string Action { get; set; }
        [JsonProperty(PropertyName = "data")]
        public GiftRequestDataEx Data { get; set; }
    }

    public class GiftRequestDataEx : EntitiesBase
    {
        public GiftRequestDataEx()
        {
            Date = DateTime.Now;
            GiftDate = DateTime.Now;
            Sum = 0;
            OtherGiftsSum = 0;
        }

        [JsonProperty(PropertyName = "description")]
        public string Description { get; set; }

        [JsonProperty(PropertyName = "reason")]
        public string Reason { get; set; }

        [JsonProperty(PropertyName = "sum")]
        public decimal Sum { get; set; }

        [JsonProperty(PropertyName = "otherGiftsSum")]
        public decimal OtherGiftsSum { get; set; }

        [JsonProperty(PropertyName = "giftDate")]
        public DateTime? GiftDate { get; set; }

        [JsonProperty(PropertyName = "giftReciever")]
        public GiftRecieverReference GiftReciever { get; set; }

        [JsonProperty(PropertyName = "otherGiftsExist")]
        public bool OtherGiftsExist { get; set; }

        [JsonProperty(PropertyName = "otherGiftsComment")]
        public string OtherGiftsComment { get; set; }
    }

    public class PreviousGiftReference
    {
        [JsonProperty(PropertyName = "giftDate")]
        public DateTime? GiftDate { get; set; }

        [JsonProperty(PropertyName = "description")]
        public string Description { get; set; }

        [JsonProperty(PropertyName = "sum")]
        public decimal Sum { get; set; }

    }
}
