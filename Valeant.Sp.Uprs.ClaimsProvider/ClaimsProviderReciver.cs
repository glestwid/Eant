using Microsoft.SharePoint;
using Microsoft.SharePoint.Administration.Claims;

namespace Valeant.Sp.Uprs.ClaimsProvider
{
    public class ClaimsProviderReciver : SPClaimProviderFeatureReceiver {
        public override string ClaimProviderAssembly {
            get { return typeof (ClaimsProvider).Assembly.FullName; }
        }

        public override string ClaimProviderType {
            get { return typeof (ClaimsProvider).FullName; }
        }

        public override string ClaimProviderDisplayName {
            get { return ClaimsProvider.ProviderDisplayName; }
        }

        public override string ClaimProviderDescription {
            get { return "Uprs claims provider"; }
        }

        public override void FeatureActivated(SPFeatureReceiverProperties properties) {
            ExecBaseFeatureActivated(properties);
        }

        private void ExecBaseFeatureActivated(SPFeatureReceiverProperties properties) {
            base.FeatureActivated(properties);
        }

        public override void FeatureInstalled(SPFeatureReceiverProperties properties) {
            //throw new Exception("The method  or operation  is not implemented.");
        }
    }
}