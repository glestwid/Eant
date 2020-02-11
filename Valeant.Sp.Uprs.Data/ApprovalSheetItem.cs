using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text.RegularExpressions;

namespace Valeant.Sp.Uprs.Data {
    public class ApprovalSheetItem : IEquatable<ApprovalSheetItem> {
        #region Static fields and constants

        private static readonly Regex RegEx = new Regex("([A-Za-z]{1,10})\\.([0-9]{2})\\.([0-9]{2})\\.([0-9]{2})");

        #endregion

        #region Fields

        private readonly string _value;

        #endregion

        #region Ctor

        public ApprovalSheetItem(string value) {
            _value = value;
            var matchResult = RegEx.Match(value);
            if (!matchResult.Success) throw new Exception($"ApprovalSheetItem format error:\"{value}\"");
            SubValue = matchResult.Groups[1].Value;
            IdValue = matchResult.Groups[2].Value;
            IdSubValue = matchResult.Groups[3].Value;
            Ex = matchResult.Groups[4].Value;
        }

        #endregion

        #region Properties, indexers

        public string SubValue { get; private set; }
        public string IdValue { get; private set; }
        public string IdSubValue { get; private set; }
        public string Ex { get; private set; }
        public bool IsEx => Ex != "00";
        private string ApprovalSheetItemValue { get; set; }

        #endregion
        
        #region Public method

        public bool IsSubValue(string subValue) {
            return SubValue.ToLower().Contains(subValue.ToLower());
        }

        public bool IsEqualsS(ApprovalSheetItem item) {
            return IsSubValue(item.SubValue) && IdValue == item.IdValue;
        }

        public bool Equals(ApprovalSheetItem other) {
            return _value.Equals(other._value, StringComparison.InvariantCultureIgnoreCase);
        }

        public override string ToString() {
            return _value;
        }

        public bool IsPrimary => IdSubValue == "00";

        public ApprovalSheetItem ToPrime() {
            return new ApprovalSheetItem($"{SubValue}.{IdValue}.00");
        }

        #endregion
    }

    public class ApprovalSheetItemComparer : IEqualityComparer<ApprovalSheetItem> {
        public bool Equals(ApprovalSheetItem x, ApprovalSheetItem y) {
            return x.IsEqualsS(y);
        }

        public int GetHashCode(ApprovalSheetItem obj) {
            return GetHashCode();
        }
    }

    public class ApprovalSheetItemOComparer : IComparer<ApprovalSheetItem>, IComparer {
        public int Compare(ApprovalSheetItem x, ApprovalSheetItem y) {
            return string.Compare($"{x.IdSubValue}${x.IdValue}${x.Ex}", $"{y.IdSubValue}${y.IdValue}${y.Ex}", StringComparison.InvariantCultureIgnoreCase);
        }

        public int Compare(object x, object y) {
            return Compare((ApprovalSheetItem) x, (ApprovalSheetItem) y);
        }
    }
}