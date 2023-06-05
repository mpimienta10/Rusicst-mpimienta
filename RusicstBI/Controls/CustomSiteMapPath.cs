using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RusicstBI.Controls
{
    public class CustomSiteMapPath
    {
        public static string CustomSiteMap(System.Web.SiteMapNode node)
        {
            return ListChildNodes(node);
        }

        private static string ListChildNodes(System.Web.SiteMapNode currentNode)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append("<ol class=\"breadcrumb\">");

            if (currentNode != null)
            {
                var node = currentNode;
                var nodes = new Stack<SiteMapNode>();
                while (node.ParentNode != null)
                {
                    nodes.Push(node);
                    node = node.ParentNode;
                }
                nodes.Push(node);

                int i = 0;
                while (nodes.Count != 0)
                {
                    var n = nodes.Pop();
                    if (i == 0)
                    {
                        sb.Append(string.Concat("<li><a href=\"", n.Url, "\"><span class=\"glyphicon glyphicon-home\" aria-hidden=\"true\"></span>", n.Title, "</a></li>"));
                    }
                    else if (nodes.Count == 0)
                    {
                        sb.Append(string.Concat("<li class=\"active\">", n.Title, "</li>"));
                    }
                    else
                    {
                        sb.Append(string.Concat("<li>", "<a href=\"", n.Url, "\">", n.Title, "</a></li>"));
                    }
                    i++;
                }
            }
            else
            {
                sb.Append(string.Concat("<li><a href=\"/\"><span class=\"glyphicon glyphicon-home\" aria-hidden=\"true\"></span>Inicio</a></li>"));
            }

            sb.Append("</ol>");

            return sb.ToString();
        }
    }
}