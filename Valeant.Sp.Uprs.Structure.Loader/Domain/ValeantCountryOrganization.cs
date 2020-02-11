using System;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganization {
        public ValeantCountryOrganization() {
            Contractor = new List<ValeantCountryOrganizationContractor>();
            Employee = new List<ValeantCountryOrganizationEmployee>();
            Department = new List<ValeantCountryOrganizationDepartment>();
        }

        [XmlElement("value")]
        public string Value { get; set; }
        
        [XmlElement("department")]
        public List<ValeantCountryOrganizationDepartment> Department { get; set; }
        
        [XmlElement("employee")]
        public List<ValeantCountryOrganizationEmployee> Employee { get; set; }
        
        [XmlElement("contractor")]
        public List<ValeantCountryOrganizationContractor> Contractor { get; set; }

        [XmlAttribute("code")]
        public string Code { get; set; }
        
        public ValeantCountryOrganization Clone() {
            return ((ValeantCountryOrganization)(MemberwiseClone()));
        }
    }
}
