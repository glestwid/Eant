using System;
using System.Collections.Generic;
using System.Xml.Linq;

namespace Valeant.Sp.Uprs.Data.Domain {
    abstract public class DocumentBase {
        public Int64 Id { get; set; }
        public Int64 Creator { get; set; }
        public DateTimeOffset DateCreate { get; set; }
        public string Status { get; set; }
        public Int64 Number { get; set; }
        public DateTimeOffset Date { get; set; }
        public string Type { get; set; }
        public string Datatype { get; set; }
        public long Human { get; set; }
        public DateTimeOffset Datecreate { get; set; }
        public XElement Content { get; set; }
        public string ContentType { get; set; }
        public string FullName { get; set; }
        public string DepartmentName { get; set; }
        public List<string> Actions { get; set; }
        public TokenCollection Tokens { get; set; }
    }
}
