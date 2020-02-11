using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Report.Data
{
    public class TitleReportData
    {
        public long Id { get; set; }
        public string HumanFrom { get; set; }
        public string PositionFrom { get; set; }
        public string DepartmentFrom { get; set; }
        
        public decimal SummRub { get; set; }
        public decimal SummKop { get; set; }
        public DateTime Date { get; set; }

        public string Number { get; set; }
        public string TabNumber { get; set; } // табельный номер
        

        //public string DecimalToString(decimal sum)
        //{
        //    long value = (long)Math.Round(100 * sum, 2);
        //    return $"{value / 100:D} руб. {value % 100:00} коп.";
        //}
    }
}
