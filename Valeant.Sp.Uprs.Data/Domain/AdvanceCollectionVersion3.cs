using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace Valeant.Sp.Uprs.Data.Domain {
    public class AdvanceCollectionVersion3 : Collection<AdvanceVersion3> {
        public AdvanceCollectionVersion3() { }
        public AdvanceCollectionVersion3(IEnumerable<AdvanceVersion3> items) {
            foreach (var item in items) Add(item);
        }
    }
}
