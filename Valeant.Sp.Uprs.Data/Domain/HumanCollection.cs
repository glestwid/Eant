using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace Valeant.Sp.Uprs.Data.Domain {
    public class HumanCollection : Collection<Human>
    {
        public HumanCollection(IEnumerable<Human> humans) {
            foreach(var item in humans)
                Add(item);
        }

        public HumanCollection() {
        }
    }
}
