using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.ObjectModel;



namespace Valeant.Sp.Uprs.Data.Domain
{
    public class EmployeeLedgerEntryCollection : Collection<EmployeeLedgerEntry>
    {
        public EmployeeLedgerEntryCollection(IEnumerable<EmployeeLedgerEntry> entries)
        {
            foreach (var item in entries)
                Add(item);
        }

        public EmployeeLedgerEntryCollection()
        {
        }
    }
}
