using System;
using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;

    using Vivablast.Models;
    using System.Web.Mvc;

    public class ReturnViewModel : ViewModelBase
    {
        public IList<V3_List_StockReturn> ReturnStockList { get; set; }

        public IList<V3_List_StockReturn_Detail> StockReturnDetailList { get; set; }

        public SelectList Stores { get; set; }

        public int StoreId { get; set; }

        public SelectList Projects { get; set; }

        public SelectList ProjectNames { get; set; }

        public SelectList StockTypes { get; set; }

        public int StockTypeId { get; set; }

        public WAMS_RETURN_LIST ReturnStock { get; set; }

        public List<WAMS_RETURN_LIST> ReturnStockItemList { get; set; }

        // Future implement srv when edit
        public List<V3_GetReturnedStockBySRV_Result> ReturnedStockBySrvResults { get; set; }

        public string Srv { get; set; }

        public string LstDeleteDetailItem { get; set; }

        public XUser UserLogin { get; set; }

        #region Master
        public int bReturnListID { get; set; }
        public int vStockID { get; set; }
        public int? vProjectID { get; set; }
        public decimal? bQuantity { get; set; }
        public string vCondition { get; set; }
        public string SRV { get; set; }
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
        #endregion

        #region Detail
        public int? StockId { get; set; }
        public string StockCode { get; set; }
        #endregion

        public string ProjectName { get; set; }
    }
}