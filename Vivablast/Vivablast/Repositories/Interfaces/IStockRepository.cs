namespace Vivablast.Repositories.Interfaces
{
    using System;
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IStockRepository : IRepository<WAMS_STOCK>
    {
        StockViewModelBuilder GetViewModelIndex();

        StockViewModelBuilder GetViewModelBuilder(int page, int size, string search, string store, int type, int category);

        StockViewModelBuilder GetViewModelBuilderReActive(
            int page, int size, string search, string store, int type, int category);

        List<V3_Stock_GetListRpt_Result> ReportData(
            int page, int size, string search, string store, int type, int category);

        List<V3_Stock_GetListRpt_Result> ReportDataReactive(
            int page, int size, string search, string store, int type, int category);

        StockViewModelBuilder GetViewModelItemBuilder(string id);

        StockViewModelBuilder GetViewModelItemQuantityManagementBuilder(string id);

        StockViewModelBuilder GetViewModelListQtyMng(int page, int size, string stock, string fd, string td);

        List<string> ListStockCode(string search);

        List<string> ListStockName(string search);

        bool CheckCurrent(string condition);

        bool CheckCurrentCode(string condition);

        bool CheckDelete(int id);

        WAMS_STOCK GetStock(string code);

        bool ReActive(string condition);

        IEnumerable<V3_GetStockTypeDDL_Result> Types();

        IEnumerable<V3_GetStockCategoryDDL_Result> Categories(int? typeId);

        IEnumerable<V3_GetSupplierDDL_Result> Suppliers();

        IEnumerable<V3_GetStockUnitDDL_Result> Units(int? typeId);

        IEnumerable<V3_GetStockPositionDDL_Result> Positions();

        IEnumerable<V3_GetStockLabelDDL_Result> Labels(int? typeId);
    }
}
