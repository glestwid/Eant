using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Report.Data
{
    public class MemorandumReportData
    {
        public string FIO { get; set; }
        public string Position { get; set; }
        public string OrderNo { get; set; }

        public DateTime OrderDate { get; set; }

        public bool ServiceVehicle { get; set; }

        public string TripLocations { get; set; }
        public MemorandumScans Scans { get; set; }
    }
}
