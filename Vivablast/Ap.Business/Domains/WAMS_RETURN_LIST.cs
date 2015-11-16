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
    
    public partial class WAMS_RETURN_LIST : BaseEntity
    {
        [Key]
        public int bReturnListID { get; set; }
        public int vStockID { get; set; }
        public Nullable<int> vProjectID { get; set; }
        public Nullable<decimal> bQuantity { get; set; }
        public string vCondition { get; set; }
        public string SRV { get; set; }
        public Nullable<int> FromStore { get; set; }
        public Nullable<int> ToStore { get; set; }
        public Nullable<System.DateTime> dCreated { get; set; }
        public Nullable<System.DateTime> dModified { get; set; }
        public Nullable<int> iCreated { get; set; }
        public Nullable<int> iModified { get; set; }
        public Nullable<int> AccCheck { get; set; }
        public string AccDescription { get; set; }
        public Nullable<System.DateTime> AccdCreated { get; set; }
        public Nullable<System.DateTime> AccdModified { get; set; }
        public Nullable<int> AcciCreated { get; set; }
        public Nullable<int> AcciModidied { get; set; }
        public Nullable<bool> FlagFile { get; set; }
        public byte[] Timestamp { get; set; }
    
        //public virtual WAMS_PROJECT WAMS_PROJECT { get; set; }
        //public virtual WAMS_STOCK WAMS_STOCK { get; set; }
    }
}
