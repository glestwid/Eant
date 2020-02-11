using System;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace Valeant.Sp.Uprs.Structure.Loader.Domain
{
    [Serializable]
    [XmlType(AnonymousType = true)]
    public sealed class ValeantCountryOrganizationEmployee {
        /// <summary>
        /// valeantCountryOrganizationEmployee class constructor
        /// </summary>
        public ValeantCountryOrganizationEmployee() {
            Education = new List<ValeantCountryOrganizationEmployeeRow>();
            Document = new ValeantCountryOrganizationEmployeeDocument();
            Contact = new List<ValeantCountryOrganizationEmployeeContact>();
            Contract = new ValeantCountryOrganizationEmployeeContract();
            Position = new ValeantCountryOrganizationEmployeePosition();
            CostCenter = new ValeantCountryOrganizationEmployeeCostCenter();
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
        public ValeantCountryOrganizationEmployeeCostCenter CostCenter { get; set; }

        /// <summary>
        /// Должность сотрудника.
        /// </summary>
        [XmlElement("position")]
        public ValeantCountryOrganizationEmployeePosition Position { get; set; }

        /// <summary>
        /// Код физлица линейного руководителя работника. Проверяется статус этого руководителя. Если он уволен, то выбирается руководитель уровнем выше, т.е., руководитель уволенного руководителя. Таким образом, рекурсивно находится работающий руководитель. В случае отсутствия такого руководителя, выводится код физлица генерального директора.
        /// </summary>
        [XmlElement("manager_code")]
        public string ManagerCode { get; set; }

        /// <summary>
        /// Состояние сотрудника по кадровым данным в базе ЗиУП на момент формирования файла.
        /// </summary>
        [XmlElement("status")]
        public string Status { get; set; }

        /// <summary>
        /// Дата приема сотрудника в компанию.
        /// </summary>
        [XmlElement("effectivedate")]
        public string Effectivedate { get; set; }

        /// <summary>
        /// Стаж работы сотрудника в группе компаний VALEANT. То есть, если у сотрудника в базе ЗиУП заполнен стаж «Стаж работы в группе компаний "Валеант"», то стаж на дату выгрузки файла считается по этому виду стажа. В противном случае, стаж считается от даты приема сотрудника в компанию.
        /// </summary>
        [XmlElement("seniority")]
        public string Seniority { get; set; }

        /// <summary>
        /// Данные по трудовому договору сотрудника.
        /// </summary>
        [XmlElement("contract")]
        public ValeantCountryOrganizationEmployeeContract Contract { get; set; }
        
        /// <summary>
        /// Остаток неиспользованного отпуска сотрудника на дату формирования файла.
        /// </summary>
        [XmlElement("vacation_days_left")]
        public sbyte VacationDaysLeft { get; set; }
        
        /// <summary>
        /// Контактные данные сотрудника из регистра сведений «Контактная информация». У элемента один атрибут type. Он может принимать такие значения: Адрес, Телефон, E-Mail, Веб-страница, Другое. Каждая строка контактных данных сотрудника описывается отдельным элементом contact.
        /// </summary>
        [XmlElement("contact")]
        public List<ValeantCountryOrganizationEmployeeContact> Contact { get; set; }
        
        /// <summary>
        /// Дата рождения сотрудника.
        /// </summary>
        [XmlElement("birthday")]
        public string Birthday { get; set; }
        
        /// <summary>
        /// Пол сотрудника.
        /// </summary>
        [XmlElement("gender")]
        public string Gender { get; set; }
        
        /// <summary>
        /// Документ, удостоверяющий личность сотрудника.
        /// </summary>
        [XmlElement("document")]
        public ValeantCountryOrganizationEmployeeDocument Document { get; set; }

        /// <summary>
        /// Данные по образованию сотрудника. Каждое образование сотрудника описывается отдельным элементом Row.
        /// </summary>
        //[XmlElement("Education")]
        [XmlArrayItem("Row", IsNullable=false)]
        public List<ValeantCountryOrganizationEmployeeRow> Education { get; set; }

        /// <summary>
        /// уникальный идентификатор, генерируемый 1С при записи нового сотрудника в справочник «Сотрудники организаций».
        /// </summary>
        [XmlAttribute("GUID")]
        public string Guid { get; set; }

        /// <summary>
        /// код физлица в справочнике «Физические лица» соответствующего сотрудника.
        /// </summary>
        [XmlAttribute("code")]
        public string Code { get; set; }
        
        public ValeantCountryOrganizationEmployee Clone() {
            return ((ValeantCountryOrganizationEmployee)(MemberwiseClone()));
        }
    }
}
