using System;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.Uprs.Data.Domain;
using NLog;


namespace Valeant.Sp.UprsWeb.Controllers
{
    public class LedgerEntriesController : JsonNetController
    {


        readonly Logger _logger = LogManager.GetCurrentClassLogger();

        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        
        public async Task<JsonResult> GetAll(string entryType, string dateRangeFilter)
        {
            try
            {
                DateTime? from = null;
                DateTime? to = null;

                if (dateRangeFilter != null){

                    var dateRange = GridFilterHelpers.GetRange(dateRangeFilter);
                    from = dateRange.DateStart.DateTime;
                    to = dateRange.DateEnd.DateTime; 
                }

                var human = DataProvider.GetHuman(HttpContext.User.Identity.Name);

                EmployeeLedgerEntryCollection data = (await DataProvider.ReadEmployeeLedgerEntry(human.NavisionCode,from,to));

                if (entryType != null){
                    int type;

                    if(int.TryParse(entryType,out type)){
                        return Json(data.Where(x =>x.EntryType == type).OrderByDescending(x => x.PostingDate));

                    }

                }
                return Json(data.OrderByDescending(x=> x.PostingDate));
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

        }
      
    }
}