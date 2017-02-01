using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Web.Mvc;

    using Models;

    public class StockViewModel : ViewModelBase
    {
        public IList<V3_List_Stock> StockVs { get; set; }

        public IList<V3_GetStoreDDL_Result> StoreVs { get; set; }

        public WAMS_STOCK Stock { get; set; }

        public SelectList Stores;

        public int? StoreId { get; set; }

        public SelectList Types;

        public SelectList Categories;
        
        public SelectList Units;
        
        public SelectList Positions;
        
        public SelectList Labels;

        #region Stock
        public int Id { get; set; }

        [Required]
        public string vStockID { get; set; }

        [Required]
        public string vStockName { get; set; }

        public string vRemark { get; set; }

        public int? bUnitID { get; set; }

        public string vBrand { get; set; }

        public bool? iEnable { get; set; }

        public int? bCategoryID { get; set; }

        public int? bPositionID { get; set; }

        public int? bLabelID { get; set; }

        public string vAccountCode { get; set; }

        public int? iType { get; set; }

        public string PartNo { get; set; }

        public string PartNoFor { get; set; }

        public int? PartNoMiniQty { get; set; }

        public string RalNo { get; set; }

        public string ColorName { get; set; }

        public string Position { get; set; }

        public double? bWeight { get; set; }

        public int? SubCategory { get; set; }

        public int? UserForPaint { get; set; }

        public DateTime? dCreated { get; set; }

        public DateTime? dModified { get; set; }

        public int? iCreated { get; set; }

        public int? iModified { get; set; }

        public byte[] Timestamp { get; set; }

        public string Unit { get; set; }
        public string Category { get; set; }
        public string Label { get; set; }
        public string Type { get; set; }
        public string Files { get; set; }
        public string OrginalFile { get; set; }
        public string FilePath { get; set; }

        #endregion

        public XUser UserLogin { get; set; }

        public V3_Information_Stock StockInformation { get; set; }

        public IList<V3_Stock_Quantity_Management_Result> StockQuantityManagementResults { get; set; }
    }
}
