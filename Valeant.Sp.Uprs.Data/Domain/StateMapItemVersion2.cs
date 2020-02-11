using System.Collections.Generic;

namespace Valeant.Sp.Uprs.Data.Domain {
    public class StateMapItemVersion2 {
        public string DocumentType { get; set; }
        public long Ancestor { get; set; }
        public NodeItemVersion2 From { get; set; }
        public NodeItemVersion2 To { get; set; }
        public ActionVersion2 Action { get; set; }
        public List<AccessListVersion2> AccessList { get; set; }
        public int? Value { get; set; }
        public NotificationItem Notification { get; set; }
    }
}
