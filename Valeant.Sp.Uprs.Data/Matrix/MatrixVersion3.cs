using System.Collections.Generic;

namespace Valeant.Sp.Uprs.Data.Matrix {
    public class MatrixVersion3 : MatrixBase {
        public List<IntersectionVersion3> Intersections { get; private set; }
        public MatrixVersion3(long id) : base(id) {
            Intersections = new List<IntersectionVersion3>();
        }
    }
}
