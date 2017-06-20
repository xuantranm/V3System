using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using Ap.Business.Domains;
using Ap.Business.Dto;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface IProjectRepository
    {
        WAMS_PROJECT GetByKeySp(int id);

        ProjectCustom CustomEntity(int id);

        IList<V3_List_Project> ListCondition(int page, int size, string projectCode, string projectName, int country, int status, int client, string fd, string td, string enable);

        int ListConditionCount(int page, int size, string projectCode, string projectName, int country, int status, int client, string fd, string td, string enable);

        IList<string> ListCode(string condition);

        IList<string> ListName(string condition);

        int CheckDelete(int id);

        int Delete(int id);

        #region Client
        int InsertClient(Project_Client model);

        int ExistedClient(string condition);

        IList<string> ListNameClient(string condition);
        #endregion
    }
}
