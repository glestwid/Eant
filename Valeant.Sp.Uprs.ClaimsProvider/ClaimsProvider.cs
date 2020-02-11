using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.SharePoint.Administration.Claims;
using Microsoft.SharePoint.WebControls;
using Valeant.Sp.Uprs.Data;

namespace Valeant.Sp.Uprs.ClaimsProvider
{
    public class ClaimsProvider : SPClaimProvider {
        internal static string ProviderDisplayName {
            get {
                return "Valeant uprs claims provider version 1.0";
            }
        }

        internal static string ProviderInternalName {
            get {
                return "ValeantUprsClaimsProviderV10";
            }
        }

        private static string ValeantClaimType {
            get {
                return "http://schema.valeant/structure";
            }
        }

        private static string ValeantClaimValueType
        {
            get {
                return Microsoft.IdentityModel.Claims.ClaimValueTypes.String;
            }
        }

        public ClaimsProvider(string displayName) : base(displayName) {
        }

        protected override void FillSchema(SPProviderSchema schema) {
            schema.AddSchemaElement(new SPSchemaElement(PeopleEditorEntityDataKeys.DisplayName, "Display Name", SPSchemaElementType.Both));
        }

        protected override void FillClaimTypes(List<string> claimTypes) {
            if (claimTypes == null) throw new ArgumentNullException("claimTypes");
            claimTypes.Add(ValeantClaimType);
        }

        protected override void FillClaimValueTypes(List<string> claimValueTypes) {
            if (claimValueTypes == null) throw new ArgumentNullException("claimValueTypes");
            claimValueTypes.Add(ValeantClaimValueType);
        }

        protected override void FillEntityTypes(List<string> entityTypes) {
            entityTypes.Add(SPClaimEntityTypes.FormsRole);
        }

        protected override void FillClaimsForEntity(Uri context, SPClaim entity, List<SPClaim> claims) {
            if (entity == null) throw new ArgumentNullException("entity");
            if (claims == null) throw new ArgumentNullException("claims");
            var userName = string.Empty;
            var userPipe = entity.Value.LastIndexOf("|");
            if (userPipe > -1) userName = entity.Value.Substring(userPipe + 1);
            var roles = DataProvider.ReadHumanRoles(userName);
            claims.AddRange(roles.Select(role => CreateClaim(ValeantClaimType, role.Name, ValeantClaimValueType)));
        }

        protected override void FillHierarchy(Uri context, string[] entityTypes, string hierarchyNodeId, int numberOfLevels, SPProviderHierarchyTree hierarchy) {
            if (!EntityTypesContain(entityTypes, SPClaimEntityTypes.FormsRole)) return;
            switch (hierarchyNodeId) {
                case null:

                    var roles = DataProvider.ReadRoles();
                    foreach (var role in roles) {
                        hierarchy.AddChild(new SPProviderHierarchyNode(ProviderInternalName, role.Name, role.Id.ToString(CultureInfo.InvariantCulture), true));
                    }
                    break;
            }
        }

        protected override void FillResolve(Uri context, string[] entityTypes, string resolveInput, List<PickerEntity> resolved) {
            if (!EntityTypesContain(entityTypes, SPClaimEntityTypes.FormsRole)) return;
            var roles = DataProvider.ReadRoles();
            resolved.AddRange(from role in roles where String.Equals(role.Name, resolveInput, StringComparison.CurrentCultureIgnoreCase) select GetPickerEntity(role.Name));
        }

        protected override void FillResolve(Uri context, string[] entityTypes, SPClaim resolveInput, List<PickerEntity> resolved) {
            if (!EntityTypesContain(entityTypes, SPClaimEntityTypes.FormsRole)) return;
            var roles = DataProvider.ReadRoles();
            resolved.AddRange(from role in roles where role.Name.ToLower() == resolveInput.Value.ToLower() select GetPickerEntity(role.Name));
        }

        protected override void FillSearch(Uri context, string[] entityTypes, string searchPattern, string hierarchyNodeID, int maxCount, SPProviderHierarchyTree searchTree) {
            if (!EntityTypesContain(entityTypes, SPClaimEntityTypes.FormsRole)) return;
            var roles = DataProvider.ReadRoles();
            foreach (var role in roles) {
                if (!role.Name.ToLower().StartsWith(searchPattern.ToLower())) continue;
                var pe = GetPickerEntity(role.Name);
                SPProviderHierarchyNode matchNode;
                if (!searchTree.HasChild(role.Id.ToString(CultureInfo.InvariantCulture))) {
                    matchNode = new SPProviderHierarchyNode(ProviderInternalName,
                        role.Name,
                        role.Id.ToString(CultureInfo.InvariantCulture),
                        true);
                    searchTree.AddChild(matchNode);
                }
                else
                    matchNode = searchTree.Children.First(theNode => theNode.HierarchyNodeID == role.Id.ToString(CultureInfo.InvariantCulture));
                matchNode.AddEntity(pe);
            }
        }

        public override string Name {
            get
            {
                return ProviderInternalName;
            }
        }

        public override bool SupportsEntityInformation {
            get {
                return true;
            }
        }

        public override bool SupportsHierarchy {
            get {
                return true;
            }
        }

        public override bool SupportsResolve {
            get {
                return true;
            }
        }

        public override bool SupportsSearch {
            get {
                return true;
            }
        }

        private PickerEntity GetPickerEntity(string claimValue) {
            var pe = CreatePickerEntity();
            pe.Claim = CreateClaim(ValeantClaimType, claimValue, ValeantClaimValueType);
            pe.Description = ProviderDisplayName + ":" + claimValue;
            pe.DisplayText = claimValue;
            pe.EntityData[PeopleEditorEntityDataKeys.DisplayName] = claimValue;
            pe.EntityType = SPClaimEntityTypes.FormsRole;
            pe.IsResolved = true;
            pe.EntityGroupName = "Favorite role";
            return pe;
        }
    }
}