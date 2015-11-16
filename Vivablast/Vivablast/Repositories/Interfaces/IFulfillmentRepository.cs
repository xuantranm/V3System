namespace Vivablast.Repositories.Interfaces
{
    using System;
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IFulfillmentRepository : IRepository<WAMS_FULFILLMENT_DETAIL>
    {
        FulfillmentViewModelBuilder GetViewModelIndex();

        FulfillmentViewModelBuilder LoadDataList(int page, int size, int store, int poType, string po, int sup, string srv, string stock, string fd, string td);

        List<V3_StockIn_GetListRpt_Result> ReportData(
            int page,
            int size,
            int store,
            int poType,
            string po,
            int sup,
            string srv,
            string stock,
            string fd,
            string td);
        FulfillmentViewModelBuilder GetViewModelItemBuilder(int? condition);

        bool CheckDelete(int condition);

        bool DeleteDetail(int condition);

        WAMS_FULFILLMENT_DETAIL GetFulfillmentDetailById(int condition);

        #region Product Search
        StockViewModelBuilder GetProductSearchViewModelBuilder();

        StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int pageSize, int poId, string ids, int? storeId, int? typeId, int? cate, string stockCode);

        #endregion

        V3_GetSRVLastest_Result GetSrvLastest();
    }
}
