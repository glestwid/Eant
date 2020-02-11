using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Data.Domain.Expenditure
{
    public class ExpenditureLimit
    {
        public long LimitId { get; set; }

        public long PositionGroup { get; set; }

        public decimal Limit { get; set; }

        public long ExpenditureId { get; set; }
    }
}
