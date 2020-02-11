using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Monads;
using System.Net;
using System.Threading.Tasks;
using System.Web.Mvc;
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
    public class TripRequestsController : JsonNetController {
        readonly Logger _logger = LogManager.GetCurrentClassLogger();
        private const string DocumentName = "Заявка на командировку/служебную поездку";
        private static readonly MatrixVersion3Decorator Matrix;

        private static readonly List<Type> ConditionAdditionalTypes = new List<Type>
                                                                       {
                                                                           typeof (StringComparison),
                                                                           typeof (EntitiesBase),
                                                                           typeof (TripRequestDataEx),
                                                                           typeof (Human)
                                                                       };

        private static readonly List<Type> PostFuncAdditionalTypes = new List<Type>
                                                                       {
                                                                           typeof (StringComparison),
                                                                           typeof (DataProvider),
                                                                           typeof (TripRequestDataEx),
                                                                           typeof (Human)
                                                                       };

        private static readonly ParameterExpression[] ConditionParameters = {
                                                                        Expression.Parameter(typeof (string), "action"),
                                                                        Expression.Parameter(typeof (Human), "owner"),
                                                                        Expression.Parameter(typeof (Human), "actor"),
                                                                        Expression.Parameter(typeof (TripRequestDataEx), "document"),
                                                                        Expression.Parameter(typeof (MatrixVersion3Decorator), "matrix"),
                                                                        Expression.Parameter(typeof(TokenCollection), "tokens")
                                                                    };

        private static readonly ParameterExpression[] PostFuncParameters = {
                                                                                Expression.Parameter(typeof (TripRequestDataEx), "document"),
                                                                                Expression.Parameter(typeof (Human), "owner"),
                                                                                Expression.Parameter(typeof (Human), "actor")
                                                                            };

        static TripRequestsController() {
            var documentTypeId = DataProvider.DocumentTypesByName[DocumentName];
            Matrix = Matrixs.Get(documentTypeId, ConditionAdditionalTypes, ConditionParameters, PostFuncAdditionalTypes, PostFuncParameters);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll(string statusFilter, string dateRangeFilter) {
            return Json(await DocumentHelper.GetAll(statusFilter, dateRangeFilter, HttpContext.User.Identity.Name, DocumentName, Convert));
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getAllForReport")]
        public async Task<JsonResult> GetAllForReport()
        {
           var res = await DocumentHelper.GetAllForReport(HttpContext.User.Identity.Name, DocumentName, Convert);
            return Json(res);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getUnclosed")]
        public async Task<JsonResult> GetUnclosed()
        {
            var query = new DocumentQuery();
            query.DocumentTypes.Add(DocumentType.TripRequest);
            query.DocumentStates.Add(DocumentState.PendingAdvanceStatement);

            var user = DataProvider.GetHuman(HttpContext.User.Identity.Name);
            var userRoleCodes = user.Roles.Select(r => r.Code).ToList();

            if (!userRoleCodes.Contains(RoleCode.Accountant) && !userRoleCodes.Contains(RoleCode.SeniorAccountant))
            {
                query.CreatorId = user.Id;
            }

            var data = await DocumentHelper.GetByQueryAsync(query, ConvertToUnclosed);
            return Json(data);
        }

        private TripRequestInfoDto ConvertToUnclosed(AdvanceVersion3 data)
        {
            var content = DocumentHelper.GetDocumentContent<TripRequestDataEx>(data.Content);
            var firstDestination = content.DestinationsData.Rows.OrderBy(t => t.Period.StartDate).FirstOrDefault();

            return new TripRequestInfoDto
            {
                Id = data.Id,
                CreationDate = data.DateCreate,
                DocumentState = data.Status,
                DocumentType = data.Type,
                Number = data.Number,
                TripStartDate = firstDestination?.Period?.StartDate,
                City = firstDestination?.City
            };
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("get")]
        public async Task<JsonResult> Get(long id) {
            return Json(await DocumentHelper.Get<TripRequestDataEx>(id, HttpContext.User.Identity.Name, DocumentName, Matrix));
        }

        [HttpPost]
        [Route("save")]
        public async Task<JsonResult> Save([ModelBinder(typeof(JsonNetModelBinder))] TripRequestDataExRequest request) {
            try
            {
                await SaveTripRequestDataEx(request.Data, request.Action);
                return Json(true);
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                return Json(ex);
            }
        }

        private static TripRequestData Convert(AdvanceVersion3 data) {
            var content = DocumentHelper.GetDocumentContent<TripRequestDataEx>(data.Content);

            return new TripRequestData {
                Id = data.Id,
                FromDate = data.Date.DateTime,
                DateStart = content.DestinationsData.Rows[0].Period.StartDate.Value.DateTime,
                Number = data.Number,
                TripTypeName = content.MainData.TripType.Name,
                ServiceVehicle = content.MainData.VahicleType.Name == "Служебный автомобиль",
                Status = data.Status,
                Sum = (int)data.Sum,
                DocumentType = data.Type,
                IsOnlyDailyCostsExist = !(content.TrasferRequestsData.Rows.Any() || content.HotelRequestsData.Rows.Any() || content.TicketRequestsData.Rows.Any() )
            };
        }



        private async Task SaveTripRequestDataEx(TripRequestDataEx data, string action) {
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
                    row.Url = $"{HttpContext.Request.UrlReferrer.AbsoluteUri}Storage/Get?urn={row.Urn}";
                    row.Data = null;
                    var attachment = new AttachmentVersion2
                    {
                        Urn = row.Urn,
                        ContentType = DataProvider.GetMime(System.IO.Path.GetExtension(row.Name).TrimStart('.'))
                    };
                    attachments.Add(attachment);
                }
            }
            var insertData = await DocumentHelper.ProcessDocument(data, DocumentName, new DateTimeOffset(data.Date),
                data.DailyCostsData.Options.Sum, DocumentName, action, actor, HttpContext.Request.UrlReferrer.AbsoluteUri, data.DenyReason, Matrix, SubProcessResolver);
            data.Id = insertData.Id;
            data.Number = insertData.Number;
            if (attachments.Any()) {
                var list = await DataProvider.UpdateAttachments(insertData.Id, attachments);
                foreach (var item in list) StorageHelper.Delete(item);
            }
            if (insertData.Notifications != null && insertData.Notifications.Any())
            {
                foreach (var item in insertData.Notifications)
                {
                    var owner = await DataProvider.ReadAdvanceCreatorAsync(data.Id);
                    var maildata = TripMailData.Create(HttpContext.Request.UrlReferrer.AbsoluteUri, item.Notification, action, owner, actor, data.DenyReason, data);
                    MailWorker.Queuing(maildata, typeof(TripMailData), item);
                }
            }
        }

        string SubProcessResolver(Human human) {
            if(human.IsFirstLevel) return "B";
            if (human.IsCeo) return "C";
            return "A";
        }

        internal static Task<int> IntervalMore14Days(EntitiesBase document, TokenCollection tokens) {
            var o = (TripRequestDataEx)document;
            var first = o.DestinationsData.Rows.FirstOrDefault().CheckNullWithDefault(new TripRequestDataEx.DistinationRow() { Period = new Range() }).Period.StartDate; 
            if (!first.HasValue) return Task.FromResult(0);
            var s = first.Value - DateTimeOffset.Now;
            return Task.FromResult(s.Days < 14 ? 1 : 0);
        }

        internal static Task<int> TravelCoordinatorLimitCheker(EntitiesBase document, TokenCollection tokens) {
            var o = (TripRequestDataEx)document;
            return Task.FromResult(o.ScanPdfsData.Options.OverLimit ? 0 : 1);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("createNewTravelNumber")]
        public async Task<JsonResult> CreateNewTravelNumber() {
            var r = await DataProvider.CreateNewTravelNumber();
            return Json(r);
        }

        public class TripMailData : MailData {
            public string TripType { get; set; }
            public List<Trip> Trips { get; set; }
            public string Transport { get; set; }
            public decimal Sum { get; set; }
            public bool DayOff { get; set; }
            public static TripMailData Create(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, TripRequestDataEx data) {
                return new TripMailData(baseUrl, notificationItem, action, owner, actor, comment, data) {
                    TripType = data.MainData.TripType.Name == "Командировка" ? "Заявка на командировку": "Заявка на служебную поездку",
                    Number = data.Number,
                    Trips = data.DestinationsData.Rows.Select(x => new Trip
                    {
                        Date = x.Period.StartDate ?? DateTimeOffset.MinValue,
                        Country = x.Country.Name,
                        City = x.City,
                        Organization = x.Organization,
                        Order = x.Order

                    }).ToList(),
                    Transport = data.MainData.VahicleType.Name,
                    Sum = data.DailyCostsData.Rows.Sum(x => x.Cost),
                    DayOff = data.DestinationsData.Options.IsWeekendDayTrip
                };
            }

            public class Trip {
                public int Order { get; set; }
                public DateTimeOffset Date { get; set; }
                public string Country { get; set; }
                public string City { get; set; }
                public string Organization { get; set; }
                public string ToHtml() {
                    return $"{Order}. {Date.ToString("dd.MM.yyyy")} &nbsp;{Country} &nbsp;{City} &nbsp; {Organization}";
                }
            }

            private TripMailData(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, EntitiesBase entiti)
                : base(baseUrl, notificationItem, action, owner, actor, comment, entiti)
            {
            }
        }

        public class TripRequestDataExRequest {
            [JsonProperty(PropertyName = "action")]
            public string Action { get; set; }

            [JsonProperty(PropertyName = "data")]
            public TripRequestDataEx Data { get; set; }
        }

        /// <summary>
        /// Represent a info line of unclosed trip request collection.
        /// </summary>
        public class TripRequestInfoDto
        {
            /// <summary>
            /// Unique identifier of trip request.
            /// </summary>
            [JsonProperty("id")]
            public long Id { get; set; }

            /// <summary>
            /// Number of trip request.
            /// </summary>
            [JsonProperty("number")]
            public long Number { get; set; }

            /// <summary>
            /// Creation date.
            /// </summary>
            [JsonProperty("creationDate")]
            public DateTimeOffset CreationDate { get; set; }

            /// <summary>
            /// Type of the document.
            /// </summary>
            [JsonProperty("documentType")]
            public string DocumentType { get; set; }

            /// <summary>
            /// City.
            /// </summary>
            [JsonProperty("city")]
            public string City { get; set; }

            /// <summary>
            /// Start date of the first trip place.
            /// </summary>
            [JsonProperty("tripStartDate")]
            public DateTimeOffset? TripStartDate { get; set; }

            /// <summary>
            /// State of the document.
            /// </summary>
            [JsonProperty("documentState")]
            public string DocumentState { get; set; }
        }



        [HttpGet]
        [Route("export")]
        public async Task<FileContentResult> Export(long id)
        {
            try
            {
                var format = "PDF";
               
                var re = await DataProvider.ReadAdvanceSimple(id);

                var datHdr = Mapper.Map<Advance, BusinessTripReportData>(re);
                if (datHdr != null)
                {
                    var m2 = datHdr.Destinations;
                    var m3 = new List<BusinessTripReportData> { datHdr };

                    var report = "BusinessTripReport.rdlc";
                    var path = HostingEnvironment.MapPath($"~/{AppSettings.ReportTemplatesFolder}/{report}");
                    var reportData = ReportBuilder.BuildReport(path, new List<object> { m2, m3 }, format);
                    var r = new FileContentResult(reportData.Item2, "application/octet-stream") { FileDownloadName = Server.UrlPathEncode ("Служебное задание.pdf") };
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


        private static TripRequestFullReportData ConvertFullReportData(AdvanceVersion3 data)
        {
            var content = DocumentHelper.GetDocumentContent<TripRequestDataEx>(data.Content);

            var r= new TripRequestFullReportData
            {
                FIO = content.MainData.Person.FullName,
                Code = content.MainData.Person.Code,
                City = content.MainData.Person.City,
                Number = data.Number,
                Status = data.Status,
                Sum =  data.Sum,
                Comments = content.MainData.Comment
            };
            r.DestinationsData = new List<DestinationRowReportData>();
            foreach (var dr in content.DestinationsData.Rows)
            {
                r.DestinationsData.Add(new DestinationRowReportData()
                {
                    City = dr.City ,
                    Country=dr.Country .Name ,
                    StartDate =dr.Period.StartDate ,
                    EndDate=dr.Period.EndDate  
                });
            }
            return r;
        }

        [HttpGet]
        [Route("printList")]
        public async Task<FileContentResult> PrintList(string statusFilter, string dateRangeFilter)
        {
            try
            {
                var format = "EXCELOPENXML";
                var re2 = await DocumentHelper.GetAll(statusFilter, dateRangeFilter, HttpContext.User.Identity.Name, DocumentName, ConvertFullReportData);
                var re = new List<TripRequestReportData>();
                foreach (var dr in re2)
                {
                    var tobe = Mapper.Map<TripRequestFullReportData, DestinationRowReportData>(dr);
                    foreach (var ddr in dr.DestinationsData )
                    {
                        TripRequestReportData tobe2;
                        tobe2 = Mapper.Map<TripRequestFullReportData, TripRequestReportData>(dr);
                        Mapper.Map<DestinationRowReportData, TripRequestReportData>(ddr, tobe2);
                        re.Add(tobe2);
                    }
                }

                var report = "AllTripRequests.rdlc";
                var path = HostingEnvironment.MapPath($"~/{AppSettings.ReportTemplatesFolder}/{report}");
                var reportData = ReportBuilder.BuildReport(path, new List<object> { re }, format);
                var r = new FileContentResult(reportData.Item2, "application/octet-stream") { FileDownloadName = Server.UrlPathEncode("Заявки на поездки.XLSX") };
                return r;
            }
            catch (Exception exception)
            {
                _logger.Log(LogLevel.Error, exception);
                throw;
            }
        }

    }
}

