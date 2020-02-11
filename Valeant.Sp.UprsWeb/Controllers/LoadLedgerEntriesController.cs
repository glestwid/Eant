using System;
using System.Linq;
using System.Collections.Generic;
using NLog;
using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.Uprs.Data.Domain;
using System.Web.Configuration;
using Valeant.Sp.UprsWeb.Controllers.Entities;

namespace Valeant.Sp.UprsWeb.Controllers
{

    class LoadInfo
    {
        public bool Success { get; set; }
        public string Message { get; set; }

        public EmployeeLedgerEntryCollection Data;

        public LoadInfo( bool success, string message) {
            Success = success;
            Message = message;
        }

        public LoadInfo(){}

    }



    public class LoadLedgerEntriesController : JsonNetController
    {

        readonly Logger _logger = LogManager.GetCurrentClassLogger();

        readonly string ErrorMessage = "Справочник не был обновлен. Сервис недоступен.";

        readonly string Message = "Справочник транзакций обновлен. Загружено записей: {0}";



        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll(string dateRangeFilter)
        {
            LoadInfo data ;

            var dateRange = GridFilterHelpers.GetRange(dateRangeFilter);

            try
            {
               
                EmployeeLedgerEntryCollection ledgerData = (await DataProvider.ReadEmployeeLedgerEntry(null,dateRange.DateStart.DateTime, dateRange.DateEnd.DateTime));
                               

                data = new LoadInfo(true, String.Format(""));

                data.Data = new EmployeeLedgerEntryCollection (ledgerData.OrderByDescending(x=>x.PostingDate));


                return Json(data);
            }
            catch (AggregateException ex)
            {
                var flatten = ex.Flatten();
                var inner = flatten.InnerExceptions;
                foreach (var e in inner)
                    _logger.Error(e);

                data = new LoadInfo(false,ErrorMessage);
            }
            catch (Exception ex)
            {
                for (Exception e = ex; e != null; e = e.InnerException)
                    _logger.Error(e);
                data = new LoadInfo(false, "Ошибка");
            }

            return Json(data);
        }

       

        [HttpPost]
        [Route("update")]
        public async Task<JsonResult> Update([ModelBinder(typeof(JsonNetModelBinder))] LoginData loginData)
        {
           
                LoadInfo data;
             

                try
                {
                    int n = await LoadDataAsync(loginData.Username, loginData.Password);
                                     

                    data = new LoadInfo
                    {
                        Success = true,
                        Message = String.Format(Message, n),
                        
                    };
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

        private async Task<int> LoadDataAsync(string userName, string password)
        {

            long maxNo = await DataProvider.ReadMaxEmployeeLedgerTransactionNoAsync();

            return await Task.Run(() =>
            {
                try
                {
                                       
                    string url = WebConfigurationManager.AppSettings.Get("GetEmployeeLedgerService");

                    NavisionClient.userName = userName;
                    NavisionClient.password = password;

                    int count = 0;

                    

                    foreach (Human h in DataProvider.Humans)
                    {

                        List<EmployeeLedgerEntry> employeeLedgerEntryList = NavisionClient.GetEmployeeLedgerEntriesInc(url, h.NavisionCode,maxNo);

                        foreach (EmployeeLedgerEntry e in employeeLedgerEntryList)
                        {

                            DataProvider.InsertLedgerEntry(e);


                        }
                        count += employeeLedgerEntryList.Count;
                    }


                    return count;
                }
                catch (AggregateException ex)
                {
                    var flatten = ex.Flatten();
                    var inner = flatten.InnerExceptions;
                    foreach (var e in inner)
                        _logger.Error(e);

                    throw flatten;
                }
                catch (Exception ex)
                {
                    for (Exception e = ex; e != null; e = e.InnerException)
                        _logger.Error(e);
                    throw ex;
                }
            });
        }
    }
}