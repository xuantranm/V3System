namespace Vivablast.Repositories.Interfaces
{
    using System;
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IServiceRepository : IRepository<WAMS_ITEMS_SERVICE>
    {
        ServiceViewModelBuilder GetViewModelIndex();

        ServiceViewModelBuilder GetViewModelBuilder(int page, int size, string search, int store, int category);

        List<V3_Service_GetListRpt_Result> ReportData(
            int page, int size, string search, int store, int category);

        ServiceViewModelBuilder GetViewModelItemBuilder(string id);

        List<string> ListServiceCode(string search);

        List<string> ListServiceName(string search);

        bool CheckCurrent(string condition);

        bool CheckCurrentCode(string condition);

        bool CheckDelete(int id);

        WAMS_ITEMS_SERVICE GetItemService(string code);
    }
}
