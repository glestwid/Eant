using System.Collections.ObjectModel;

namespace Valeant.Sp.Uprs.Data.Domain {
    public abstract class Node {
        public int Order { get; set; }
        public string Type { get; set; }
        public Collection<Node> Childs { get; set; } 
    }
}
