namespace Valeant.Sp.Uprs.Data.Domain {
    public class TableNode : Node {
        public HeaderNodeCollection Headers { get; set; }
        public RowNodeCollection Rows { get; set; }
    }
}
