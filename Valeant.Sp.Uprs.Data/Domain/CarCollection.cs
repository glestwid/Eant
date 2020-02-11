using System.Collections.Generic;
using System.Collections.ObjectModel;


namespace Valeant.Sp.Uprs.Data.Domain
{
    
     public class CarCollection : Collection<Car> {

        public CarCollection() { }

        public CarCollection(IEnumerable<Car> cars)
        {
            foreach (var item in cars)
                Add(item);
        }

    }
    

}
