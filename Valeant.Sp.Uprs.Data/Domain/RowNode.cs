namespace Valeant.Sp.Uprs.Data.Domain {
    public class RowNode : Node {
        public FieldNodeCollection Fields { get; set; }

        public RowNode() {
            Fields = new FieldNodeCollection();
        }
    }
}
