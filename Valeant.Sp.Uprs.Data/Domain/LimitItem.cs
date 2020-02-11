namespace Valeant.Sp.Uprs.Data.Domain {
    public class LimitItem {
        public long Id { get; set; }

        public string Name { get; set; }

        public decimal Limit { get; set; }

        public string RoleCode { get; set; }

        public bool IsActive { get; set; }
    }
}
