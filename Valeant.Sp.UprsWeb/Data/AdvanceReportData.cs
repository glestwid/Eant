using System;
using System.Collections.Generic;

namespace Valeant.Sp.UprsWeb.Data {
    public class AdvanceReportData {
        public string Declarant { get; set; }
        public DateTime Date { get; set; }
        public string State { get; set; }
        public List<Row> Rows { get; set; }
        public List<StateHistory> History { get; set; }

        public class Row {
            public int Number { get; set; }
            public string Article { get; set; }
            public decimal Sum { get; set; }
            public string Comment { get; set; }
        }

        public class StateHistory {
            public DateTime Date;
            public string FullName { get; set; }
        }
    }
}