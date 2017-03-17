namespace Vivablast
{
    using System.Web.Optimization;

    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-1.10.2.js", "~/Scripts/jquery.numeric.js", "~/Scripts/jquery.tmpl.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryui").Include(
                        "~/Scripts/jquery-ui-1.10.3.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.unobtrusive*",
                        "~/Scripts/jquery.validate*"));

            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                "~/Scripts/bootstrap.js", "~/Content/bootstrap-datepicker/js/bootstrap-datepicker.js"));

            bundles.Add(new ScriptBundle("~/bundles/helpers").Include(
                "~/Scripts/helpers.js", "~/Scripts/modernizr 2.6.2.js", "~/Scripts/plugins/tmx.popup.js"));

            bundles.Add(new ScriptBundle("~/bundles/chosen").Include(
                        "~/Scripts/chosen.jquery.js"));

            bundles.Add(new ScriptBundle("~/bundles/dataTables").Include(
                        // Gan vo ui bi die "~/Scripts/pages/CompleteMin.js",
                        "~/Scripts/pages/jquery.dataTables.js", 
                        "~/Scripts/pages/ColReorderWithResize.js"));
           
            bundles.Add(new ScriptBundle("~/bundles/user").Include("~/Scripts/pages/user.js"));

            bundles.Add(new ScriptBundle("~/bundles/pe-act").Include("~/Scripts/custom/tmx.peact.js"));

            bundles.Add(new ScriptBundle("~/bundles/knockout").Include("~/Scripts/knockout-{version}.js"));

            // HTML5 IE enabling script
            bundles.Add(new ScriptBundle("~/bundles/html5shiv").Include("~/Scripts/html5shiv.js"));

            // A fast & lightweight polyfill for min/max-width CSS3 Media Queries (for IE 6-8, and more)
            bundles.Add(new ScriptBundle("~/bundles/respond").Include("~/Scripts/respond.min.js"));
            
            bundles.Add(new StyleBundle("~/Content/bootstrap").Include("~/Content/css/bootstrap.css"));

            bundles.Add(new StyleBundle("~/Content/datebootstrap").Include("~/Content/bootstrap-datepicker/css/datepicker3.css"));

            bundles.Add(new StyleBundle("~/Content/custom").Include("~/Content/css/custom.css"));

            bundles.Add(new StyleBundle("~/Content/fixdata").Include("~/Content/css/fixdata.css"));

            bundles.Add(new StyleBundle("~/Content/chosen").Include("~/Content/css/chosen.css"));

            bundles.Add(new StyleBundle("~/Content/login").Include("~/Content/css/reset.css", "~/Content/css/animate.css", "~/Content/css/styles.css"));

            bundles.Add(new StyleBundle("~/Content/themes/base/jqueryui").Include(
                        "~/Content/themes/base/jquery-ui.css"));

            bundles.Add(new StyleBundle("~/Content/themes/base/css").Include(
                        "~/Content/themes/base/jquery.ui.core.css",
                        "~/Content/themes/base/jquery.ui.resizable.css",
                        "~/Content/themes/base/jquery.ui.selectable.css",
                        "~/Content/themes/base/jquery.ui.accordion.css",
                        "~/Content/themes/base/jquery.ui.autocomplete.css",
                        "~/Content/themes/base/jquery.ui.button.css",
                        "~/Content/themes/base/jquery.ui.dialog.css",
                        "~/Content/themes/base/jquery.ui.slider.css",
                        "~/Content/themes/base/jquery.ui.tabs.css",
                        "~/Content/themes/base/jquery.ui.datepicker.css",
                        "~/Content/themes/base/jquery.ui.progressbar.css",
                        "~/Content/themes/base/jquery.ui.theme.css"));
        }
    }
}