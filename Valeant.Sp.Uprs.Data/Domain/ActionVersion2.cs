namespace Valeant.Sp.Uprs.Data.Domain {
    public class ActionVersion2 : IItem {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public ActionVersion2(long id, string name, string description) {
            Id = id;
            Name = name;
            Description = description;
        }
        public ActionVersion2() { }
    }
}
