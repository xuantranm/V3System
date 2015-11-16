using System;
using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;

    using Models;
    using System.Web.Mvc;

    public class FulfillmentViewModel : ViewModelBase
    {
        public IList<V3_List_StockIn> StockInList { get; set; }

        public List<V3_List_StockIn_Detail> StockInDetailList { get; set; }

        public WAMS_FULFILLMENT_DETAIL FulfillmentDetail { get; set; }

        public List<WAMS_FULFILLMENT_DETAIL> ListFulfillmentDetail { get; set; }

        public WAMS_PURCHASE_ORDER PurchaseOrder { get; set; }

        public SelectList Stores { get; set; }

        public SelectList PoTypes { get; set; }

        public int? PoTypeId { get; set; }

        public SelectList Suppliers { get; set; }

        public int? SupplierId { get; set; }

        public SelectList PEs { get; set; }

        public string LstDeleteDetailItem { get; set; }

        public XUser UserLogin { get; set; }

        public List<WAMS_PO_DETAILS> ListAccountingUpdate { get; set; }

        #region Master
        public int ID { get; set; }
        public int? vPOID { get; set; }
        public int? vStockID { get; set; }
        public decimal? dQuantity { get; set; }
        public decimal? dReceivedQuantity { get; set; }
        public decimal? dPendingQuantity { get; set; }
        public DateTime? dDateDelivery { get; set; }
        public string iShipID { get; set; }
        public string tDescription { get; set; }
        public string vMRF { get; set; }
        public decimal? dCurrenQuantity { get; set; }
        public DateTime? dInvoiceDate { get; set; }
        public string vInvoiceNo { get; set; }
        public decimal? dImportTax { get; set; }
        public bool? iEnable { get; set; }
        public DateTime? dDateAssign { get; set; }
        public string SRV { get; set; }
        public int? iStore { get; set; }
        public DateTime? dCreated { get; set; }
        public DateTime? dModified { get; set; }
        public int? iCreated { get; set; }
        public int? iModified { get; set; }
        public int? AccCheck { get; set; }
        public string AccDescription { get; set; }
        public DateTime? AccdCreated { get; set; }
        public DateTime? AccdModified { get; set; }
        public int? AcciCreated { get; set; }
        public int? AcciModidied { get; set; }
        public bool? FlagFile { get; set; }
        public byte[] Timestamp { get; set; }
        #endregion

        #region Detail
        public int? StockId { get; set; }
        public string StockCode { get; set; }
        #endregion
    }
}