namespace Valeant.Sp.Uprs.Data.Matrix {
    public class DocumentBlockAccessVersion3 {
        public string Name { get; private set; }
        public DocumentBlockAccessTypeVersion3 AccessType { get; private set; }
        public DocumentBlockAccessVersion3(string name, DocumentBlockAccessTypeVersion3 accessType) {
            Name = name;
            AccessType = accessType;
        }
    }
}
