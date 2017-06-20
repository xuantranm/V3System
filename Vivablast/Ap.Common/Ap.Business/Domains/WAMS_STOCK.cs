//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System.ComponentModel.DataAnnotations;
using Ap.Data.Entities;

namespace Ap.Business.Domains
{
    using System;
    using System.Collections.Generic;
    
    public partial class WAMS_STOCK: BaseEntity
    {
        //public WAMS_STOCK()
        //{
        //    this.WAMS_ASSIGNNING_STOCKS = new HashSet<WAMS_ASSIGNNING_STOCKS>();
        //    this.WAMS_FULFILLMENT_DETAIL = new HashSet<WAMS_FULFILLMENT_DETAIL>();
        //    this.WAMS_RETURN_LIST = new HashSet<WAMS_RETURN_LIST>();
        //}

        [Key]
        public int Id { get; set; }
        public string vStockID { get; set; }
        public string vStockName { get; set; }
        public string vRemark { get; set; }
        public Nullable<int> bUnitID { get; set; }
        public Nullable<long> bMeasurementID { get; set; }
        public string vBrand { get; set; }
        public Nullable<bool> iEnable { get; set; }
        public Nullable<int> bCategoryID { get; set; }
        public Nullable<int> bPositionID { get; set; }
        public Nullable<int> bLabelID { get; set; }
        public Nullable<double> bWeight { get; set; }
        public string vAccountCode { get; set; }
        public Nullable<int> iType { get; set; }
        public string PartNo { get; set; }
        public string PartNoFor { get; set; }
        public Nullable<int> PartNoMiniQty { get; set; }
        public string RalNo { get; set; }
        public string ColorName { get; set; }
        public string Position { get; set; }
        public Nullable<int> SubCategory { get; set; }
        public Nullable<int> UserForPaint { get; set; }
        public Nullable<System.DateTime> dCreated { get; set; }
        public Nullable<System.DateTime> dModified { get; set; }
        public Nullable<int> iCreated { get; set; }
        public Nullable<int> iModified { get; set; }
        public byte[] Timestamp { get; set; }

        public string Unit { get; set; }
        public string Category { get; set; }
        public string Label { get; set; }
        public string Type { get; set; }
        public string Files { get; set; }
        public string OrginalFile { get; set; }
        public string FilePath { get; set; }

        //public virtual ICollection<WAMS_ASSIGNNING_STOCKS> WAMS_ASSIGNNING_STOCKS { get; set; }
        //public virtual ICollection<WAMS_FULFILLMENT_DETAIL> WAMS_FULFILLMENT_DETAIL { get; set; }
        //public virtual WAMS_MEASUREMENT WAMS_MEASUREMENT { get; set; }
        //public virtual ICollection<WAMS_RETURN_LIST> WAMS_RETURN_LIST { get; set; }
    }
}
