namespace Vivablast.Repositories.Interfaces
{
    using System;
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IReturnRepository : IRepository<WAMS_RETURN_LIST>
    {
        ReturnViewModelBuilder GetViewModelIndex();

        ReturnViewModelBuilder GetViewModelAssignList(int page, int size, int store, int pro, int stype, string stock, string srv, string acc, string fd, string td);

        ReturnViewModelBuilder GetViewModelItemBuilder(string srv);

        #region Product Search
        StockViewModelBuilder GetProductSearchViewModelBuilder();

        StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int size, string search, string store, int type, int category);

        #endregion

        WAMS_RETURN_LIST GetReturnedById(int id);

        string GetSrv();

        void InsertReturn(WAMS_RETURN_LIST entity);

        List<V3_ReturnStock_GetListRpt_Result> ReportData(int page, int size, int store, int pro, int stype, string stock, string srv, string acc, string fd, string td);
    }
}
