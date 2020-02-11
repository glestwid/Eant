using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Runtime.CompilerServices;

namespace Valeant.Sp.Uprs.Data.Domain.Expenditure
{
    public class ChangeExpenditureCommand
    {
        [Required]
        public long ExpenditureId { get; set; }

        /// <summary>
        /// Display name.
        /// </summary>
        [Required]
        public string Title { get; set; }

        /// <summary>
        /// Unique identifier of referenced Role entity.
        /// </summary>
        public long? ApproverRoleId { get; set; }

        /// <summary>
        /// ???
        /// </summary>
		public string GroupLimitCode { get; set; }

        /// <summary>
        /// ???
        /// </summary>
        [Required]
		public long? CreditGroupId { get; set; }

        /// <summary>
        /// ???
        /// </summary>
        public long? Account1GroupId { get; set; }

        /// <summary>
        /// ???
        /// </summary>
		public long? Account2GroupId { get; set; }

        public ICollection<long> Documents { get; set; }

        public ICollection<ExpenditureLimitDto> Limits { get; set; }
    }

    public class ExpenditureLimitDto
    {
        public long LimitId { get; set; }

        public long PositionGroup { get; set; }

        [Required]
        public decimal Limit { get; set; }
    }
}