using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Report.Data
{
    public class BusinessTripReportData
    {
        public string DocNum { get; set; }
        public DateTime DocDate { get; set; }
        public string TabNum { get; set; }
        public string FIO { get; set; }
        public string Goal { get; set; }
        public string ShortReport { get; set; }

        public List<BusinessTripReportDataDetails> Destinations { get; set; }
    }
}
