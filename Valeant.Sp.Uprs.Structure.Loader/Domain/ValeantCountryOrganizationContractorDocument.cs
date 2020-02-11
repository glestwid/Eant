using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationContractorDocument {
        /// <summary>
        /// Вид документа, удостоверяющего личность сотрудника.
        /// </summary>
        [XmlElement(ElementName = "document_sort")]
        public string DocumentSort { get; set; }

        /// <summary>
        /// Серия документа.
        /// </summary>
        [XmlElement(ElementName = "series")]
        public string Series { get; set; }

        /// <summary>
        /// Номер документа.
        /// </summary>
        [XmlElement(ElementName = "number")]
        public string Number { get; set; }

        /// <summary>
        /// Дата выдачи документа.
        /// </summary>
        [XmlElement(ElementName = "issued_on")]
        public string IssuedOn { get; set; }

        /// <summary>
        /// Кем выдан документ.
        /// </summary>
        [XmlElement(ElementName = "issued_by")]
        public string IssuedBy { get; set; }

        /// <summary>
        /// Код подразделения, выдавшего документ.
        /// </summary>
        [XmlElement(ElementName = "dept_code")]
        public string DeptCode { get; set; }

        /// <summary>
        /// Дата по месту регистрации.
        /// </summary>
        [XmlElement(ElementName = "reg_date")]
        public string RegDate { get; set; }

        public ValeantCountryOrganizationContractorDocument Clone() {
            return ((ValeantCountryOrganizationContractorDocument) (MemberwiseClone()));
        }
    }
}