namespace Vivablast.Repositories.Interfaces
{
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IUserRepository : IRepository<WAMS_USER>
    {
        bool CheckUser(string user, string password);

        V3_User_GetItemByCondition_Result GetUserAndRole(string userName);

        // OLD, will customize
        UserViewModelBuilder GetViewModelIndex();

        UserViewModelBuilder GetViewModelBuilder(int page, int size, string userF, string dep, int store, string fd, string td);

        List<V3_User_GetListRpt_Result> ReportData(int page, int size, string userF, string dep, int store, string fd, string td);

        UserViewModelBuilder GetViewModelItemBuilder(int? id);

        List<string> ListUserName(string search);

        bool CheckCurrent(string condition);

        bool CheckDelete(int id);

        string GetVersion(object condition);

        bool DisableItem(int id);

        WAMS_USER GetUser(int id);

        WAMS_FUNCTION_MANAGEMENT GetUserFunction(int id);
    }
}
