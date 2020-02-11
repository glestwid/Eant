using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Report.Data
{
    public class TripRequestFullReportData
    {
        public Int64 Number { get; set; }
        public string Code { get; set; }
        public string FIO { get; set; }
        public string City { get; set; }
        public decimal Sum { get; set; }
        public string Status { get; set; }
        public string Comments { get; set; }

        public List<DestinationRowReportData> DestinationsData { get; set; }
    }
}
