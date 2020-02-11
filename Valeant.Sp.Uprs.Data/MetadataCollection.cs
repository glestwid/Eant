using System.Collections.Generic;
using System.Runtime.Serialization;

namespace Valeant.Sp.Uprs.Data {
    public class MetadataCollection : Dictionary<string, string> {
        #region Ctor

        public MetadataCollection() { }
        public MetadataCollection(Dictionary<string, string> source) {
            foreach (var keyValuePair in source) Add(keyValuePair.Key, keyValuePair.Value);
        }

        public MetadataCollection DeepCopy() {
            return new MetadataCollection(this);
        }

        protected MetadataCollection(SerializationInfo info, StreamingContext context) : base(info, context) { }

        #endregion
    }
}
