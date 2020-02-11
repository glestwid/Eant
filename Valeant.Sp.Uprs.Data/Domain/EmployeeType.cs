using System;

namespace Valeant.Sp.Uprs.Data.Domain
{
    public class EmployeeType {
        public string Human { get; set; }
        public string ClockNumber { get; set; }
        public string Department { get; set; }
        public string Position { get; set; }
        public long Status { get; set; }
        public string Manager1StLevel { get; set; }
	    public string Manager2NdLevel { get; set; }
        public string CostCentre { get; set; }
        public string UserAccount { get; set; }
        public DateTime? ExpireDate { get; set; }
    }
}
