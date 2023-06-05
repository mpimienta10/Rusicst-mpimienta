using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace RusicstBI
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            try
            {
                RouteConfig.RegisterRoutes(RouteTable.Routes);
                BundleConfig.RegisterBundles(BundleTable.Bundles);

                System.IO.StreamWriter writer = new System.IO.StreamWriter(Server.MapPath("~/PTE.log"), true);
                writer.WriteLine("App Started: " + DateTime.Now.ToString());
                writer.Flush();
                writer.Close();
            }
            catch (Exception ex)
            {
                System.IO.StreamWriter writer = new System.IO.StreamWriter(Server.MapPath("~/PTE.log"), true);
                writer.WriteLine("App Failed: ");
                writer.WriteLine(ex.ToString());
                writer.Flush();
                writer.Close();
            }
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            Session["identificadorAplicacion"] = Guid.NewGuid().ToString();
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {
            Session.RemoveAll();
        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}