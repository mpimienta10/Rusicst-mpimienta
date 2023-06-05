using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace RusicstBI
{
    /// <summary>
    /// This is a hack to force no mobile URL resolution in FriendlyUrls.  There's some kind of bug in the current version that
    /// causes it to do an internal failed resolve of a mobile master even though there is none.
    /// </summary>
    public class BugFixFriendlyUrlResolver : Microsoft.AspNet.FriendlyUrls.Resolvers.WebFormsFriendlyUrlResolver
    {
        protected override bool TrySetMobileMasterPage(HttpContextBase httpContext, Page page, string mobileSuffix)
        {
            return false;
            //return base.TrySetMobileMasterPage(httpContext, page, mobileSuffix);
        }
    }
}