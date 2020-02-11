using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;

namespace Valeant.Sp.UprsWeb.Security
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = true, Inherited = true)]
    public class ValeantAuthorizeAttribute : AuthorizeAttribute
    {
        private string[] _roleCodesSplit;

        /// <summary>
        /// Gets or sets the user role codes (valeant) that are authorized to access the controller or action method.
        /// </summary>
        /// <returns>The user role codes (valeant) that are authorized to access the controller or action method.</returns>
        public string RoleCodes
        {
            get { return string.Join(", ", _roleCodesSplit); }
            set { _roleCodesSplit = value.Split(new[] {","}, StringSplitOptions.RemoveEmptyEntries); }
        }

        ///<inheritdoc />
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            return true;
            if (httpContext == null)
            {
                throw new ArgumentNullException(nameof(httpContext));
            }

            var authorizeCoreBase = base.AuthorizeCore(httpContext);

            ClaimsPrincipal user = httpContext.User as ClaimsPrincipal;
            if (user == null)
            {
                return false;
            }

            var roleCodeClaims = user.Claims.Where(c => c.Type == ClaimsFiller.ValeantRoleCodeClaimType).Select(c => c.Value);
            return authorizeCoreBase && _roleCodesSplit.Any(roleCode => roleCodeClaims.Contains(roleCode));
        }
    }
}