using System;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;

    using System.Web.Mvc;

    public class AssignViewModel : ViewModelBase
    {
        public IList<V3_List_StockAssign> AssignStockList { get; set; }

        public IList<V3_List_StockAssign_Detail> StockAssignDetailList { get; set; }

        public SelectList Stores { get; set; }

        public int StoreId { get; set; }

        public SelectList Projects { get; set; }

        public SelectList ProjectNames { get; set; }

        public SelectList StockTypes { get; set; }

        public int StockTypeId { get; set; }

        public WAMS_ASSIGNNING_STOCKS AssignStock { get; set; }

        public List<WAMS_ASSIGNNING_STOCKS> AssignStockItemList { get; set; }

        public List<V3_GetAssignedStockBySIV_Result> AssignedStockBySivResults { get; set; }

        public string Siv { get; set; }

        public string LstDeleteDetailItem { get; set; }

        // Get List Item Stock assigned

        public XUser UserLogin { get; set; }

        #region Master
        public int bAssignningStockID { get; set; }
        public int vStockID { get; set; }
        public int? vProjectID { get; set; }
        public decimal? bQuantity { get; set; }
        public string vWorkerID { get; set; }
        public string SIV { get; set; }
        public string vMRF { get; set; }
        public int? FromStore { get; set; }
        public int? ToStore { get; set; }
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

        public string Description { get; set; }

        public DateTime? DateStockOut { get; set; }
        #endregion

        #region Detail
        public int? StockId { get; set; }
        public string StockCode { get; set; }
        #endregion

        public string ProjectName { get; set; }

        public string ProjectCode { get; set; }
    }
}