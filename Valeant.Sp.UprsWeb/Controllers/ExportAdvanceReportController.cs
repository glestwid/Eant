using System;
using System.Collections.Generic;
using NLog;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using System.Web.Mvc;
using System.Web.Configuration;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Helpers;
using Valeant.Sp.UprsWeb.Matrix;
using Valeant.Sp.UprsWeb.Controllers.Entities;

namespace Valeant.Sp.UprsWeb.Controllers
{
    public class ExportAdvanceReportController : JsonNetController
    {

        readonly Logger _logger = LogManager.GetCurrentClassLogger();

        readonly string ErrorMessage = "Выгрузка не выполнена.";

        readonly string Message = "Выгружено записей: {0}";

        readonly string tripDocumentName = "Авансовый отчет по командировке/служебной поездке";
        readonly string representativeDocumentName = "Авансовый отчет по представительским и текущим расходам";

        private static MatrixVersion3Decorator Matrix;


        [HttpPost]
        [Route("export")]
        public async Task<JsonResult> Export([ModelBinder(typeof(JsonNetModelBinder))]LoginData loginData)
        {
            LoadInfo data;

            try
            {
                int n = await ExportAsync<AdvanceRepresentativeReportDataEx>(representativeDocumentName, loginData.Username, loginData.Password);

                n += await ExportAsync<AdvanceTripReportDataEx>(tripDocumentName, loginData.Username, loginData.Password);

                if (n > 0)
                    data = new LoadInfo(true, String.Format(Message, n));
                else
                    data = new LoadInfo(true, "Нет отчетов для выгрузки");

                return Json(data);
            }
            catch (AggregateException ex)
            {
                var flatten = ex.Flatten();
                var inner = flatten.InnerExceptions;
                foreach (var e in inner)
                    _logger.Error(e);

                data = new LoadInfo(false, ErrorMessage);
            }
            catch (Exception ex)
            {
                for (Exception e = ex; e != null; e = e.InnerException)
                    _logger.Error(e);
                data = new LoadInfo(false, ErrorMessage);
            }

            return Json(data);
        }

        private async Task<int> ExportAsync<T>(string documentName, string userName, string password) where T : EntitiesBase, new()
        {
            Matrix = GetMatrix<T>(documentName);

            HumanCollection humans = DataProvider.Humans;

           
                int count = 0;

                foreach (Human h in humans){

                AdvanceReportEntity[] list = await DocumentHelper.GetAll("Утверждена", "Все", h.UserAccount, documentName, Convert);

                foreach (AdvanceReportEntity advanceReport in list){

                    EntitiesBase data = await DocumentHelper.Get<T>(advanceReport.Id, h.UserAccount, documentName, Matrix);

                    var actor = DataProvider.GetHuman(HttpContext.User.Identity.Name);

                    try
                    {

                        string res;

                        switch (data.GetType().Name)
                        {
                            case "AdvanceTripReportDataEx":
                                res = await ProcessAdvanceTripReportAsync(advanceReport, (AdvanceTripReportDataEx)data, documentName, HttpContext.Request.UrlReferrer.AbsoluteUri, actor, userName, password);

                                break;

                            case "AdvanceRepresentativeReportDataEx":
                                res = await ProcessAdvanceRepresentativeReportAsync(advanceReport, (AdvanceRepresentativeReportDataEx)data, documentName, HttpContext.Request.UrlReferrer.AbsoluteUri, actor, userName, password);

                                break;


                        }

                        count++;
                    }
                    catch (Exception ex)
                    {
                        for (Exception e = ex; e != null; e = e.InnerException)
                            _logger.Error(e);

                        continue;
                    }


                }
                    
                    
                }

                return count;
                      
            

        }

        private async Task<string> ProcessAdvanceRepresentativeReportAsync(AdvanceReportEntity data, AdvanceRepresentativeReportDataEx dataEx, string documentName, string uri, Human actor, string user, string password)
        {
            string url = WebConfigurationManager.AppSettings.Get("CreateAdvanceStatementService");

            NavisionClient.userName = user;
            NavisionClient.password = password;

            string advNo = await NavisionClient.CreateAdvanceStatementHeaderAsync(data, dataEx, url);

            foreach (CostsRow costRow in dataEx.CostsData.Rows)
            {

                await NavisionClient.CreateAdvanceStatementLineAsync(advNo, costRow, url);
            }


            await DocumentHelper.ProcessDocument(dataEx, documentName, dataEx.MainData.Date.HasValue ? new DateTimeOffset(dataEx.MainData.Date.Value) : DateTimeOffset.Now,
                 dataEx.CostsData.Options.SumFiscal + dataEx.CostsData.Options.SumNoFiscal, documentName, "Выгрузить", actor,
                 uri, dataEx.DenyReason, Matrix, SubProcessResolver);


            return advNo;
        }

        private async Task<string> ProcessAdvanceTripReportAsync(AdvanceReportEntity data, AdvanceTripReportDataEx dataEx, string documentName, string uri, Human actor, String user, String password)
        {
            string url = WebConfigurationManager.AppSettings.Get("CreateAdvanceStatementService");

            NavisionClient.userName = user;
            NavisionClient.password = password;


            string advNo = await NavisionClient.CreateAdvanceStatementHeaderAsync(data, dataEx, url);



            foreach (TripCostsRow costRow in dataEx.TripCostsData.Rows)
            {

                await NavisionClient.CreateAdvanceStatementLineAsync(advNo, costRow, url);
            }


            await DocumentHelper.ProcessDocument(dataEx, documentName, dataEx.MainData.Date.HasValue ? new DateTimeOffset(dataEx.MainData.Date.Value) : DateTimeOffset.Now,
                 dataEx.TripCostsData.Options.Sum, documentName, "Выгрузить", actor,
                 uri, dataEx.DenyReason, Matrix, SubProcessResolver);


            return advNo;
        }


        private static MatrixVersion3Decorator GetMatrix<T>(string documentName)
        {
            List<Type> ConditionAdditionalTypes = new List<Type> {
                                                                           typeof (StringComparison),
                                                                           typeof (EntitiesBase),
                                                                           typeof (T),
                                                                           typeof (Human)
                                                                       };

            List<Type> PostFuncAdditionalTypes = new List<Type> {
                                                                           typeof (StringComparison),
                                                                           typeof (DataProvider),
                                                                           typeof (T),
                                                                           typeof (Human)
                                                                       };

            ParameterExpression[] ConditionParameters = {
                                                                        Expression.Parameter(typeof (string), "action"),
                                                                        Expression.Parameter(typeof (Human), "owner"),
                                                                        Expression.Parameter(typeof (Human), "actor"),
                                                                        Expression.Parameter(typeof (T), "document"),
                                                                        Expression.Parameter(typeof (MatrixVersion3Decorator), "matrix"),
                                                                        Expression.Parameter(typeof(TokenCollection), "tokens")
                                                                    };

            ParameterExpression[] PostFuncParameters = {
                                                                                Expression.Parameter(typeof (T), "document"),
                                                                                Expression.Parameter(typeof (Human), "owner"),
                                                                                Expression.Parameter(typeof (Human), "actor")
                                                                            };



            var documentTypeId = DataProvider.DocumentTypesByName[documentName];
            return Matrixs.Get(documentTypeId, ConditionAdditionalTypes, ConditionParameters, PostFuncAdditionalTypes, PostFuncParameters);

        }

        string SubProcessResolver(Human human)
        {
            return "A";
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
    }
}