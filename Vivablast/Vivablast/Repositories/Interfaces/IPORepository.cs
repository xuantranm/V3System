namespace Vivablast.Repositories.Interfaces
{
    using System;
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IPORepository : IRepository<WAMS_PURCHASE_ORDER>
    {
        POViewModelBuilder GetViewModelIndex();

        POViewModelBuilder GetPurchaseOrderViewModelBuilder(int page, int size, int store, int ptype, string po, int sup, int pro, string stock, string fd, string td);

        List<V3_PO_GetListRpt_Result> ReportData(
            int page, int size, int store, int ptype, string po, int sup, int pro, string stock, string fd, string td);

        POViewModelBuilder GetPODetailModelBuilder(int condition);

        POViewModelBuilder GetViewModelItemBuilder(int? condition);

        bool CheckCurrent(string condition);

        bool CheckDelete(int condition);

        #region Product Search
        StockViewModelBuilder GetProductSearchViewModelBuilder();

        StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int pageSize, int supId, string ids, int? storeId, int? typeId, int? cate, string stockCode);
        
        // Maybe delete
        //IEnumerable<GET_MRF_STOCK_V> GetMrfForProduct(int stockId, int storeId);
        //IEnumerable<Product_Price_V> GetPriceForProduct(int stockId, int storeId, int curency);

        List<V3_GetMRF_Result> GetMrfForProduct(int stockId, int storeId);

        List<V3_GetPrice_Result> GetPriceForProduct(int stockId, int storeId, int curency);
        #endregion
        
        string ComparePo(string condition);

        string GetAutoPoCode();

        WAMS_PURCHASE_ORDER GetPo(int condition);

        WAMS_PO_DETAILS GetPoDetailById(int condition);

        bool DeleteDetail(int condition);
    }
}
