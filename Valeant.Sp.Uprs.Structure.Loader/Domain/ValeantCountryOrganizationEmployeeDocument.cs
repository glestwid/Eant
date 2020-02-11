using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationEmployeeDocument {
        /// <summary>
        /// Вид документа, удостоверяющего личность сотрудника.
        /// </summary>
        [XmlElement("document_sort")]
        public string DocumentSort { get; set; }

        /// <summary>
        /// Серия документа.
        /// </summary>
        [XmlElement("series")]
        public string Series { get; set; }

        /// <summary>
        /// Номер документа.
        /// </summary>
        [XmlElement("number")]
        public string Number { get; set; }

        /// <summary>
        /// Дата выдачи документа.
        /// </summary>
        [XmlElement("issued_on")]
        public string IssuedOn { get; set; }

        /// <summary>
        /// Кем выдан документ.
        /// </summary>
        [XmlElement("issued_by")]
        public string IssuedBy { get; set; }

        /// <summary>
        /// Код подразделения, выдавшего документ.
        /// </summary>
        [XmlElement("dept_code")]
        public string DeptCode { get; set; }

        /// <summary>
        /// Дата по месту регистрации.
        /// </summary>
        [XmlElement("reg_date")]
        public string RegDate { get; set; }

        public ValeantCountryOrganizationEmployeeDocument Clone() {
            return ((ValeantCountryOrganizationEmployeeDocument)(MemberwiseClone()));
        }
    }
}
