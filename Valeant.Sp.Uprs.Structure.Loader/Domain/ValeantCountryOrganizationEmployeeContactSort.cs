using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationEmployeeContactSort {
        [XmlElement("code")]
        public string Code { get; set; }

        [XmlElement("value")]
        public string Value { get; set; }

        public ValeantCountryOrganizationEmployeeContactSort Clone() {
            return ((ValeantCountryOrganizationEmployeeContactSort)(MemberwiseClone()));
        }
    }
}
