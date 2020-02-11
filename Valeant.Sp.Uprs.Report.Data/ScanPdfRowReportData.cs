using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Report.Data
{
    public class ScanPdfRowReportData
    {
        public int Order { get; set; }

        public string Name { get; set; }

        public byte[] Data { get; set; }

        public string Url { get; set; }

        public string Mime { get; set; }

        public string Urn { get; set; }

        public int Key { get; set; }
    }
}
