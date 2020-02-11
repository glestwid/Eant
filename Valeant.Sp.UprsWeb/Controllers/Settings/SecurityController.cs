using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Mvc;

using NLog; 

using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Filters;
using Valeant.Sp.UprsWeb.Security;


namespace Valeant.Sp.UprsWeb.Controllers
{
    public class SecurityController : JsonNetController
    {
        readonly Logger _logger = LogManager.GetCurrentClassLogger();

        [AllowJsonGet]
        [HttpGet]
        [Route("getHumans")]
        public JsonResult GetHumans(string statusesString, string search)
        {
            if (search == null)
                search = string.Empty;

            return Json(DataProvider.Humans.Where(x => x.FullName.Contains(search, StringComparison.OrdinalIgnoreCase)));
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getRoles")]
        public JsonResult GetRoles()
        {
            var roles = DataProvider.ReadRoles();
            return Json(roles);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getAccessList")]
        public async Task<JsonResult> GetAccessList(string requestType, string formAction = "Просмотр", Int64 id = -1)
        {
            string state;
            if (id == -1)
            {
                if (formAction == "Создать, Отправить") formAction = "Создать";
                state = null;
            }
            else {
                var advance = await DataProvider.ReadAdvanceSimple(id);
                requestType = advance.Type;
                state = advance.Status;
            }
            var stateMaps = DataProvider.GetStateMap(requestType).Values.ToList();
            var human = DataProvider.GetHuman(HttpContext.User.Identity.Name);
            var stateMapItems = stateMaps.Where(x => ((state != null && x.From.Item != null && x.From.Item.Name == state) || (state == null && x.From.Item == null))
                && x.Action.Name.Equals(formAction, StringComparison.InvariantCultureIgnoreCase));
            var accessLists = stateMapItems.SelectMany(x => x.AccessList);
            var accessList = accessLists.FirstOrDefault(x => human.Tokens.Select(y => y.Type).Contains(x.Token) ||
                ((x.Token.StartsWith("R-") || x.Token.StartsWith("G-")) && human.Tokens.Select(y => y.Value).Contains(x.Token)));

            if (accessList == null) return null;
            var result = accessList.AccessList.ToDictionary(x => x.Key, x => Enum.Parse(typeof(Entities.AccessAction), x.Value));
            return Json(result);
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getCurrent")]
        public JsonResult GetCurrent()
        {
            return Json(DataProvider.GetHuman(HttpContext.User.Identity.Name));
        }

        [AllowJsonGet]
        [HttpGet]
        [Route("getOwner")]
        public async Task<JsonResult> GetOwner(long id) {
            return Json(await DataProvider.ReadAdvanceCreatorAsync(id));
        }

        [ValeantAuthorize(RoleCodes = "R-00000006")]
        [HttpPost]
        [Route("updateRoles")]
        public async Task UpdateRoles([ModelBinder(typeof(JsonNetModelBinder))] Human human)
        {
            await DataProvider.UpdateHuman(human);
        }

        [ValeantAuthorize(RoleCodes = "R-00000006")]
        [HttpPost]
        [Route("save")]
        public async Task<JsonResult> Save([ModelBinder(typeof(JsonNetModelBinder))] Human person)
        {
            try
            {
                var oldPerson = DataProvider.GetHuman(HttpContext.User.Identity.Name);
                await DataProvider.UpdateHumanProfile(person);
                oldPerson.Tel = person.Tel;
                oldPerson.LoyaltyCards = person.LoyaltyCards;
                oldPerson.InternationalPassport = person.InternationalPassport;
                return Json(true);
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                return Json(ex);
            }
        }
    }
}