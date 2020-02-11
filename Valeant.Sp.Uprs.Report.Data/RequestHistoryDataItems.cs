using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Report.Data
{



    public class RequestHistoryDataItems: List<RequestHistoryData>
    {
    }

    public class RequestHistoryData
    {
        public int Number { get; set; }
        public DateTime CreateDate { get; set; }
        public string Initiator { get; set; }
        public string Message { get; set; }
        public string Comment { get; set; }
    }
}
