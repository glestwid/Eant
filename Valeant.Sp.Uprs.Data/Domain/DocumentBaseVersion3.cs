using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Valeant.Sp.Uprs.Data.Domain
{
    public class DocumentBaseVersion3 {
        public Int64 Id { get; set; }
        public Int64 Creator { get; set; }
        public DateTimeOffset DateCreate { get; set; }
        public string Status { get; set; }
        public Int64 Number { get; set; }
        public DateTimeOffset Date { get; set; }
        public string Type { get; set; }
        public string Datatype { get; set; }
        public long Human { get; set; }
        public XElement Content { get; set; }
        public string ContentType { get; set; }
        public string FullName { get; set; }
        public string DepartmentName { get; set; }
        public ApprovalSheetItems ApprovalSheets { get; set; }
        public string ProcessSubType { get; set; }
        public TokenCollection Tokens { get; set; }
    }
}
