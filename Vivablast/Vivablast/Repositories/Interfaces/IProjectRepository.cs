namespace Vivablast.Repositories.Interfaces
{
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IProjectRepository : IRepository<WAMS_PROJECT>
    {
        ProjectViewModelBuilder GetViewModelIndex();

        ProjectViewModelBuilder GetViewModelBuilder(int page, int size, string projectId, int country, string status, int client, string fd, string td);

        List<V3_Project_GetListRpt_Result> ReportData(
            int page, int size, string projectId, int country, string status, int client, string fd, string td);

        ProjectViewModelBuilder GetViewModelItemBuilder(int? id);

        List<string> listProjectId(string search);

        List<string> ListProjectName(string search);

        bool CheckCurrent(string condition);

        bool CheckCurrentCode(string condition);

        bool CheckDelete(int id);

        WAMS_PROJECT GetProject(int id);
    }
}
