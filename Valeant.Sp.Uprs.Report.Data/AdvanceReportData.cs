using System;

namespace Valeant.Sp.Uprs.Report.Data {
    public class AdvanceReportData {
        public long Id { get; set; }
        public Int64 Number { get; set; }
        public string HumanFrom { get; set; }
        public string PositionFrom { get; set; }
        public string DepartmentFrom { get; set; }
        public string CodeFrom { get; set; }
        public string HumanTo { get; set; }
        public string PositionTo { get; set; }
        public decimal SummRub { get; set; }
        public decimal SummKop { get; set; }
        public DateTime Date { get; set; }
        public string State { get; set; }
        public string ApprovedList { get; set; }
        
        public string DecimalToString(decimal sum) {
            long value = (long)Math.Round(100*sum,2);
            return $"{value/100:D} руб. {value%100:00} коп.";
        }
    }
}
