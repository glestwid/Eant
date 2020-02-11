using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Data.Domain
{
    public class ActionMapItem {
        public long DocumentTypeId { get; set; }
        public string DocumentTypeName { get; set; }
        public long ActionId { get; set; }
        public string ActionName { get; set; }
        public long StateId { get; set; }
        public string StateName { get; set; }
        public string StateSemantic { get; set; }
        public string Token { get; set; }
        public string Description { get; set; }
    }
}
