using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Valeant.Sp.Uprs.Data.Domain
{
    public class Car
    {
        public long Id { get; set; }
        public string Number { get; set; }
        public string Type { get; set; }
        public Human Human { get; set; }

    }
}
