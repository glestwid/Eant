using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationEmployeePosition {
        [XmlElement("code")]
        public string Code { get; set; }

        [XmlElement("value")]
        public string Value { get; set; }

        public ValeantCountryOrganizationEmployeePosition Clone() {
            return ((ValeantCountryOrganizationEmployeePosition)(this.MemberwiseClone()));
        }
    }
}
