using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Report.Data
{
    public class TripRequestReportData
    {
        public Int64 Number { get; set; }
        public string Code { get; set; }
        public string FIO { get; set; }
        public string City { get; set; }
        public string FromToDate { get; set; }
        public string Destinations { get; set; }
        public decimal Sum { get; set; }
        public string Status { get; set; }
        public string Comments { get; set; }
    }
}
