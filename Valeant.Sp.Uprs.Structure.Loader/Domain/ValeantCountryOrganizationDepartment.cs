using System;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationDepartment {
        public ValeantCountryOrganizationDepartment() {
            Condition = new List<ValeantCountryOrganizationDepartmentCondition>();
            CostCenter = new ValeantCountryOrganizationDepartmentCostCenter();
        }

        [XmlElement("name")]
        public string Name { get; set; }

        [XmlElement("status")]
        public string Status { get; set; }

        [XmlElement("cost_center")]
        public ValeantCountryOrganizationDepartmentCostCenter CostCenter { get; set; }

        [XmlElement("parent")]
        public string Parent { get; set; }
        
        [XmlElement("condition")]
        public List<ValeantCountryOrganizationDepartmentCondition> Condition { get; set; }

        [XmlAttribute("code")]
        public string Code { get; set; }
        
        public ValeantCountryOrganizationDepartment Clone() {
            return ((ValeantCountryOrganizationDepartment)(MemberwiseClone()));
        }
    }
}
