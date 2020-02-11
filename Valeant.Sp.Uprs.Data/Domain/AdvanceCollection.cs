using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace Valeant.Sp.Uprs.Data.Domain {
    public class AdvanceCollection : Collection<Advance>
    {
        public AdvanceCollection() { }
        public AdvanceCollection(IEnumerable<Advance> items) {
            foreach(var item in items) Add(item);
        }
    }
}
