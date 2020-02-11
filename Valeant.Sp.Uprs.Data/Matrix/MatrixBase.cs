namespace Valeant.Sp.Uprs.Data.Matrix {
    public abstract class MatrixBase {
        public long Id { get; private set; }

        protected MatrixBase(long id) {
            Id = id;
        }
    }
}
