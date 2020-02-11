using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Data.Domain
{
    public class FuelCardTransaction
    {
        public long Id { get; set; }

        public long CardNumber { get; set; }

        public string CardHolderName { get; set; }

        public Human CardHolder { get; set; }

        public DateTime Time { get; set; }

        public string Terminal { get; set; }

        public string Product { get; set; }

        public decimal? Quantity { get; set; }

        public decimal? Ammount { get; set; }

        public decimal? FullAmmount { get; set; }

        public decimal? Discount { get; set; }
        

    }

    public class FuelCardTransactionCollection : Collection<FuelCardTransaction>
    {

        public FuelCardTransactionCollection() { }

        public FuelCardTransactionCollection(IEnumerable<FuelCardTransaction> cars)
        {
            foreach (var item in cars)
                Add(item);
        }

    }


}
