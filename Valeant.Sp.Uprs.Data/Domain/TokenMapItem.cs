namespace Valeant.Sp.Uprs.Data.Domain {
    public class TokenMapItem {
        public long Id { get; set; }
        public long DocumentType { get; set; }
        public string DocumentTypeName { get; set; }
        public string TokenType { get; set; }
        public long State { get; set; }
        public string StateName { get; set; }
    }
}
