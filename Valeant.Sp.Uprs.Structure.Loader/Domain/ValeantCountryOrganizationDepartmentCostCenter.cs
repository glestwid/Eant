using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationDepartmentCostCenter {
        [XmlElement("code")]
        public string Code { get; set; }

        [XmlElement("description")]
        public string Description { get; set; }

        public ValeantCountryOrganizationDepartmentCostCenter Clone() {
            return ((ValeantCountryOrganizationDepartmentCostCenter)(MemberwiseClone()));
        }
    }
}
