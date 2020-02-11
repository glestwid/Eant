namespace Valeant.Sp.Uprs.Data.Domain {
    public class ClosureVersion2 {
        public long Id { get; set; }
        public long Ancestor { get; set; }
        public long? Descendant { get; set; }
        public long? Action { get; set; }
        public int? Value { get; set; }
        public long Type { get; set; }
        public bool Straight { get; set; }
        public long? Notification { get; set; }
    }
}
