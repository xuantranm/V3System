namespace Vivablast.Repositories.Interfaces
{
    using System;
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IRequisitionRepository : IRepository<WAMS_REQUISITION_MASTER>
    {
        RequisitionViewModelBuilder GetViewModelIndex();

        RequisitionViewModelBuilder GetRequisitionViewModelBuilder(int page, int size, int store, string mrf, string stock, string status, string fd, string td);

        RequisitionViewModelBuilder GetRequisitionDetailModelBuilder(string condition);

        List<V3_Requisition_GetListRpt_Result> ReportData(int page, int size, int store, string mrf, string stock, string status, string fd, string td);

        RequisitionViewModelBuilder GetViewModelItemBuilder(string condition);

        WAMS_REQUISITION_MASTER GetRequisitionMaster(int condition);

        string CompareMRF(string condition);

        bool CheckDelete(int condition);

        WAMS_REQUISITION_DETAILS GetRequisitionDetailById(int condition);

        bool DeleteDetail(int condition);

        #region Product Search
        StockViewModelBuilder GetProductSearchViewModelBuilder();

        StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int pageSize, int? storeId, int? typeId, int? cate, string stockCode);

        #endregion
    }
}
