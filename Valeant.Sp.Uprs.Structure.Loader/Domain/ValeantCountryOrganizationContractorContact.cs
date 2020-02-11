using System;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{

    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationContractorContact {
        public ValeantCountryOrganizationContractorContact() {
            Sort = new ValeantCountryOrganizationContractorContactSort();
        }

        /// <summary>
        /// Код вида контактной информации в справочнике «Виды контактной информации» с кодом страны.
        /// </summary>
        [XmlElement(ElementName = "sort")]
        public ValeantCountryOrganizationContractorContactSort Sort { get; set; }

        /// <summary>
        /// Наименование выгружаемого вида контактной информации в справочнике «Виды контактной информации». Выгружаются следующие виды контактной информации: E-mail, Адрес, Адрес для информирования физ. лица, Адрес по прописке физ. лица, Адрес проживания физ. лица, Адрес физ. лица за пределами РФ, Рабочий e-mail, Личный e-mail, Телефон физ. лица, Контактный телефон кандидата, Служебный адрес электронной почты пользователя, Телефон служебный.
        /// </summary>
        [XmlElement(ElementName = "value")]
        public string Value { get; set; }

        /// <summary>
        /// Почтовый индекс
        /// </summary>
        [XmlElement(ElementName = "field1")]
        public string Postcode { get; set; }

        /// <summary>
        /// Область, регион, а также города Москва и Санкт-Петербург.
        /// </summary>
        [XmlElement(ElementName = "field2")]
        public string Region { get; set; }

        /// <summary>
        /// Район.
        /// </summary>
        [XmlElement(ElementName = "field3")]
        public string Area { get; set; }

        /// <summary>
        /// Город, кроме городов из field2.
        /// </summary>
        [XmlElement(ElementName = "field4")]
        public string City { get; set; }

        /// <summary>
        /// Населенный пункт.
        /// </summary>
        [XmlElement(ElementName = "field5")]
        public string Locality { get; set; }

        /// <summary>
        /// Название улицы.
        /// </summary>
        [XmlElement(ElementName = "field6")]
        public string Street { get; set; }

        /// <summary>
        /// Номер дома
        /// </summary>
        [XmlElement(ElementName = "field7")]
        public string House { get; set; }

        /// <summary>
        /// Номер корпуса дома.
        /// </summary>
        [XmlElement(ElementName = "field8")]
        public string Housing { get; set; }

        /// <summary>
        /// Номер квартиры.
        /// </summary>
        [XmlElement(ElementName = "field9")]
        public string Apartment { get; set; }

        /// <summary>
        /// Пустое поле.
        /// </summary>
        [XmlElement(ElementName = "field10")]
        public object EmptyField { get; set; }

        /// <summary>
        /// Наименование выгружаемого вида контактной информации в справочнике «Виды контактной информации». Выгружаются следующие виды контактной информации: E-mail, Адрес, Адрес для информирования физ. лица, Адрес по прописке физ. лица, Адрес проживания физ. лица, Адрес физ. лица за пределами РФ, Рабочий e-mail, Личный e-mail, Телефон физ. лица, Контактный телефон кандидата, Служебный адрес электронной почты пользователя, Телефон служебный.
        /// </summary>
        [XmlAttribute(AttributeName = "type")]
        public string Type { get; set; }

        public ValeantCountryOrganizationContractorContact Clone() {
            return ((ValeantCountryOrganizationContractorContact)(this.MemberwiseClone()));
        }
    }
}
