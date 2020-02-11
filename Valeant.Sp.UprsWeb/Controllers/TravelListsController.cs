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
using System.Web.Hosting;
using Valeant.Sp.Uprs.Report;
using Valeant.Sp.Uprs.Report.Data;


namespace Valeant.Sp.UprsWeb.Controllers
{
    public class TravelListsController : JsonNetController
    {
        readonly Logger _logger = LogManager.GetCurrentClassLogger();
        private const string DocumentName = "Маршрутный лист";
        private static readonly MatrixVersion3Decorator Matrix;

        private static readonly List<Type> ConditionAdditionalTypes = new List<Type>
                                                                       {
                                                                           typeof (StringComparison),
                                                                           typeof (EntitiesBase),
                                                                           typeof (TravelListDataEx),
                                                                           typeof (Human)
                                                                       };

        private static readonly List<Type> PostFuncAdditionalTypes = new List<Type>
                                                                       {
                                                                           typeof (StringComparison),
                                                                           typeof (DataProvider),
                                                                           typeof (TravelListDataEx),
                                                                           typeof (Human)
                                                                       };

        private static readonly ParameterExpression[] ConditionParameters = {
                                                                        Expression.Parameter(typeof (string), "action"),
                                                                        Expression.Parameter(typeof (Human), "owner"),
                                                                        Expression.Parameter(typeof (Human), "actor"),
                                                                        Expression.Parameter(typeof (TravelListDataEx), "document"),
                                                                        Expression.Parameter(typeof (MatrixVersion3Decorator), "matrix"),
                                                                        Expression.Parameter(typeof(TokenCollection), "tokens")
                                                                    };

        private static readonly ParameterExpression[] PostFuncParameters = {
                                                                                Expression.Parameter(typeof (TravelListDataEx), "document"),
                                                                                Expression.Parameter(typeof (Human), "owner"),
                                                                                Expression.Parameter(typeof (Human), "actor")
                                                                            };

        static TravelListsController()
        {
            var typeName = typeof(TravelListDataExRequest).FullName;
            //ContentFactory.Register(typeName, typeof(TravelListDataExRequest), ReportConvert, "AdvanceReport.rdlc");
            var documentTypeId = DataProvider.DocumentTypesByName[DocumentName];
            Matrix = Matrixs.Get(documentTypeId, ConditionAdditionalTypes, ConditionParameters, PostFuncAdditionalTypes, PostFuncParameters);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll(string statusFilter, string dateRangeFilter)
        {
            TravelListData[] data = await DocumentHelper.GetAll(statusFilter, dateRangeFilter, HttpContext.User.Identity.Name, DocumentName, Convert);

            foreach(TravelListData dataItem in data){
                TravelListDataEx dataEx = await DocumentHelper.Get<TravelListDataEx>(dataItem.Id, HttpContext.User.Identity.Name, DocumentName, Matrix);

                if(dataEx.CarData!=null)
                  dataItem.Car = dataEx.CarData.Type;
            }
            
            return Json(data);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("get")]
        public async Task<JsonResult> Get(Int64 id)
        {
            try
            {
                return Json(await DocumentHelper.Get<TravelListDataEx>(id, HttpContext.User.Identity.Name, DocumentName, Matrix));
            }
            catch (AggregateException ex)
            {
                var flatten = ex.Flatten();
                var inner = flatten.InnerExceptions;
                foreach (var e in inner) _logger.Error(e);
                return Json(flatten);
            }
            catch (Exception ex)
            {
                for (Exception e = ex; e != null; e = e.InnerException)
                    _logger.Error(e);
                return Json(ex);
            }
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("create")]
        public async Task<JsonResult> Create()
        {
            return await Task.Run(() =>
            {
                TravelListDataEx data = new TravelListDataEx();

                data.FuelType = new FuelConsumptionReference()
                {
                    CarType ="ВАЗ",
                    ConsumptionSummer =10,
                    ConsumptionWinter =12,
                    FuelGrade = "AИ-92"

                };
                data.RefueledByCard = 10;

                return Json(data);
            });
        }

        [HttpPost]
        [Route("save")]
        public async Task<JsonResult> Save([ModelBinder(typeof (JsonNetModelBinder))] TravelListDataExRequest request)
        {
            try
            {
                await SaveTravelListDataEx(request.Data, request.Action);
                return Json(true);
            }
            catch (Exception ex)
            {
                Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                return Json(ex);
            }
        }

        private async Task SaveTravelListDataEx(TravelListDataEx data, string action)
        {
            var actor = DataProvider.GetHuman(HttpContext.User.Identity.Name);
            var insertData = await DocumentHelper.ProcessDocument(data, DocumentName, DateTimeOffset.Now,
                data.SpentSum, DocumentName, action, actor,
                HttpContext.Request.UrlReferrer.AbsoluteUri, data.DenyReason, Matrix, SubProcessResolver);
            data.Id = insertData.Id;
            data.Number = insertData.Number;
            if (insertData.Notifications != null && insertData.Notifications.Any())
            {
                foreach (var item in insertData.Notifications)
                {
                    var owner = await DataProvider.ReadAdvanceCreatorAsync(data.Id);
                    var maildata = TravelListsMailData.Create(HttpContext.Request.UrlReferrer.AbsoluteUri, item.Notification, action, owner, actor, data.DenyReason, data);
                    MailWorker.Queuing(maildata, typeof(TravelListsMailData), item);
                }
            }
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
                var dateRange = GridFilterHelpers.GetRange(dateRangeFilter);

                var items = await DataProvider.GetTravelListsReportAsync(3,dateRange.DateStart,dateRange.DateEnd);

                //if(items.Count()==0)
                //    throw new System.Web.HttpException((int)HttpStatusCode.NotFound, $"Nothing was found");

                List<TravelListDataForReport> reportItems = new List<TravelListDataForReport>();

               

                foreach(PrepaymentRequestReportLine item in items)
                {
                    Human creator  = DataProvider.ReadHumanByCode(item.CreatorCode);

                    TravelListDataEx dataEx = await DocumentHelper.Get<TravelListDataEx>(item.Id, creator.UserAccount, DocumentName, Matrix);
                    
                    

                    TravelListDataForReport reportItem = new TravelListDataForReport()
                    {
                       Number = item.Number,
                       Date   = item.RequestDate,
                       CodeEmployee = creator.ClockNumber,
                       FIOEmployee = item.CreatorFullName,
                       CityEmployee = item.CreatorCity,
                       Spent  = dataEx.Spent,
                       SpentSum = dataEx.SpentSum,
                       RefueledByCard = dataEx.RefueledByCardSum,
                       RefueledNotByCard = dataEx.RefueledNotByCardSum ?? 0,
                       Overspent            = dataEx.OverSpent ?? 0 ,
                       Status  = item.RequestStatus,
                       StatusComment = item.StatusComment,
                       Car = dataEx.CarData!=null ? dataEx.CarData.Type:"",
                       CarRegNumber = dataEx.CarData!=null ? dataEx.CarData.Number :""
                     };
                    reportItems.Add(reportItem);

                }

                var report = "TravelLists.rdlc";
                var path = HostingEnvironment.MapPath($"~/{AppSettings.ReportTemplatesFolder}/{report}");
                var reportData = ReportBuilder.BuildReport(path, reportItems, format);
                var r = new FileContentResult(reportData.Item2, reportData.Item1) { FileDownloadName = "TravelLists.xlsx" };
                return r;
            }
            catch (Exception exception)
            {
                _logger.Log(LogLevel.Error, exception);
                throw;
            }
        }

        [HttpGet]
        [Route("exportOverspents")]
        public async Task<FileContentResult> ExportOverspents(string dateRangeFilter)
        {
            if (dateRangeFilter == null || dateRangeFilter == "undefined")
                dateRangeFilter = string.Empty;
            try
            {
                var format = "EXCELOPENXML";
                var dateRange = GridFilterHelpers.GetRange(dateRangeFilter);

                var items = await DataProvider.GetTravelListsReportAsync(3, dateRange.DateStart, dateRange.DateEnd);


                List<OverspentDataForReport> reportItems = new List<OverspentDataForReport>();

                foreach (PrepaymentRequestReportLine item in items)
                {
                    Human creator = DataProvider.ReadHumanByCode(item.CreatorCode);

                    TravelListDataEx dataEx = await DocumentHelper.Get<TravelListDataEx>(item.Id, creator.UserAccount, DocumentName, Matrix);

                    if (dataEx.OverSpent >0)
                    {

                        OverspentDataForReport reportItem = new OverspentDataForReport()
                        {
                        
                            Date = item.RequestDate,
                            FIOEmployee = item.CreatorFullName,
                            CostCenter = creator.CostcenterCode,
                            Overspent = dataEx.OverSpent
                        };
                        reportItems.Add(reportItem);
                    }

                }

                //if (reportItems.Count() == 0)
                //    throw new System.Web.HttpException((int)HttpStatusCode.NotFound, $"Nothing was found");

                var report = "Overspents.rdlc";
                var path = HostingEnvironment.MapPath($"~/{AppSettings.ReportTemplatesFolder}/{report}");
                var reportData = ReportBuilder.BuildReport(path, reportItems, format);
                var r = new FileContentResult(reportData.Item2, reportData.Item1) { FileDownloadName = "Overspents.xlsx" };
                return r;
            }
            catch (Exception exception)
            {
                _logger.Log(LogLevel.Error, exception);
                throw;
            }
        }



        string SubProcessResolver(Human human) {
            return "A";
        }

        private static  TravelListData Convert(AdvanceVersion3 data)
        {
           
         
            return new TravelListData
            {
                Id = data.Id,
                Date = data.Date.DateTime,
                Number = data.Number,
                Status = data.Status,               
                Sum = data.Sum
            };
        }

        public class TravelListsMailData : MailData
        {
            private decimal Sum { get; set; }
            public static TravelListsMailData Create(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, TravelListDataEx data)
            {
                return new TravelListsMailData(baseUrl, notificationItem, action, owner, actor, comment, data)
                {
                    Number = data.Number,
                    Sum = data.SpentSum
                };
            }

            private TravelListsMailData(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, EntitiesBase entiti)
                : base(baseUrl, notificationItem, action, owner, actor, comment, entiti)
            {
            }
        }
    }
    

    public class TravelListDataExRequest
    {
        [JsonProperty(PropertyName = "action")]
        public string Action { get; set; }

        [JsonProperty(PropertyName = "data")]
        public TravelListDataEx Data { get; set; }
    }
}