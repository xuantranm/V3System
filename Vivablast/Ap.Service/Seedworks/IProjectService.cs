using System.Collections.Generic;
using Ap.Business.Domains;
using Ap.Business.Dto;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IProjectService
    {
        WAMS_PROJECT GetByKey(int id);

        WAMS_PROJECT GetByKeySp(int id);

        ProjectCustom CustomEntity(int id);

        IList<V3_List_Project> ListCondition(int page, int size, string projectCode, string projectName, int country, int status, int client, string fd, string td, string enable);

        int ListConditionCount(int page, int size, string projectCode, string projectName, int country, int status, int client, string fd, string td, string enable);

        IList<string> ListCode(string condition);

        IList<string> ListName(string condition);

        bool ExistedCode(string condition);

        bool ExistedName(string condition);

        bool Insert(WAMS_PROJECT project);

        bool Update(WAMS_PROJECT project);

        int CheckDelete(int id);

        int Delete(int id);

        #region Client
        int InsertClient(Project_Client model);

        int ExistedClient(string condition);

        IList<string> ListNameClient(string condition);
        #endregion
        
    }
}
