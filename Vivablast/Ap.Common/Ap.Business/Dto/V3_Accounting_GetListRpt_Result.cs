//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Vivablast.Models
{
    using System;
    
    public partial class V3_Accounting_GetListRpt_Result
    {
        public Nullable<long> No { get; set; }
        public int Id { get; set; }
        public int StockId { get; set; }
        public string stockCode { get; set; }
        public string vStockName { get; set; }
        public Nullable<decimal> Qty { get; set; }
        public decimal QtyPending { get; set; }
        public decimal QtyPO { get; set; }
        public string SIRVFag { get; set; }
        public string AccStatus { get; set; }
        public string SIRV { get; set; }
        public Nullable<int> StoreFromId { get; set; }
        public string StoreFromName { get; set; }
        public Nullable<int> StoreToId { get; set; }
        public string StoreToName { get; set; }
        public Nullable<int> ProjectId { get; set; }
        public string projectCode { get; set; }
        public string vProjectName { get; set; }
        public string POCode { get; set; }
        public int SupplierId { get; set; }
        public string SupplierName { get; set; }
        public Nullable<System.DateTime> dCreated { get; set; }
        public Nullable<System.DateTime> dModified { get; set; }
        public string Created_By { get; set; }
        public string Modified_By { get; set; }
        public Nullable<int> AccCheck { get; set; }
        public string AccDescription { get; set; }
        public Nullable<System.DateTime> AccdCreated { get; set; }
        public Nullable<System.DateTime> AccdModified { get; set; }
        public Nullable<int> AcciCreated { get; set; }
        public string CheckBy { get; set; }
    }
}
