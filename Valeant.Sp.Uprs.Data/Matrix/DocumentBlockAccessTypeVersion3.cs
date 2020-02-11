namespace Valeant.Sp.Uprs.Data.Matrix {
    public class DocumentBlockAccessTypeVersion3 : MatrixBase {
        public string Name { get; private set; }
        public string Description { get; private set; }
        public DocumentBlockAccessTypeVersion3(long id, string name, string description) : base(id) {
            Name = name;
            Description = description;
        }
    }
}
