namespace Valeant.Sp.Uprs.Data.Domain {
    public class StateMapItem {
        public long Id { get; set; }
        public long DocumentId { get; set; }
        public string DocumentName { get; set; }
        public long ActionId { get; set; }
        public string ActionName { get; set; }
        public long StateId { get; set; }
        public string StateName { get; set; }
        public long? NextStateId { get; set; }
        public string NextStateName { get; set; }
        public string Description { get; set; }
        public long? SelectorId { get; set; }
        public string SelectorName { get; set; }
        public long? NotificationId { get; set; }
        public NotificationItem Notification { get; set; }
    }
}
