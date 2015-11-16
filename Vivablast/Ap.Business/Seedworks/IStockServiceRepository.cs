using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface IStockServiceRepository
    {
        IList<V3_List_Service> ListCondition(int page, int size, string code, string name, int store, int category, string enable);

        int ListConditionCount(int page, int size, string code, string name, int store, int category, string enable);

        IList<string> ListCode(string condition);

        IList<string> ListName(string condition);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
