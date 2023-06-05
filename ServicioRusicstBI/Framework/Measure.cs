namespace CustomDataProvider.Web.Framework
{
    public class AdomdMeasure : XmlaElement
    {
        public string Name { get; set; }

        public string UniqueName { get; set; }

        public string Caption { get; set; }

        public string Aggregator { get; set; }
      
        public string MeasureGroupName { get; set; }

        public string DefaultFormatString { get; set; }
    }
}
