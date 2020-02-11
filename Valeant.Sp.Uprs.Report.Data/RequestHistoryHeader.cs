using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Report.Data
{

    public class RequestHistoryHeaderItems: List<RequestHistoryHeader>
    {
        
    }

    public class RequestHistoryHeader
    {
        public Int64 Number { get; set; }
        public string Type { get; set; }
        public string Human { get; set; }
        public string Position { get; set; }
        public string Department { get; set; }
        public DateTime Date { get; set; }

    }
}
