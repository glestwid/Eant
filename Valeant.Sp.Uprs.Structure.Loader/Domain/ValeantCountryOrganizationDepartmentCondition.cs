using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable()]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationDepartmentCondition {
        [XmlElement("name")]
        public string Name { get; set; }

        [XmlElement("value")]
        public string Value { get; set; }

        public ValeantCountryOrganizationDepartmentCondition Clone() {
            return ((ValeantCountryOrganizationDepartmentCondition)(MemberwiseClone()));
        }
    }
}
