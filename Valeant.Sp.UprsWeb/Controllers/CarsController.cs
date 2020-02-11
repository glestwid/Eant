using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Configuration;
using System.Web.Mvc;
using NLog;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;

namespace Valeant.Sp.UprsWeb.Controllers
{
    internal class CarData
    {
        public CarData(CarCollection cars)
        {
            Cars = cars;
            Success = true;
        }

        public CarData(CarCollection cars, bool success)
        {
            Cars = cars;
            Success = success;
        }

        public bool Success { get; set; }
        public CarCollection Cars { get; set; }
    }


    public class CarsController : JsonNetController
    {
        private readonly Logger _logger = LogManager.GetCurrentClassLogger();

        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            var data = await DataProvider.ReadCarCollectionAsync();
            return Json(new CarData(data));
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getCurrentUserCars")]
        public async Task<JsonResult> GetCurrentUserCars()
        {
            var human = DataProvider.GetHuman(HttpContext.User.Identity.Name);
            var data = await DataProvider.ReadUserCarsAsync(human);
            return Json(data);
        }

        [HttpPost]
        [Route("update")]
        public async Task<JsonResult> Update([ModelBinder(typeof(JsonNetModelBinder))] LoginData loginData)
        {
            var res = await GetListFromNavision(loginData.Username, loginData.Password);
            var data = new CarData(null, res);

            return Json(data);
        }

        private async Task<bool> GetListFromNavision(string userName, string password)
        {
            List<Car> carList;

            var url = WebConfigurationManager.AppSettings.Get("GetCarListService");

            try
            {
                NavisionClient.userName = userName;
                NavisionClient.password = password;

                carList = await NavisionClient.GetCarListAsync(url);
            }
            catch (Exception e)
            {
                _logger.Error(e);

                return false;
            }

            foreach (var car in carList)
            {
                await DataProvider.InsertOrUpdateCarAsync(car);
            }

            return true;
        }
    }
}