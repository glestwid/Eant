using System;

namespace Valeant.Sp.Uprs.Data.Domain
{
    public class HistoryItem {
        public long Id { get; set; }
        public int Number { get; set; }
        public DateTimeOffset Date { get; set; }
        public string FullName { get; set; }
        public string History { get; set; }
        public string Comment { get; set; }
        public bool InReport { get; set; }
    }
}
