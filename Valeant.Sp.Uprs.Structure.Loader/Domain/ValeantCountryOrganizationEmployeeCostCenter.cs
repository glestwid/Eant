using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationEmployeeCostCenter {
        [XmlElement("code")]
        public string Code { get; set; }

        [XmlElement("description")]
        public string Description { get; set; }

        public ValeantCountryOrganizationEmployeeCostCenter Clone() {
            return ((ValeantCountryOrganizationEmployeeCostCenter)(MemberwiseClone()));
        }
    }
}
