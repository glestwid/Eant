namespace Valeant.Sp.Uprs.Data.Domain {
    public class NodeItemBaseVersion2 : IItem {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public NodeItemBaseVersion2(long id, string name, string description) {
            Id = id;
            Name = name;
            Description = description;
        }

        public NodeItemBaseVersion2() { }
    }
}
