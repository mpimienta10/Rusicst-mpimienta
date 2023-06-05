namespace CustomDataProvider.Web.Framework
{
    using System.Collections.Generic;

    /// <summary>
    /// Represents a hierarchy within a dimension.
    /// </summary>
    public class AdomdHierarchy : XmlaElement
    {
        public AdomdHierarchy()
        {
            this.Levels = new List<AdomdLevel>();
        }

        #region Properties

        #region Implementation of IHierarchy

        /// <summary>
        /// Gets or sets the unique name of the dimension this hierarchy belongs to.
        /// </summary>
        public string DimensionUniqueName
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets the name of the hierarchy.
        /// </summary>
        /// <value>The name of the hierarchy.</value>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the unique name of the hierarchy.
        /// </summary>
        /// <value>The unique name of the hierarchy.</value>
        public string UniqueName { get; set; }

        /// <summary>
        /// Gets or sets the caption of the hierarchy.
        /// </summary>
        /// <value>The caption.</value>
        public string Caption { get; set; }

        /// <summary>
        /// Gets or sets the unique name of the default member for the Hierarchy
        /// </summary>
        /// <value>The unique name of the default member for the Hierarchy.</value>
        public string DefaultMember { get; set; }

        /// <summary>
        /// Gets or sets the "All" member of this hierarchy.
        /// </summary>
        /// <value>The "All" member.</value>
        public string AllMember { get; set; }

        public List<AdomdLevel> Levels
        {
            get;
            set;
        }

        #endregion // Implementation of IHierarchy

        #region Internal
        
        #endregion // Internal

        #endregion Properties
    }
}
