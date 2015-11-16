using System.ComponentModel;
using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System;
    using System.Collections.Generic;
    using System.Web.Mvc;

    public class UserViewModel : ViewModelBase
    {
        public XUser UserLogin { get; set; }
        public XUser Entity { get; set; }
        public IList<XUser> XUserList { get; set; } 
        public SelectList Stores { get; set; }
        public SelectList Rights { get; set; }
        public SelectList Deparments { get; set; }
        public string PasswordCurrent { get; set; }
        public string EmailCurrent { get; set; }

        #region Model to ViewModel
        public int Id { get; set; }
        [DisplayName("User Name")]
        public string UserName { get; set; }
        public string Password { get; set; }

        public string RePassword { get; set; }
        [DisplayName("First Name")]
        public string FirstName { get; set; }
        [DisplayName("Last Name")]
        public string LastName { get; set; }
        public int? DepartmentId { get; set; }
        public string Department { get; set; }
        public string Telephone { get; set; }
        public string Mobile { get; set; }
        public string Email { get; set; }
        public bool? Enable { get; set; }
        public int? StoreId { get; set; }
        public string Store { get; set; }
        [DisplayName("User")]
        public int? UserR { get; set; }
        [DisplayName("Project")]
        public int? ProjectR { get; set; }
        [DisplayName("Store")]
        public int? StoreR { get; set; }
        [DisplayName("Stock")]
        public int? StockR { get; set; }
        [DisplayName("Requisition")]
        public int? RequisitionR { get; set; }
        [DisplayName("Stock Out")]
        public int? StockOutR { get; set; }
        [DisplayName("Stock Return")]
        public int? StockReturnR { get; set; }
        [DisplayName("Stock In")]
        public int? StockInR { get; set; }
        [DisplayName("Re-active Stock")]
        public int? ReActiveStockR { get; set; }
        [DisplayName("PE")]
        public int? PER { get; set; }
        [DisplayName("Supplier")]
        public int? SupplierR { get; set; }
        [DisplayName("Price")]
        public int? PriceR { get; set; }
        [DisplayName("Stock Service")]
        public int? StockServiceR { get; set; }
        [DisplayName("Accounting")]
        public int? AccountingR { get; set; }
        [DisplayName("Maintenance")]
        public int? MaintenanceR { get; set; }
        [DisplayName("Worker")]
        public int? WorkerR { get; set; }
        [DisplayName("Shippment")]
        public int? ShippmentR { get; set; }
        [DisplayName("Return Supplier")]
        public int? ReturnSupplierR { get; set; }
        [DisplayName("Stock Type")]
        public int? StockTypeR { get; set; }
        [DisplayName("Category")]
        public int? CategoryR { get; set; }
        public DateTime? Created { get; set; }
        public DateTime? Modified { get; set; }
        [DisplayName("Created By")]
        public int? CreatedBy { get; set; }
        [DisplayName("Modified By")]
        public int? ModifiedBy { get; set; }
        public byte[] Timestamp { get; set; }
        #endregion
    }
}