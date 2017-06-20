using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface IPriceRepository
    {
        IList<V3_List_Price> ListCondition(int page, int size, int store, int supplier, string stockCode, string stockName, int status, string fd, string td, string enable);
        int ListConditionCount(int page, int size, int store, int supplier, string stockCode, string stockName, int status, string fd, string td, string enable);
        V3_Price_By_Id GetByKeySp(int id, string enable);
        int CheckDelete(int id);
        int Delete(int id);
    }
}
