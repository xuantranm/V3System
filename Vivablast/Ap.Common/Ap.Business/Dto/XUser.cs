//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using Ap.Data.Entities;

namespace Ap.Business.Dto
{
    using System;
    using System.Collections.Generic;
    
    public partial class V3_User
    {
        public int Id { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int? DepartmentId { get; set; }
        public string Department { get; set; }
        public string Telephone { get; set; }
        public string Mobile { get; set; }
        public string Email { get; set; }
        public Nullable<bool> Enable { get; set; }
        public int? StoreId { get; set; }
        public string Store { get; set; } 
        public string UserR { get; set; } 
        public string ProjectR { get; set; }
        public string StoreR { get; set; } 
        public string StockR { get; set; }
        public string RequisitionR { get; set; } 
        public string StockOutR { get; set; }
        public string StockReturnR { get; set; }
        public string StockInR { get; set; }
        public string ReActiveStockR { get; set; }
        public string PER { get; set; }
        public string SupplierR { get; set; }
        public string PriceR { get; set; }
        public string StockServiceR { get; set; } 
        public string AccountingR { get; set; }
        public string MaintenanceR { get; set; }
        public string WorkerR { get; set; }
        public string ShippmentR { get; set; }
        public string ReturnSupplierR { get; set; }
        public string StockTypeR { get; set; } 
        public string CategoryR { get; set; }
        public Nullable<System.DateTime> Created { get; set; }
        public Nullable<System.DateTime> Modified { get; set; }
        public string CreatedBy { get; set; }
        public string ModifiedBy { get; set; }
        public byte[] Timestamp { get; set; }
    }
}