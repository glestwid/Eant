using System;
using System.Collections.Generic;
using System.Xml.Serialization;
using Newtonsoft.Json;

namespace Valeant.Sp.UprsWeb.Controllers.Entities
{
    public abstract class EntitiesBase
    {
        [JsonProperty(PropertyName = "requestId")]
        public long Id { get; set; }

        [JsonProperty(PropertyName = "status")]
        public string Status { get; set; }

        [JsonProperty(PropertyName = "number")]
        public Int64 Number { get; set; }

        [JsonProperty(PropertyName = "date")]
        public DateTime Date { get; set; }

        [JsonProperty(PropertyName = "denyReason")]
        public string DenyReason { get; set; }
        
        [XmlIgnore]
        [JsonProperty(PropertyName = "approvalPath")]
        public List<string> ApprovalPath { get; set; } 

        [XmlIgnore]
        [JsonProperty(PropertyName = "accessList")]
        public Dictionary<string, long> AccessList { get; set; }

        [XmlIgnore]
        [JsonProperty(PropertyName = "actions")]
        public string[] Actions { get; set; }
    }
}