namespace Valeant.Sp.Uprs.Data.Matrix {
    public class NotificationVersion3 : MatrixBase {
        public NotificationVersion3(long id, string templateSubject, string templateMessage, string allListUrlPart, string documentPart) : base(id) {
            TemplateSubject = templateSubject;
            TemplateMessage = templateMessage;
            AllListUrlPart = allListUrlPart;
            DocumentPart = documentPart;
        }
        public string TemplateSubject { get; private set; }
        public string TemplateMessage { get; private set; }
        public string AllListUrlPart { get; private set; }
        public string DocumentPart { get; private set; }
    }
}
