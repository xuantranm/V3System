namespace Vivablast.Repositories.Interfaces
{
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface ISupplierRepository : IRepository<WAMS_SUPPLIER>
    {
        SupplierViewModelBuilder GetViewModelIndex();

        SupplierViewModelBuilder GetSupplierViewModelBuilder(int page, int size, int supType, int sup, string stock, int country, int market);

        SupplierViewModelBuilder GetSupplierDetailModelBuilder(int condition);

        SupplierViewModelBuilder GetViewModelItemBuilder(int? condition);

        bool CheckCurrent(string condition);

        WAMS_SUPPLIER GetSupplier(int condition);

        WAMS_PRODUCT GetProductById(int condition);

        bool CheckDelete(int id);

        bool DeleteDetail(int condition);

        #region Product Search
        StockViewModelBuilder GetStockSearchViewModelBuilder();

        StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int pageSize, string ids, int? storeId, int? typeId, int? cate, string stockCode);

        #endregion

        List<V3_Supplier_GetListRpt_Result> ReportData(
            int page, int size, int supType, int sup, string stock, int country, int market);
    }
}