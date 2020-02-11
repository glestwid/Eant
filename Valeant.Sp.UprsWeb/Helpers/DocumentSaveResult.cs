using System.Collections.Generic;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Data.Matrix;

namespace Valeant.Sp.UprsWeb.Helpers {
    internal class DocumentSaveResult {
        internal long Id { get; set; }
        internal long Number { get; set; }
        internal List<NotificationsData> Notifications { get; set; }
        internal class NotificationsData {
            internal NotificationVersion3 Notification { get; set; }
            internal List<string> Resipients { get; set; }
        }
    }
}