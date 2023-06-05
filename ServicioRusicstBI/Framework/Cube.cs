
namespace CustomDataProvider.Web.Framework
{
    using System;
    
    public class AdomdCube : XmlaElement
    {        
        public string CubeType
        {
            get; set;
        }

        public DateTime LastSchemaUpdate
        {
            get; set;
        }

        public DateTime LastDataUpdate
        {
            get; set;
        }

        public string Caption
        {
            get; set;
        }
    }
}
