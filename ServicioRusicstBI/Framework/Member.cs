namespace CustomDataProvider.Web.Framework
{
    public class AdomdMember : XmlaElement
    {       
        public string LevelUniqueName { get; set; }

        public uint LevelNumber { get; set; }

        public string Name { get; set; }

        public string UniqueName { get; set; }

        public string Caption { get; set; }

        public int ChildrenCardinality { get; set; }

        public string ParentUniqueName { get; set; }        
    }
}
