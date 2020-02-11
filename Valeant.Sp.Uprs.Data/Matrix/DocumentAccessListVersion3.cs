namespace Valeant.Sp.Uprs.Data.Matrix {
    public class DocumentAccessListVersion3 : MatrixBase {
        public long Documenttype { get; private set; }
        public string Name { get; private set; }
        public string Description { get; private set; }
        public DocumentBlocksAccessVersion3 Details { get; private set; }
        public DocumentAccessListVersion3(long id, long documenttype, string name, string description) : base(id) {
            Documenttype = documenttype;
            Name = name;
            Description = description;
            Details = new DocumentBlocksAccessVersion3();
        }
    }
}
