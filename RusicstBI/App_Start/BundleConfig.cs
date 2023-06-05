using System.Web.Optimization;
using System.Web.UI;

namespace RusicstBI
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include("~/Scripts/modernizr-*"));
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include("~/Scripts/jquery-*"));
            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include("~/Scripts/bootstrap.min.js"));
            bundles.Add(new ScriptBundle("~/bundles/home")
                .Include("~/assets/dist/wow.min.js")
                .Include("~/assets/libs/charts/Chart.min.js")
                .Include("~/assets/dist/jquery.animateNumber.min.js")
                .Include("~/Scripts/jquery.inview.min.js"));
            bundles.Add(new ScriptBundle("~/bundles/charts")
                .Include("~/assets/libs/jqchart/jquery.jqChart.min.js")
                .Include("~/assets/libs/jquery.jqRangeSlider.min.js")
                .Include("~/assets/libs/jquery.mousewheel.js"));
            bundles.Add(new ScriptBundle("~/bundles/map")
                .Include("~/assets/libs/map/raphael.js")
                .Include("~/assets/libs/map/mapsvg.min.js"));

            ScriptManager.ScriptResourceMapping.AddDefinition("respond", new ScriptResourceDefinition
            {
                Path = "~/Scripts/respond.min.js",
                DebugPath = "~/Scripts/respond.js",
            });
        }
    }
}