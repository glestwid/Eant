using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Valeant.Sp.Uprs.Data;

namespace Valeant.Sp.UprsWeb.Filters
{
    public class HttpHandler : ActionFilterAttribute {
        private static SegmentSecurity[] _segmentSecurity = new[] {
            new SegmentSecurity("personRoles/", new[] {"R-00000006"}),
            new SegmentSecurity("prepaymentLimits/", new[] {"R-00000006"}),
            new SegmentSecurity("costItems/", new[] {"R-00000006"}),
            new SegmentSecurity("giftRecievers/", new[] {"R-00000006"}),
            new SegmentSecurity("accountGroups/", new[] {"R-00000006"}),
            new SegmentSecurity("documentTypes/", new[] {"R-00000006"}),
            new SegmentSecurity("dailyLimitsBase/", new[] {"R-00000006"}),
            new SegmentSecurity("vehicleTypes/", new[] {"R-00000006"})
        };
        private static Comparer _comparer = new Comparer();
        public override void OnActionExecuted(ActionExecutedContext filterContext) {
            var segment = _segmentSecurity.FirstOrDefault(x => filterContext.HttpContext.Request.Url.Segments.Contains(x.Segment, _comparer));
            if (segment == null) base.OnActionExecuted(filterContext);
            else {
                var actor = DataProvider.GetHuman(filterContext.HttpContext.User.Identity.Name);
                if (segment.Roles.Intersect(actor.Roles.Select(x => x.Code)).Any())
                    base.OnActionExecuted(filterContext);
                else {
                    var values = new RouteValueDictionary(new
                    {
                        controller = "Forbidden",
                        action = "Index"
                    });
                    filterContext.Result = new RedirectToRouteResult(values);
                }
            }
        }

        class SegmentSecurity {
            internal string Segment;
            internal string[] Roles;

            public SegmentSecurity(string segment, string[] roles) {
                Segment = segment;
                Roles = roles;
            }
        }

        class Comparer : IEqualityComparer<string> {
            public bool Equals(string x, string y) {
                return x.Equals(y, StringComparison.InvariantCultureIgnoreCase);
            }

            public int GetHashCode(string obj) {
                return obj.ToLower().GetHashCode();
            }
        }
    }
}
