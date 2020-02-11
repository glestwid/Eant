using System;

namespace Valeant.Sp.Uprs.Data.Matrix {
    public class NodeVersion3 {
        public NodeVersion3(StateVersion3 state) {
            State = state;
            Properties = new NodePropertiesVersion3();
        }

        public StateVersion3 State { get; private set; }
        public NodePropertiesVersion3 Properties { get; private set; }
    }
}
