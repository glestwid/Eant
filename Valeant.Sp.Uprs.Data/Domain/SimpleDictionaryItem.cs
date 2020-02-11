namespace Valeant.Sp.Uprs.Data.Domain {
    public class SimpleDictionaryItem {
        public long Id { get; set; }
        public long Type { get; set; }
        public string Value { get; set; }
        public bool Actual { get; set; }
        public string Advanced { get; set; }
        public long? Reference { get; set; }
        public bool? Flag { get; set; }
        public bool? Flag1 { get; set; }
    }
}
