using System.Collections.Generic;

namespace CustomDataProvider.Web.Framework
{
    public class MemberData
    {
        public bool DrilledDown { get; set; }

        public bool ParentSameAsPrevious { get; set; }

        public string Name { get; set; }

        public string UniqueName { get; set; }

        public string Caption { get; set; }

        public string ParentUniqueName { get; set; }

        public string LevelName { get; set; }

        public int LevelDepth { get; set; }

        public int ChildCount { get; set; }
    }

    public class GridData
    {
        public List<AxisData> Axes { get; set; }

        public List<CellData> Cells { get; set; }
    }

    public class AxisData
    {
        public List<PositionData> Positions { get; set; }
    }

    public class PositionData
    {
        public List<MemberData> Members { get; set; }

        public int Ordinal { get; set; }
    }

    public class CellData
    {
        public object Value { get; set; }

        public string FormattedValue { get; set; }
    }
}