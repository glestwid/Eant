using System.Web;
using System.Web.Optimization;

namespace Valeant.Sp.UprsWeb
{
    public static class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            // Temporary disable due to 401 error :(
            BundleTable.EnableOptimizations = false;

            bundles.Add(new ScriptBundle("~/bundles/Scripts")
                .Include("~/Scripts/jquery-2.2.1.min.js")
                //.Include("~/Scripts/jquery.maskedinput.min.js")
                .Include("~/Scripts/bootstrap.min.js")
                .Include("~/Scripts/angular.min.js")
                .Include("~/Scripts/angular-animate.min.js")
                .Include("~/Scripts/angular-sanitize.min.js")
                .Include("~/Scripts/angular-ui-router.min.js")
                .Include("~/Scripts/angular-ui/ui-utils.js")
                .Include("~/Scripts/angular-ui/ui-mask.js")
                .Include("~/Scripts/ui-grid.js")
                .Include("~/Scripts/jquery.slimscroll.min.js")
                .Include("~/Scripts/angular-toastr.min.js")
                .Include("~/Scripts/angular-toastr.tpls.min.js")
                .Include("~/Scripts/bootstrap-select.js")
                .Include("~/Scripts/angular-bootstrap-select.js")
                .Include("~/Scripts/angular-bootstrap-checkbox.js")
                .Include("~/Scripts/angular-bootstrap-radio.js")
                .Include("~/Scripts/moment-with-locales.min.js")
                .Include("~/Scripts/angular-moment.min.js")
                .Include("~/Scripts/daterangepicker.js")
                .Include("~/Scripts/angular-daterangepicker.js")
                .Include("~/Scripts/ng-pattern-restrict.js")
                .Include("~/Scripts/angular-ui/ui-bootstrap.min.js")
                .Include("~/Scripts/angular-ui/ui-bootstrap-tpls.js")
                .Include("~/Scripts/angular-ui-form-validation.js")
                .Include("~/Scripts/loading-bar.min.js")
                .Include("~/Scripts/oi.select/select-tpls.js")
                .Include("~/Scripts/polyfills.js")
                .Include("~/Scripts/DateTimeUtil.js")
                
                .Include("~/Scripts/jquery.blockUI.js"));

            bundles.Add(new ScriptBundle("~/bundles/angConfigs")
                .IncludeDirectory("~/app/configs", "*.js"));

            bundles.Add(new ScriptBundle("~/bundles/angControllers")
                .IncludeDirectory("~/app/controllers", "*.js")
                .IncludeDirectory("~/app/controllers/advanceReportsControllers", "*.js")
                .IncludeDirectory("~/app/controllers/reportsControllers", "*.js")
                .IncludeDirectory("~/app/controllers/requestsControllers", "*.js")
                .IncludeDirectory("~/app/controllers/settingsControllers", "*.js"));

            bundles.Add(new ScriptBundle("~/bundles/angDirectives")
                .IncludeDirectory("~/app/directives", "*.js"));

            bundles.Add(new ScriptBundle("~/bundles/angServices")
                .IncludeDirectory("~/app/services", "*.js"));

            bundles.Add(new ScriptBundle("~/bundles/angFilters")
                .IncludeDirectory("~/app/filters", "*.js"));


            bundles.Add(new ScriptBundle("~/bundles/spcontext").Include(
                        "~/Scripts/spcontext.js"));

            bundles.Add(new StyleBundle("~/Content/css")
                .Include("~/Content/angular-toastr.css")
                .Include("~/Content/bootstrap.css")
                .Include("~/Content/bootstrap-select.min.css")
                .Include("~/Content/font-awesome.css")
                .Include("~/Content/angular-bootstrap-radio.css")
                .Include("~/Content/daterangepicker.css")
                .Include("~/Content/ui-grid.css")
                .Include("~/Content/loading-bar.css")
                .Include("~/Scripts/oi.select/select.css")
                .Include("~/css/styles.css")
                .Include("~/css/grid-styles.css"));
        }
    }
}
