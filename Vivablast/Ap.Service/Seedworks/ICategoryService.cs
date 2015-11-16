using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface ICategoryService
    {
        WAMS_CATEGORY GetByKey(int id);

        IList<V3_List_Category> ListCondition(int page, int size, string code, string name, int type, string enable);

        int ListConditionCount(int page, int size, string code, string name, int type, string enable);

        IList<string> ListCode(string condition);

        IList<string> ListName(string condition);

        bool ExistedCode(string condition);

        bool ExistedName(string condition);

        bool Insert(WAMS_CATEGORY store);

        bool Update(WAMS_CATEGORY store);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
