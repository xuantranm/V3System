using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IStockTypeService
    {
        WAMS_STOCK_TYPE GetByKey(int id);

        IList<V3_List_StockType> ListCondition(int page, int size, string code, string name, string enable);

        int ListConditionCount(int page, int size, string code, string name, string enable);

        IList<string> ListCode(string condition);

        IList<string> ListName(string condition);

        bool ExistedCode(string condition);

        bool ExistedName(string condition);

        bool Insert(WAMS_STOCK_TYPE store);

        bool Update(WAMS_STOCK_TYPE store);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
