using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationEmployeeContract {
        /// <summary>
        /// Дата трудового договора. Может не совпадать с датой приема.
        /// </summary>
        [XmlElement(ElementName = "date")]
        public string Date { get; set; }

        /// <summary>
        /// Дата фактического или предстоящего увольнения. То есть, если в ИС ЗиУП введен приказ на увольнение и до увольнения осталось не более 2 дней, то в элемент записывается дата предстоящего увольнения. Но status сотрудника – работает. Если же сотрудник уже уволен, т.е., дата увольнения меньше текущей даты, то и status сотрудника – уволен.
        /// </summary>
        [XmlElement(ElementName = "expire_date")]
        public string ExpireDate { get; set; }

        /// <summary>
        /// Номер трудового договора.
        /// </summary>
        [XmlElement(ElementName = "number")]
        public string Number { get; set; }

        /// <summary>
        /// "ТрудовойДоговор"
        /// </summary>
        [XmlAttribute(AttributeName = "sort")]
        public string Sort { get; set; }

        public ValeantCountryOrganizationEmployeeContract Clone() {
            return ((ValeantCountryOrganizationEmployeeContract)(MemberwiseClone()));
        }
    }
}
