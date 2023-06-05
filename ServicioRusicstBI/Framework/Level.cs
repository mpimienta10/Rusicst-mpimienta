namespace CustomDataProvider.Web.Framework
{
    public class AdomdLevel : XmlaElement
    {
        public string DimensionUniqueName { get; set; }

        public string HierarchyUniqueName { get; set; }

        public string Name { get; set; }

        public string UniqueName { get; set; }

        public string Caption { get; set; }

        public uint Number { get; set; }       
    }
}
