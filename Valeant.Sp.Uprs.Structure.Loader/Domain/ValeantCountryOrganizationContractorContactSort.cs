using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{

    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationContractorContactSort {
        [XmlElement(ElementName = "code")]
        public string Code { get; set; }

        [XmlElement(ElementName = "value")]
        public string Value { get; set; }

        public ValeantCountryOrganizationContractorContactSort Clone() {
            return ((ValeantCountryOrganizationContractorContactSort)(MemberwiseClone()));
        }
    }
}
