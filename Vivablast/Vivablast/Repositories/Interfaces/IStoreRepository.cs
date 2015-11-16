namespace Vivablast.Repositories.Interfaces
{
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IStoreRepository : IRepository<Store>
    {
        StoreViewModelBuilder GetViewModelIndex();

        StoreViewModelBuilder GetViewModelBuilder(int page, int size, string search, int country);

        List<V3_Store_GetListRpt_Result> ReportData(int page, int size, string search, int country);

        StoreViewModelBuilder GetViewModelItemBuilder(int id);

        List<string> listData(string search);

        bool CheckCurrent(string condition);

        bool CheckDelete(int id);

        Store GetStore(int id);
    }
}
