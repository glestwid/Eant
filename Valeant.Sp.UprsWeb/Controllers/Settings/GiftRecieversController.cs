using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NLog;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Helpers;

namespace Valeant.Sp.UprsWeb.Controllers
{
    public class GiftRecieversController : JsonNetController
    {
        private readonly Logger _logger = LogManager.GetCurrentClassLogger();
        const string TypeName = "GiftRecievers";

        [AllowJsonGet]
        [HttpGet]
        [Route("getAll")]
        public async Task<JsonResult> GetAll()
        {
            var data = await DataProvider.ReadSimpleDictionaryFullAsync(TypeName);
            var tasks = data.Select(async x => await ConvertGiftReciever(x.Value));
            var res = await Task.WhenAll(tasks);
            return Json(res);
        }

        [HttpPost]
        [Route("create")]
        public Task Create([ModelBinder(typeof(JsonNetModelBinder))] GiftRecieverReference item)
        {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, true), TypeName);
        }

        [HttpPost]
        [Route("update")]
        public Task Update([ModelBinder(typeof(JsonNetModelBinder))] GiftRecieverReference item)
        {
            return DataProvider.InsertOrUpdateSimpleDictionaryAsync(Convert(item, false), TypeName);
        }

        [HttpPost]
        [Route("delete")]
        public Task Delete([ModelBinder(typeof(JsonNetModelBinder))] GiftRecieverReference item)
        {
            return DataProvider.DeleteSimpleDictionaryAsync(item.Id, TypeName);
        }

        public async Task<GiftRecieverReference> ConvertGiftReciever(SimpleDictionaryItem item)
        {
            dynamic advanced = JObject.Parse(item.Advanced);
            var giftRecieverRef = new GiftRecieverReference
            {
                Id = item.Id,
                Name = advanced.Name,
                SecondName = advanced.SecondName,
                MiddleName = advanced.MiddleName,
                Position = advanced.Position,
                Organization = advanced.Organization,
                AgreementNumber = advanced.AgreementNumber,
                GiftRequestIds = advanced.GiftRequestIds == null ? null : JsonConvert.DeserializeObject<List<long>>(advanced.GiftRequestIds.ToString())
            };
            if (giftRecieverRef.GiftRequestIds != null)
            {
                foreach (var id in giftRecieverRef.GiftRequestIds)
                {
                    try
                    {
                        var req = await DocumentHelper.Get<GiftRequestDataEx>(id, HttpContext.User.Identity.Name, GiftRequestsController.DocumentName, GiftRequestsController.Matrix);
                        if (req != null)
                        {
                            var previousGift = new PreviousGiftReference
                            {
                                Sum = req.Sum,
                                GiftDate = req.GiftDate,
                                Description = req.Description
                            };
                            if (giftRecieverRef.PreviousGifts == null)
                                giftRecieverRef.PreviousGifts = new List<PreviousGiftReference>();
                            giftRecieverRef.PreviousGifts.Add(previousGift);
                        }
                    }
                    catch (Exception ex)
                    {
                        _logger.Log(LogLevel.Error, ex);
                    }
                }
            }
            return giftRecieverRef;
        }

        public static SimpleDictionaryItem Convert(GiftRecieverReference item, bool addItem)
        {
            var newSimpleDictionaryItem = new SimpleDictionaryItem
            {
                Id = addItem ? -1 : item.Id,
                Value = item.SecondName + " " + item.Name + " " + item.MiddleName
            };
            dynamic data = new ExpandoObject();
            data.Name = item.Name;
            data.MiddleName = item.MiddleName;
            data.SecondName = item.SecondName;
            data.Organization = item.Organization;
            data.Position = item.Position;
            data.AgreementNumber = item.AgreementNumber;
            data.GiftRequestIds = item.GiftRequestIds;
            newSimpleDictionaryItem.Advanced = JsonConvert.SerializeObject(data);
            return newSimpleDictionaryItem;
        }
    }
}
