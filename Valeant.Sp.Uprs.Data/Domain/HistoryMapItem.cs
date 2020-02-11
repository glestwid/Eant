namespace Valeant.Sp.Uprs.Data.Domain {
    public class HistoryMapItem {
        public long Id { get; set; }
        public long ActionId { get; set; }
        public string ActionName { get; set; }
        public long DocumentId { get; set; }
        public string DocumentName { get; set; }
        public string History { get; set; }
    }
}
