namespace Valeant.Sp.Uprs.Data.Domain {
    public class NotificationItem {
        public long Id { get; set; }
        public string TemplateSubject { get; set; }
        public string TemplateMessage { get; set; }
        public string AllListUrlPart { get; set; }
        public string DocumentPart { get; set; }
    }
}
 