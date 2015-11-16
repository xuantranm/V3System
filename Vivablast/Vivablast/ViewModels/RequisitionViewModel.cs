using System;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;
    using System.Web.Mvc;
    using Ap.Business.Domains;
    using Models;

    public class RequisitionViewModel : ViewModelBase
    {
        public WAMS_REQUISITION_MASTER RequisitionMaster { get; set; }

        public WAMS_REQUISITION_DETAILS RequisitionDetail { get; set; }

        public List<WAMS_REQUISITION_DETAILS> ListRequisitionDetails { get; set; }

        public string Mrf { get; set; }
        
        public string Status { get; set; }
        
        public SelectList Stores { get; set; }
        
        public SelectList Projects { get; set; }

        public SelectList ProjectNames { get; set; }
        public string LstDeleteDetailItem { get; set; }

        #region New
        public IList<V3_List_Requisition> RequisitionGetListResults { get; set; }

        public IList<V3_RequisitionDetail_Result> GetRequisitionDetailsVResults { get; set; }

        #region Master
        public int Id { get; set; }

        public string vMRF { get; set; }

        public string vFrom { get; set; }

        public int? vProjectID { get; set; }

        public DateTime? dDeliverDate { get; set; }

        public string vDeliverLocation { get; set; }

        public string vStatus { get; set; }

        public int? iStore { get; set; }

        public byte[] Timestamp { get; set; }

        #endregion

        #region Detail
        public int? StockId { get; set; }
        public string StockCode { get; set; }
        public string StockName { get; set; }
        public string StockType { get; set; }
        public string Unit { get; set; }
        public string PartNo { get; set; }
        public string RalNo { get; set; }
        public string ColorName { get; set; }
        public decimal? fQuantity { get; set; }
        public string Quantities { get; set; }
        public decimal? fUMO { get; set; }
        public decimal? fInStock { get; set; }
        public decimal? fTobePurchased { get; set; }
        public int? iFollowUpRequired { get; set; }
        public int? iPurchased { get; set; }
        public int? iSent { get; set; }
        public DateTime? dCreated { get; set; }
        #endregion

        #endregion

        public XUser UserLogin { get; set; }

        public string DeliverDateTemp { get; set; }

        public string ProjectCode { get; set; }

        public string ProjectName { get; set; }

        public string Remark { get; set; }
    }
}