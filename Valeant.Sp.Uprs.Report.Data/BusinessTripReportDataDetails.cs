using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Report.Data
{
    public class BusinessTripReportDataDetails
    {
        public string EmployeeID { get; set; }
        public string Department { get; set; }
        public string Position { get; set; }
        public string DestinationLocation { get; set; }
        public string DestinationOrganization { get; set; }

        public DateTime? BegDate { get; set; }
        public DateTime? EndDate { get; set; }

        public int NumOfDays { get; set; }

        public string Payee { get; set; }
        public string Reason { get; set; }
    }
}
