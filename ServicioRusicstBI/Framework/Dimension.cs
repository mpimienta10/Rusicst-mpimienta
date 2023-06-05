namespace CustomDataProvider.Web.Framework
{
    using System.Collections.Generic;

    public class AdomdDimension : XmlaElement
    {
        public AdomdDimension()
        {
            this.Hierarchies = new List<AdomdHierarchy>();
        }

        public string Name
        {
            get; set;
        }

        public string UniqueName
        {
            get; set;
        }

        public string Caption
        {
            get; set;
        }

        public string DimensionType
        {
            get; set;
        }

        public List<AdomdHierarchy> Hierarchies
        {
            get; set;
        }
    }
}
