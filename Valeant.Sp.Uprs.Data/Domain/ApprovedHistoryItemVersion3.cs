using System;

namespace Valeant.Sp.Uprs.Data.Domain {

    /// <summary>
    /// Represents a line that describes an approver in approval list of the report.
    /// </summary>
    public class ApprovedHistoryItemVersion3
    {
        /// <summary>
        /// Unique identifier of an approver.
        /// </summary>
        public long Id { get; set; }

        /// <summary>
        /// The approval job code.
        /// </summary>
        public int Number { get; set; }

        /// <summary>
        /// Approval time.
        /// </summary>
        public DateTimeOffset Date { get; set; }

        /// <summary>
        /// Full name of an approver.
        /// </summary>
        public string FullName { get; set; }

        /// <summary>
        /// Position of an approver.
        /// </summary>
        public string Position { get; set; }
    }
}
