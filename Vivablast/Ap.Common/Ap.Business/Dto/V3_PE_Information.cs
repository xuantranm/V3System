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

    public partial class V3_PE_Information
    {
        public int Id { get; set; }
        public string PE { get; set; }
        public System.DateTime PE_Date { get; set; }
        public Nullable<decimal> Total { get; set; }
        public string Remark { get; set; }
        public string Status { get; set; }
        public string Location { get; set; }
        public Nullable<System.DateTime> Deliver_Date { get; set; }
        public Nullable<int> Project_Id { get; set; }
        public int Supplier_Id { get; set; }
        public Nullable<int> Type_Id { get; set; }
        public Nullable<int> Currency_Id { get; set; }
        public string Currency { get; set; }
        public string CC { get; set; }
        public string Delivery_Place { get; set; }
        public Nullable<int> Payment_Id { get; set; }
        public Nullable<int> Store_Id { get; set; }
        public Nullable<int> Created_Id { get; set; }
        public Nullable<System.DateTime> Created_Date { get; set; }
        public byte[] Timestamp { get; set; }
    }
}
