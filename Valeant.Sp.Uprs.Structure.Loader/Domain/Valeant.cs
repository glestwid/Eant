using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain {
    [Serializable]
    [XmlType(AnonymousType = true)]
    [XmlRoot(IsNullable = false, ElementName = "valeant")]
    public sealed class Valeant {
        public Valeant() {
            Country = new ValeantCountry();
        }

        [XmlElement("country")]
        public ValeantCountry Country { get; set; }
        
        public Valeant Clone() {
            return ((Valeant)(MemberwiseClone()));
        }
    }
}
