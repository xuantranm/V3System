namespace Vivablast.Repositories.Interfaces
{
    using System;
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IAssignRepository : IRepository<WAMS_ASSIGNNING_STOCKS>
    {
        AssignViewModelBuilder GetViewModelIndex();

        AssignViewModelBuilder GetViewModelAssignList(int page, int size, int store, int pro, int stype, string stock, string siv, string fd, string td);

        List<V3_AssignStock_GetListRpt_Result> ReportData(int page, int size, int store, int pro, int stype, string stock, string siv, string fd, string td);
        
        AssignViewModelBuilder GetViewModelItemBuilder(string siv);

        #region Product Search
        StockViewModelBuilder GetProductSearchViewModelBuilder();

        StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int size, string search, string store, int type, int category);

        #endregion

        WAMS_ASSIGNNING_STOCKS GetAssignedById(int id);

        string GetSiv();

        void InsertAssign(WAMS_ASSIGNNING_STOCKS entity);
    }
}
