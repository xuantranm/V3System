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
    
    public partial class WAMS_FUNCTION_MANAGEMENT: BaseEntity
    {
        [Key]
        public int bFunctionID { get; set; }
        public Nullable<int> bUserID { get; set; }
        public string vFunctionManagement { get; set; }
        public string vPrice { get; set; }
        public Nullable<int> iReport { get; set; }
        public string vLanguage { get; set; }
        public Nullable<bool> iEnable { get; set; }
        public Nullable<int> User { get; set; }
        public Nullable<int> Project { get; set; }
        public Nullable<int> Store { get; set; }
        public Nullable<int> Stock { get; set; }
        public Nullable<int> Requisition { get; set; }
        public Nullable<int> StockOut { get; set; }
        public Nullable<int> StockReturn { get; set; }
        public Nullable<int> StockIn { get; set; }
        public Nullable<int> ReActiveStock { get; set; }
        public Nullable<int> PE { get; set; }
        public Nullable<int> Supplier { get; set; }
        public Nullable<int> Price { get; set; }
        public Nullable<int> StockService { get; set; }
        public Nullable<int> Accounting { get; set; }
        public Nullable<int> Maintenance { get; set; }
        public Nullable<int> Worker { get; set; }
        public Nullable<int> Shippment { get; set; }
        public Nullable<int> ReturnSupplier { get; set; }
        public Nullable<int> StockType { get; set; }
        public Nullable<int> Category { get; set; }
        public byte[] Timestamp { get; set; }
    
        public virtual WAMS_USER WAMS_USER { get; set; }
    }
}
