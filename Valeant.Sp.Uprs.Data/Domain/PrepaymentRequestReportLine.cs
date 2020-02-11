using System;

namespace Valeant.Sp.Uprs.Data.Domain
{
    /// <summary>
    /// Строка реестра "Заявки на Аванс".
    /// </summary>
    public class PrepaymentRequestReportLine
    {
        /// <summary>
        /// Идентификатор заявки.
        /// </summary>
        public long Id { get; set; }


        /// <summary>
        /// Номер заявки.
        /// </summary>
        public long Number { get; set; }

        /// <summary>
        /// Дата заявки.
        /// </summary>
        public DateTime RequestDate { get; set; }

        /// <summary>
        /// Код сотрудника.
        /// </summary>
        public string CreatorCode { get; set; }

        /// <summary>
        /// ФИО сотрудника.
        /// </summary>
        public string CreatorFullName { get; set; }

        /// <summary>
        /// Город сотрудника.
        /// </summary>
        public string CreatorCity { get; set; }

        /// <summary>
        /// Сумма завяки.
        /// </summary>
        public decimal Summa { get; set; }

        /// <summary>
        /// Статус заявки.
        /// </summary>
        public string RequestStatus { get; set; }

        /// <summary>
        /// Комментарий к статусу.
        /// </summary>
        public string StatusComment { get; set; }
    }
}
