namespace Vivablast.Repositories.Interfaces
{
    using System;
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IPriceRepository : IRepository<Product_Price>
    {
        PriceViewModelBuilder GetViewModelIndex();

        PriceViewModelBuilder GetPriceViewModelBuilder(int page, int size, int store, int sup, string stock, string fd, string td);

        List<V3_Price_GetListRpt_Result> ReportData(
            int page, int size, int store, int sup, string stock, string fd, string td);

        PriceViewModelBuilder GetViewModelItemBuilder(int? condition);

        #region Product Search
        StockViewModelBuilder GetProductSearchViewModelBuilder();

        StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int pageSize, int? storeId, int? typeId, int? cate, string stockCode);

        #endregion
    }
}
