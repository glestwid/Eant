using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{

    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationEmployeeRow {
        /// <summary>
        /// Вид образования.
        /// </summary>
        [XmlElement("TypeOfEducation")]
        public string TypeOfEducation { get; set; }

        /// <summary>
        /// Название учебного заведения.
        /// </summary>
        [XmlElement("EducationalInstitution")]
        public string EducationalInstitution { get; set; }

        /// <summary>
        /// Специальность по образованию.
        /// </summary>
        [XmlElement("speciality")]
        public string Speciality { get; set; }

        /// <summary>
        /// Номер диплома.
        /// </summary>
        [XmlElement("diploma")]
        public string Diploma { get; set; }

        /// <summary>
        /// Год окончания.
        /// </summary>
        [XmlElement("year")]
        public string Year { get; set; }

        /// <summary>
        /// Квалификация. 
        /// </summary>
        [XmlElement("profession")]
        public string Profession { get; set; }

        public ValeantCountryOrganizationEmployeeRow Clone() {
            return ((ValeantCountryOrganizationEmployeeRow)(MemberwiseClone()));
        }
    }
}
