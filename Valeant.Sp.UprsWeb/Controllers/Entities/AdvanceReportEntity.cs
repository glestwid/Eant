using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.UprsWeb.Controllers.Entities
{
    public class AdvanceReportEntity
    {
        public Int64 Id { get; set; }
        public string Status { get; set; }
        public Int64 Number { get; set; }
        public DateTime Date { get; set; }
        public string Type { get; set; }
        public decimal Sum { get; set; }
    }
}
