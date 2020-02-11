using System;
using System.Linq;
using Newtonsoft.Json;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Utils;

namespace Valeant.Sp.UprsWeb.Controllers.Entities
{
    public class AdvanceReportDataEx : EntitiesBase {

        public AdvanceReportDataEx()
        {
           AdvanceRequestsData = new RowOptionsDataCollection<ReportRow, ReportOptions>();
        }

        [JsonProperty(PropertyName = "advanceRequestsData")]
        public RowOptionsDataCollection<ReportRow, ReportOptions> AdvanceRequestsData { get; set; }

        public class ReportRow : IRow
        {
            [JsonProperty(PropertyName = "index")]
            public int Order { get; set; }

            [JsonProperty(PropertyName = "costItem")]
            public CostItemReference CostItem { get; set; }

            [JsonProperty(PropertyName = "limit")]
            public decimal Limit { get; set; }

            [JsonProperty(PropertyName = "advance")]
            public decimal Advance { get; set; }

            [JsonProperty(PropertyName = "comment")]
            public string Comment { get; set; }
        }
        public class ReportOptions : IOptions
        {
            public ReportOptions()
            {
                AdvanceDate = DateTime.Now.StartOfDay();
                Sum = 0;
            }

            [JsonProperty(PropertyName = "advanceDate")]
            public DateTime AdvanceDate { get; set; }

            [JsonProperty(PropertyName = "sum")]
            public decimal Sum { get; set; }
        }

        public bool UpdateCost()
        {
            var result = false;
            foreach (var item in from item in AdvanceRequestsData.Rows let r = item.CostItem select item) {
                //item.CostItem.RoleCode = DataProvider.CheckCostItem(item.CostItem.Name);
                item.CostItem.Approve = item.CostItem.RoleCode == null;
                result = true;
            }
            return result;
        }
        public bool UpdateCost(string action, Human human) {
            var result = false;
            if (action == "Согласовать") {
                var costs = from item in AdvanceRequestsData.Rows let r = item.CostItem where !r.Approve select r;
                foreach (var cost in costs) {
                    if (human.Tokens.Select(x => x.Value).Contains(cost.RoleCode)) cost.Approve = true;
                    result = true;
                }
            }
            return result;
        }
        public bool RoCheck(TokenCollection tokens) {
            var firstNotApproved = (from item in AdvanceRequestsData.Rows let r = item.CostItem select item).FirstOrDefault(x => !x.CostItem.Approve);
            if (firstNotApproved != null) {
                tokens.Add(new Token { Value = firstNotApproved.CostItem.RoleCode, Type = "R"});
                return true;
            }
            return false;
        }

        public bool CheckApprovalFirstLiner() {
            return true;
        }

        public bool CheckApprovalCeo() {
            return true;
        }

        public bool LimitCheck() {
            return AdvanceRequestsData.Rows.Any(item => item.Advance > item.Limit);
        }
    }
    
    public enum AccessAction
    {
        View = 1,
        Edit = 2,
        Hide = 3
    }
}