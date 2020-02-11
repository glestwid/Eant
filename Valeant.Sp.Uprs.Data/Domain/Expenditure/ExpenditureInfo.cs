using System.Collections.Generic;

namespace Valeant.Sp.Uprs.Data.Domain.Expenditure
{
    /// <summary>
    /// Represents the ExpenditureInfo entity.
    /// </summary>
    public class ExpenditureInfo
    {
        /// <summary>
        /// Unique identifier of the entity.
        /// </summary>
        public long ExpenditureId { get; set; }

        /// <summary>
        /// Display name.
        /// </summary>
        public string Title { get; set; }

        /// <summary>
        /// Unique identifier of referenced Human entity.
        /// Approver of ExpenditureInfo.
        /// </summary>
        public long? ApproverRoleId { get; set; }

        /// <summary>
        /// ???
        /// </summary>
		public string GroupLimitCode { get; set; }

        /// <summary>
        /// ???
        /// </summary>
		public long? CreditGroupId { get; set; }

        /// <summary>
        /// ???
        /// </summary>
        public long? Account1GroupId { get; set; }

        /// <summary>
        /// ???
        /// </summary>
		public long? Account2GroupId { get; set; }

        /// <summary>
        /// Show that this entity active or not.
        /// </summary>
        public bool IsActive { get; set; }

        public ICollection<long> Documents { get; } = new HashSet<long>();

        public ICollection<ExpenditureLimit> Limits { get; } = new HashSet<ExpenditureLimit>();
    }
}
