using System;
using System.Collections.Generic;

namespace Valeant.Sp.Uprs.Data.Query
{
    /// <summary>
    /// Represents Query object for search advance objects.
    /// </summary>
    public class DocumentQuery
    {
        /// <summary>
        /// Creates a new instance of <see cref="DocumentQuery"/>.
        /// </summary>
        public DocumentQuery()
        {
            DocumentTypes = new List<string>();
            DocumentStates = new List<string>();
        }

        /// <summary>
        /// Types of document to include in query.
        /// </summary>
        public List<string> DocumentTypes { get; set; }

        /// <summary>
        /// States to include in query.
        /// </summary>
        public List<string> DocumentStates { get; set; }

        /// <summary>
        /// Minimal document creation date (including StartDate).
        /// </summary>
        public DateTime? StartDate { get; set; }

        /// <summary>
        /// Maximal document creation date (including EndDate).
        /// </summary>
        public DateTime? EndDate { get; set; }
        
        /// <summary>
        /// Filters query by document ownerId.
        /// </summary>
        public long? CreatorId { get; set; }
    }
}