using System;

namespace Valeant.Sp.Uprs.Data.Domain
{
    public class HumanType {
        public string Code { get; set; }
        public string FullName { get; set; }        
        public string Email { get; set; }
	    public string DocumentSeries { get; set; }
	    public string DocumentNumber { get; set; }
	    public DateTime DocumentIssuedOn { get; set; }
        public string DocumentIssuedBy { get; set; }
        public string UserAccount { get; set; }
        public DateTime Birthday { get; set; }
        public string City { get; set; }
    }
}
