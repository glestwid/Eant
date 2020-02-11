using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Data.Matrix;
using Valeant.Sp.UprsWeb.Controllers.Entities;

namespace Valeant.Sp.UprsWeb.Mail {
    public class MailData {
        public string AllListUrl { get; set; }
        public string AdvanceUrl { get; set; }
        public string OwnerFullName { get; set; }
        public string ActorFullName { get; set; }
        public string OwnerCode { get; set; }
        public string ActorCode { get; set; }
        public long Number { get; set; }
        public string Comment { get; set; }
        public string ServiceTel => DataProvider.GetSetting("ServiceTelephoneNumber") ?? string.Empty;
        public string ServiceEmail => DataProvider.GetSetting("ServiceEmal") ?? string.Empty;
        public string Media => "@media";
        public MailData(string baseUrl, NotificationVersion3 notificationItem, string action, Human owner, Human actor, string comment, EntitiesBase entity)
        {
            AllListUrl = $"{baseUrl}{notificationItem.AllListUrlPart}";
            AdvanceUrl = $"{baseUrl}{string.Format(notificationItem.DocumentPart, entity.Id, action)}";
            OwnerFullName = owner.FullName;
            OwnerCode = owner.Code;
            ActorFullName = actor.FullName;
            ActorCode = actor.Code;
            Number = entity.Number;
            Comment = comment;
        }
    }
}