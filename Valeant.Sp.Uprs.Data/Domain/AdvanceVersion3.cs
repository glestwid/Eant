namespace Valeant.Sp.Uprs.Data.Domain {
    public class AdvanceVersion3 : DocumentBaseVersion3, IContainsMetadata {
        public decimal Sum { get; set; }
        public MetadataCollection Metadata { get; set; }
    }
}
