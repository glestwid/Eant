using System;

namespace Valeant.Sp.UprsWeb.Controllers.Entities {
    public class RequestHistoryData {
        public int Number { get; set; }
        public DateTime CreateDate { get; set; }
        public string Initiator { get; set; }
        public string Message { get; set; }
        public string Comment { get; set; }
    }
}
