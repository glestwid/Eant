namespace Valeant.Sp.Uprs.Data.Matrix {
    public class StateVersion3 : MatrixBase {
        public string Name { get; private set; }
        public string Title { get; private set; }
        public string ApprovalSheetTitle { get; private set; }
        public StateVersion3(long id, string name, string title, string approvalSheetTitle) : base(id) {
            Name = name;
            Title = title;
            ApprovalSheetTitle = approvalSheetTitle;
        }
    }
}
