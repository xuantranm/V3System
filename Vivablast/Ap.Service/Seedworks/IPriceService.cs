using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IPriceService
    {
        Product_Price GetByKey(int id);

        IList<V3_List_Price> ListCondition(int page, int size, int store, int supplier, string stockCode, string stockName, int status, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, int supplier, string stockCode, string stockName, int status, string fd, string td, string enable);

        V3_Price_By_Id GetByKeySp(int id, string enable);

        bool Insert(Product_Price price);

        bool Update(Product_Price price);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
