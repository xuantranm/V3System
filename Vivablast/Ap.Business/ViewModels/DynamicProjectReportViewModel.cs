using System.Collections.Generic;
using Ap.Business.Domains;
using Ap.Business.Models;
using Vivablast.Models;

namespace Ap.Business.ViewModels
{
    public class DynamicProjectReportViewModel
    {
        public IList<WAMS_STOCK_MANAGEMENT_QUANTITY> DynamicProjectReports { get; set; }

        public IList<XDynamicProjectGroupItemReport> DynamicProjectGroupItemReports { get; set; }

        public int TotalRecords { get; set; }

        public int TotalPages { get; set; }

        public int CurrentPage { get; set; }

        public int PageSize { get; set; }

        #region Extend
        public IList<V3_GetProjectDDL_Result> ProjectIds { get; set; }

        public IList<V3_GetProjectDDL_Result> ProjectNames { get; set; }

        public IList<V3_GetSupplierDDL_Result> Suppliers { get; set; }

        public IList<V3_GetStockTypeDDL_Result> StockTypes { get; set; }

        public IList<V3_GetStockCategoryDDL_Result> StockCategories { get; set; }
        #endregion
    }
}
