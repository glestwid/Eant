using System.Collections.Generic;
using System.Linq;

namespace Valeant.Sp.Uprs.Data {
    public class ApprovalSheetItems : List<ApprovalSheetItem> {
        private readonly string _value;
        public ApprovalSheetItems(string value) {
            _value = value;
            foreach (var item in value.Split(',')) {
                Add(new ApprovalSheetItem(item));
            }
        }

        public override string ToString() {
            return _value;
        }

        public bool IsContainsS(ApprovalSheetItem item) {
            return this.Any(x => x.IsEqualsS(item));
        }
    }
}
