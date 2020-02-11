namespace Valeant.Sp.Uprs.Data.Domain {
    public interface IItem {
        long Id { get; set; }
        string Name { get; set; }
        string Description { get; set; }
    }
}
