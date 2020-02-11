using System;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationContractor {
        /// <summary>
        /// valeantCountryOrganizationContractor class constructor
        /// </summary>
        public ValeantCountryOrganizationContractor() {
            Document = new ValeantCountryOrganizationContractorDocument();
            Contact = new List<ValeantCountryOrganizationContractorContact>();
            Contract = new ValeantCountryOrganizationContractorContract();
            CostCenter = new ValeantCountryOrganizationContractorCostCenter();
        }

        /// <summary>
        /// Код работника в справочнике «Сотрудники организаций».
        /// </summary>
        [XmlElement("clock_number")]
        public string ClockNumber { get; set; }

        /// <summary>
        /// Значение генерируется при выгрузке из email работника по следующему правилу. В начале "valeant\", затем текст из e-mail до @, но не более 20 символов.
        /// </summary>
        [XmlElement("useraccount")]
        public string Useraccount { get; set; }

        /// <summary>
        /// Рабочий электронный адрес работника.
        /// </summary>
        [XmlElement("email")]
        public string Email { get; set; }

        /// <summary>
        /// Имя работника.
        /// </summary>
        [XmlElement("first_name")]
        public string FirstName { get; set; }

        /// <summary>
        /// Фамилия работника.
        /// </summary>
        [XmlElement("last_name")]
        public string LastName { get; set; }

        /// <summary>
        /// Отчество работника.
        /// </summary>
        [XmlElement("patronymic")]
        public string Patronymic { get; set; }

        /// <summary>
        /// Страна из адреса фактического проживания работника. Если адрес проживания в базе ЗиУП не указан, то страна определяется из адреса прописки работника.
        /// </summary>
        [XmlElement("country")]
        public string Country { get; set; }

        /// <summary>
        /// Город  из адреса фактического проживания работника. Если адрес проживания в базе ЗиУП не указан, то город определяется из адреса прописки работника.
        /// </summary>
        [XmlElement("city")]
        public string City { get; set; }

        /// <summary>
        /// Подразделение работника, указанное в договоре подряда.
        /// </summary>
        [XmlElement("department")]
        public string Department { get; set; }

        /// <summary>
        /// Справочник «Кост-центры» в ЗиУП. Если кост-центр работника в базе не указан, то записывается кост-центр подразделения, в котором он работает. Кост-центр работника и кост-центр подразделения обычно совпадают. Но могут и отличаться.
        /// </summary>
        [XmlElement("cost_center")]
        public ValeantCountryOrganizationContractorCostCenter CostCenter { get; set; }

        /// <summary>
        /// Пустой элемент, так как должность у работников по ГПХ в базе ЗиУП не указывается.
        /// </summary>
        [XmlElement("position")]
        public object Position { get; set; }

        /// <summary>
        /// Код физлица линейного руководителя работника. Проверяется статус этого руководителя. Если он уволен, то выбирается руководитель уровнем выше, т.е., руководитель уволенного руководителя. Таким образом, рекурсивно находится работающий руководитель. В случае отсутствия такого руководителя, выводится код физлица генерального директора.
        /// </summary>
        [XmlElement("manager_code")]
        public string ManagerCode { get; set; }

        /// <summary>
        /// Если на момент формирования файла дата окончания ГПХ работника больше текущей даты, то состояние принимает значение «Работает», в противном случае, «Закончен договор».
        /// </summary>
        [XmlElement("status")]
        public string Status { get; set; }

        /// <summary>
        /// Пустой элемент.
        /// </summary>
        [XmlElement("effectivedate")]
        public object Effectivedate { get; set; }

        /// <summary>
        /// Пустой элемент.
        /// </summary>
        [XmlElement("seniority")]
        public object Seniority { get; set; }

        /// <summary>
        /// Данные по договору ГПХ работника. Данный элемент имеет один атрибут sort= “Подряда”. Если у работника в базе несколько договоров ГПХ, то выгружаются данные по последнему ГПХ.
        /// </summary>
        [XmlElement("contract")]
        public ValeantCountryOrganizationContractorContract Contract { get; set; }

        /// <summary>
        /// Пустой элемент.
        /// </summary>
        [XmlElement(ElementName = "vacation_days_left")]
        public object VacationDaysLeft { get; set; }

        /// <summary>
        /// Контактные данные работника из регистра сведений «Контактная информация». У элемента один атрибут type. Он может принимать такие значения: Адрес, Телефон, E-Mail, Веб-страница, Другое. Каждая строка контактных данных работника описывается отдельным элементом contact.
        /// </summary>
        [XmlElement("contact")]
        public List<ValeantCountryOrganizationContractorContact> Contact { get; set; }

        /// <summary>
        /// Дата рождения работника.
        /// </summary>
        [XmlElement("birthday")]
        public string Birthday { get; set; }

        /// <summary>
        /// Пол работника.
        /// </summary>
        [XmlElement("gender")]
        public string Gender { get; set; }

        /// <summary>
        /// Документ, удостоверяющий личность работника.
        /// </summary>
        [XmlElement("document")]
        public ValeantCountryOrganizationContractorDocument Document { get; set; }

        /// <summary>
        /// Данные по образованию работника. Обычно по контрактникам в базе данные по образованию не ведутся.
        /// </summary>
        [XmlElement("Education")]
        public object Education { get; set; }

        /// <summary>
        /// Атрибут GUID - уникальный идентификатор, генерируемый 1С при записи нового работника в справочник «Сотрудники организаций».
        /// </summary>
        [XmlAttribute("GUID")]
        public string Guid { get; set; }

        /// <summary>
        /// Атрибут code - код физлица в справочнике «Физические лица» соответствующего работника.
        /// </summary>
        [XmlAttribute("code")]
        public string Code { get; set; }

        public ValeantCountryOrganizationContractor Clone() {
            return ((ValeantCountryOrganizationContractor)(MemberwiseClone()));
        }
    }
}
