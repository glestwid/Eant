using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Report.Data
{
    public class DestinationRowReportData
    {
        public int Order { get; set; }

        public string Country { get; set; }

        public string City { get; set; }

        public string Organization { get; set; }

        public DateTimeOffset? StartDate { get; set; }
        public DateTimeOffset? EndDate { get; set; }
    }
}
