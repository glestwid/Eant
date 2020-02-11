using System;
using System.Collections.Generic;
using NLog;
using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.Uprs.Data.Domain;
using System.Web.Configuration;
using Newtonsoft.Json;
using System.IO;
using System.Data;
using System.Globalization;

namespace Valeant.Sp.UprsWeb.Controllers
{

    public class LoadData
    {
            [JsonProperty(PropertyName = "name")]
            public string Name { get; set; }

            [JsonProperty(PropertyName = "data")]
            public byte[] Data { get; set; }
  
    }
    
     

    public class LoadFuelCardTransactionsController : JsonNetController
    {

        readonly Logger _logger = LogManager.GetCurrentClassLogger();

        readonly  List<string> ignoreList = new List<string>() { "Итого", "report total:" };

        private static HumanCollection humans = DataProvider.Humans;  


        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            return await Task.Run(() =>
            {
                LoadInfo data =new LoadInfo() { Success =true, Message=""} ;

         
            return Json(data);
            });

        }

        [HttpPost]
        [Route("loadData")]
        public async Task<JsonResult> loadData([ModelBinder(typeof(JsonNetModelBinder))] LoadData item)
        {
            int recCount = 0;
            LoadInfo response =null;

            return await Task.Run(() =>
            {
                if (item.Data == null)
                    return Json(false);


                MemoryStream inputStream = new MemoryStream(item.Data);

                if (loadDataTable(inputStream, out recCount)) {
                    string message;
                    if (recCount > 0)
                        message = String.Format("Загружено записей {0}", recCount);
                    else
                        message = "Нет новых записей";

                    response = new LoadInfo() { Success = true, Message = message };
                }
                else{ 
                    response = new LoadInfo() { Success = false, Message = String.Format("Ошибка загрузки данных!", recCount) };
                }
                return Json(response);
            });

        }

        private bool loadDataTable(MemoryStream inputStream, out int res)
        {
            int count = 0;
            
            res = 0;
            
            try
            {
                DataSet ds = CSVDataSet.GetData(inputStream);
                long number = 0;
                string name ="";

                DateTimeFormatInfo dateFormat = new CultureInfo("ru-RU", false).DateTimeFormat;
                NumberFormatInfo   numberFormat = new CultureInfo("ru-RU", false).NumberFormat;

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    if (ignoreList.Contains(row[0].ToString()))
                        continue;

                    long  val;
                    Human holder = null;
                   
                    if (Int64.TryParse(row[0].ToString(), out val))
                        number = val;
                    if (row[1].ToString().Length > 0)
                        name = row[1].ToString();

                    holder = getHumanByCard(number);

                   

                    if (number != 0 )
                    {
                        FuelCardTransaction fuelCardTransaction = new FuelCardTransaction()
                        {
                            CardNumber = number,
                            CardHolder = holder,
                            CardHolderName = name,
                            Time = System.DateTime.Parse(row[2].ToString() + " " + row[3].ToString(),dateFormat),
                            Terminal = row[4].ToString(),
                            Product = row[5].ToString(),
                            Quantity = (row[6].ToString().Length > 0) ? Convert.ToDecimal(row[6], numberFormat) : 0,
                            Ammount = (row[7].ToString().Length > 0) ? Convert.ToDecimal(row[7], numberFormat) : 0,
                            FullAmmount = (row[8].ToString().Length > 0) ? Convert.ToDecimal(row[8], numberFormat) : 0,
                            Discount = (row[9].ToString().Length > 0) ? Convert.ToDecimal(row[9], numberFormat) : 0,

                        };

                        DataProvider.InsertFuelCardTransaction(fuelCardTransaction);
                        count++;
                    }


                }
            }
            catch (Exception e)
            {
                _logger.Error(e);
             
                return false;
            }

            res = count;
            return true;


        }


        private Human getHumanByCard(long cardNumber)
        {
            foreach (Human h in DataProvider.Humans)
            {
                if (h.FuelCard == cardNumber)
                    return h;

            }
            return null;
        }

    

    }
}