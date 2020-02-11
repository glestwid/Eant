using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationContractorCostCenter {
        /// <summary>
        /// Код кост-центра работника в ЗиУП. В этом коде нет кода страны.
        /// </summary>
        [XmlElement(ElementName = "code")]
        public string Code { get; set; }

        /// <summary>
        /// Наименование кост-центра работника в ЗиУП.
        /// </summary>
        [XmlElement(ElementName = "description")]
        public string Description { get; set; }

        public ValeantCountryOrganizationContractorCostCenter Clone() {
            return ((ValeantCountryOrganizationContractorCostCenter)(MemberwiseClone()));
        }
    }
}
