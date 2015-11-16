using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IStoreService
    {
        Store GetByKey(int id);

        IList<V3_List_Store> ListCondition(int page, int size, string storeCode, string storeName, int country, string enable);

        int ListConditionCount(int page, int size, string storeCode, string storeName, int country, string enable);

        IList<string> ListCode(string condition);

        IList<string> ListName(string condition);

        bool ExistedCode(string condition);

        bool ExistedName(string condition);

        bool Insert(Store store);

        bool Update(Store store);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
