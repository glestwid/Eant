namespace Valeant.Sp.Uprs.Data.Matrix {
    public class IntersectionVersion3 : MatrixBase {
        public NodeVersion3 From { get; private set; }
        public NodeVersion3 To { get; private set; }
        public string Condition { get; private set; }
        public long Document { get; private set; }
        public string PostFunc { get; private set; }
        public ApprovalSheetItem ApprovalSheetItem { get; private set; }
        public bool ClearApprovalSheet { get; private set; }
        public IntersectionVersion3(long id, NodeVersion3 @from, NodeVersion3 to, string condituion, long document, string postFunc, string approvalSheetItem, bool clearApprovalSheet) : base(id) {
            From = @from;
            To = to;
            Condition = condituion;
            Document = document;
            PostFunc = postFunc;
            if(approvalSheetItem != null) ApprovalSheetItem = new ApprovalSheetItem(approvalSheetItem);
            ClearApprovalSheet = clearApprovalSheet;
        }
    }
}
