using System;
using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;
    using System.Web.Mvc;

    using Vivablast.Models;

    public class POViewModel: ViewModelBase
    {
        public WAMS_PURCHASE_ORDER PurchaseOrder { get; set; }

        public V3_PE_PDF PurchaseOrderCustom { get; set; }
        public List<WAMS_PO_DETAILS> ListPoDetail { get; set; }

        public List<V3_Pe_Detail_Data> ListPoDetailData { get; set; } 
        public SelectList Stores { get; set; }
        public SelectList PoTypes { get; set; }
        public SelectList Suppliers { get; set; }
        public SelectList Projects { get; set; }
        public SelectList ProjectNames { get; set; }
        public SelectList POs { get; set; }
        public SelectList Currencies { get; set; }
        public SelectList Payments { get; set; }
        public SelectList VatList { get; set; }
        public string LstDeleteDetailItem { get; set; }

        #region New
        public IList<V3_List_PO> PoGetListResults { get; set; }
        public IList<V3_Pe_Detail> PoDetailsVResults { get; set; }
        public V3_PE_Information PoGetInformation { get; set; }
        public int StoreId { get; set; }

        #region Master
        public int Id { get; set; }
        public string vPOID { get; set; }
        public int? vProjectID { get; set; }
        public int bSupplierID { get; set; }
        public int? bPOTypeID { get; set; }
        public int? bCurrencyTypeID { get; set; }
        public DateTime dPODate { get; set; }
        public decimal? fPOTotal { get; set; }
        public string vRemark { get; set; }
        public string vPriceEval { get; set; }
        public string vQuanlityEval { get; set; }
        public string vDeliveryEval { get; set; }
        public string vConformancyToV3Eval { get; set; }
        public string vFromCC { get; set; }
        public string vFromContact { get; set; }
        public string vFromTel { get; set; }
        public string vFromFax { get; set; }
        public string vTermOfPayment { get; set; }
        public bool? iEnable { get; set; }
        public int? iExample { get; set; }
        public string vPOStatus { get; set; }
        public string vLocation { get; set; }
        public DateTime? dDeliverDate { get; set; }
        public string Address { get; set; }
        public string TaxCode { get; set; }
        public string PeStaff { get; set; }
        public string CoRegNo { get; set; }
        public string GSTRegNo { get; set; }
        public string PengerangSite { get; set; }
        public string GSTAddress { get; set; }
        public int? iStore { get; set; }
        public string Payment { get; set; }
        public byte[] Timestamp { get; set; }
        #endregion

        #region Detail
        public int? Mrf { get; set; }
        public int StockId { get; set; }
        public string StockCode { get; set; }
        public decimal Quantity { get; set; }
        public int PriceId { get; set; }

        public decimal fUnitPrice { get; set; }
        public int Discount { get; set; }
        public int VAT { get; set; }
        public decimal ItemTotal { get; set; }
        public DateTime? DeliveryDate { get; set; }
        public string RemarkDetail { get; set; }
        #endregion

        #endregion

        public XUser UserLogin { get; set; }

        public string sPODate { get; set; }
        public string sDeliveryDate { get; set; }

        public string ProjectName { get; set; }

        // this list has all movies available for dropdown
        public IList<V3_GetRequisitionDDL> AvailableMrfs { get; set; }
        // this list has our default values 
        public IList<V3_GetRequisitionDDL> DefaultMrfs { get; set; }
        // this will retrieve the ids of movies selected in list when submitted
        public List<string> MrfsChose { get; set; }
    }
}