using System;
using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;
    using System.Web.Mvc;

    using Models;

    public class PriceViewModel: ViewModelBase
    {
        public Product_Price ProductPrice { get; set; }
        public SelectList Stores { get; set; }
        public SelectList Suppliers { get; set; }
        public SelectList Currencies { get; set; }
        public SelectList StatusPrice { get; set; }

        public int Status { get; set; }

        public string LstDeleteDetailItem { get; set; }

        #region New
        public IList<V3_List_Price> ListPrice { get; set; }
        public int Id { get; set; }
        public int? StockId { get; set; }
        public string StockCode { get; set; }
        public string StockName { get; set; }
        public string StockType { get; set; }
        public string Unit { get; set; }
        public string PartNo { get; set; }
        public string RalNo { get; set; }
        public string ColorName { get; set; }
        public decimal? Price { get; set; }
        public int? StoreId { get; set; }
        public int? SupplierId { get; set; }
        public int? CurrencyId { get; set; }
        public DateTime? dStart { get; set; }
        public DateTime? dEnd { get; set; }
        public bool? iEnable { get; set; }
        public DateTime? dCreated { get; set; }
        public DateTime? dModified { get; set; }
        public int? iCreated { get; set; }
        public int? iModified { get; set; }
        public byte[] Timestamp { get; set; }
        #endregion

        public XUser UserLogin { get; set; }

        public string dStartTemp { get; set; }
        public string dEndTemp { get; set; }
    }
}