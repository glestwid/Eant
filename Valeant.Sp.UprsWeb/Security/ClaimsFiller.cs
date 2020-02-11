using System.Security.Claims;
using System.Security.Principal;
using System.Web;
using Valeant.Sp.Uprs.Data;
using ClaimValueTypes = Microsoft.IdentityModel.Claims.ClaimValueTypes;

namespace Valeant.Sp.UprsWeb.Security
{
    public static class ClaimsFiller {
        public static string ValeantHumanIdClaimType
        {
            get
            {
                return "http://schemas.valeant.eu/structure/human/id";
            }
        }

        public static string ValeantHumanCodeClaimType {
            get {
                return "http://schemas.valeant.eu/structure/human/code";
            }
        }

        public static string ValeantHumanFullNameClaimType {
            get {
                return "http://schemas.valeant.eu/structure/human/fullname";
            }
        }

        public static string ValeantHumanIsAdministratorClaimType {
            get
            {
                return "http://schemas.valeant.eu/structure/human/isadministrator";
            }
        }

        public static string ValeantEmployeeClockNumberClaimType {
            get {
                return "http://schemas.valeant.eu/structure/employee/clocknumber";
            }
        }

        public static string ValeantEmployeeStatusClaimType {
            get {
                return "http://schemas.valeant.eu/structure/employee/status";
            }
        }

        public static string ValeantDepartmentCodeClaimType {
            get {
                return "http://schemas.valeant.eu/structure/department/code";
            }
        }

        public static string ValeantDepartmentNameClaimType {
            get {
                return "http://schemas.valeant.eu/structure/department/name";
            }
        }

        public static string ValeantRoleNameClaimType {
            get {
                return "http://schemas.valeant.eu/structure/role/name";
            }
        }
        public static string ValeantRoleCodeClaimType
        {
            get
            {
                return "http://schemas.valeant.eu/structure/role/code";
            }
        }

        private static string ValeantClaimValueType {
            get {
                return ClaimValueTypes.String;
            }
        }

        public static string ValeantUrlType {
            get {
                return "http://schemas.valeant.eu/url";
            }
        }

        public static string ValeantRawUrlType {
            get {
                return "http://schemas.valeant.eu/url/raw";
            }
        }

        public static void FillAsync(ClaimsPrincipal principal, HttpRequest request) {
            var userName = principal.Identity.Name;
            var human = DataProvider.GetHuman(userName);
            var identity = principal.Identity as WindowsIdentity;
            if (identity == null || human == null) return;
            identity.AddClaim(new Claim(ValeantHumanIdClaimType, human.Id.ToString(), ValeantClaimValueType));
            identity.AddClaim(new Claim(ValeantHumanCodeClaimType, human.Code, ValeantClaimValueType));
            identity.AddClaim(new Claim(ValeantHumanFullNameClaimType, human.FullName, ValeantClaimValueType));
            identity.AddClaim(new Claim(ValeantEmployeeClockNumberClaimType, human.ClockNumber, ValeantClaimValueType));
            identity.AddClaim(new Claim(ValeantEmployeeStatusClaimType, human.EmployeeStatus, ValeantClaimValueType));
            identity.AddClaim(new Claim(ValeantDepartmentCodeClaimType, human.DepartmentCode, ValeantClaimValueType));
            identity.AddClaim(new Claim(ValeantDepartmentNameClaimType, human.DepartmentName, ValeantClaimValueType));
            identity.AddClaim(new Claim(ValeantHumanIsAdministratorClaimType, human.IsAdministrator.ToString(), ValeantClaimValueType));

            foreach (var role in human.Roles)
            {
                identity.AddClaim(new Claim(ValeantRoleNameClaimType, role.Name, ValeantClaimValueType));
                identity.AddClaim(new Claim(ValeantRoleCodeClaimType, role.Code, ValeantClaimValueType));
            }


            identity.AddClaim(new Claim(ValeantUrlType, HttpContext.Current.Request.Url.AbsoluteUri, ValeantClaimValueType));
            identity.AddClaim(new Claim(ValeantUrlType, HttpContext.Current.Request.Url.OriginalString, ValeantClaimValueType));
        }
    }
}