using System.Collections;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface IStoreRepository
    {
        IList<V3_List_Store> ListCondition(int page, int size, string storeCode, string storeName, int country, string enable);

        int ListConditionCount(int page, int size, string storeCode, string storeName, int country, string enable);

        IList<string> ListCode(string condition);

        IList<string> ListName(string condition);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
