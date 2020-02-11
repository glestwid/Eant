namespace Valeant.Sp.Uprs.Data.Domain {
    public class SelectorItem {
        public long Id { get; set; }
        public long DocumentId { get; set; }
        public string DocumentName { get; set; }
        public long SelectorId { get; set; }
        public string SelectorName { get; set; }
        public long? NextStateId { get; set; }
        public string NextStateName { get; set; }
        public long? NextSelectorId { get; set; }
        public string NextSelectorName { get; set; }
        public int Result { get; set; }
        public long? NotificationId { get; set; }
        public NotificationItem Notification { get; set; }
    }
}
