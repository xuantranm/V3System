using System;
using Ap.Business.Domains;
using Vivablast.Models;
namespace Vivablast.ViewModels
{
    using System.Collections.Generic;
    using System.Web.Mvc;

    public class SupplierViewModel : ViewModelBase
    {
        public WAMS_SUPPLIER Supplier { get; set; }
        public WAMS_PRODUCT Product { get; set; }
        public List<WAMS_PRODUCT> ListProducts { get; set; }
        public SelectList Countries { get; set; }
        public SelectList Stores { get; set; }
        public SelectList Types { get; set; }
        public SelectList Suppliers { get; set; }
        public string LstDeleteDetailItem { get; set; }
        public IList<V3_List_Supplier> SupplierGetListResults { get; set; }
        public IList<V3_List_Supplier_Product> GetProductDetails { get; set; }
        public XUser UserLogin { get; set; }
        #region New
        // WAMS_SUPPLIER
        public int Id { get; set; }
        public string vSupplierName { get; set; }
        public string vAddress { get; set; }
        public string vCity { get; set; }
        public string Telephone1 { get; set; }
        public string Telephone2 { get; set; }
        public string Mobile { get; set; }
        public string vFax { get; set; }
        public string Email { get; set; }
        public string vContactPerson { get; set; }
        public decimal? fTotalMoney { get; set; }
        public int? bSupplierTypeID { get; set; }
        public bool? iEnable { get; set; }
        public int? iService { get; set; }
        public DateTime? dDateCreate { get; set; }
        public int? CountryId { get; set; }
        public bool? iMarket { get; set; }
        public int? iStore { get; set; }
        public int? iPayment { get; set; }
        public DateTime? dCreated { get; set; }
        public DateTime? dModified { get; set; }
        public int? iCreated { get; set; }
        public int? iModified { get; set; }
        public byte[] Timestamp { get; set; }

        // WAMS_PRODUCT
        public int? StockId { get; set; }
        public string StockCode { get; set; }
        public string vDescription { get; set; }
        #endregion
    }
}