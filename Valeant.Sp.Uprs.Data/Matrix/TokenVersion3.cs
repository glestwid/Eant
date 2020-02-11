namespace Valeant.Sp.Uprs.Data.Matrix {
    public class TokenVersion3 : MatrixBase {
        public string Value { get; private set; }
        public bool Calc { get; private set; }
        public bool Export { get; private set; }
        public TokenVersion3(long id, string value, bool calc, bool export) : base(id) {
            Value = value;
            Calc = calc;
            Export = export;
        }
    }
}
