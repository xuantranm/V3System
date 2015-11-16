using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IServiceService
    {
        WAMS_ITEMS_SERVICE GetByKey(int id);

        IList<V3_List_Service> ListCondition(int page, int size, string code, string name, int store, int category, string enable);

        int ListConditionCount(int page, int size, string code, string name, int store, int category, string enable);

        IList<string> ListCode(string condition);

        IList<string> ListName(string condition);

        bool ExistedCode(string condition);

        bool ExistedName(string condition);

        bool Insert(WAMS_ITEMS_SERVICE store);

        bool Update(WAMS_ITEMS_SERVICE store);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
