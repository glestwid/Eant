using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountry {
        public ValeantCountry() {
            Organization = new ValeantCountryOrganization();
        }
        [XmlElement("name")]
        public string Name { get; set; }

        [XmlElement("organization")]
        public ValeantCountryOrganization Organization { get; set; }

        /*
        [XmlAttribute("code")]
        public byte Code { get; set; }
        */

        [XmlAttribute("code")]
        public string Code { get; set; }

        public ValeantCountry Clone() {
            return ((ValeantCountry)(MemberwiseClone()));
        }
    }
}
