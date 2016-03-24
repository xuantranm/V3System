using System.Collections.Generic;
using Ap.Business.Domains;
using Ap.Business.Models;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface IStockReturnRepository
    {
        IList<V3_List_StockReturn> ListCondition(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable);

        IList<V3_List_StockReturn_Detail> ListConditionDetail(string id, string enable);

        IList<V3_List_StockReturn_Detail> ListConditionDetailExcel(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable);

        int CheckDelete(int id);

        int Delete(int id);

        int DeleteDetail(int id);

        V3_SRV_Max SRVLastest(string type);

        int Add(WAMS_RETURN_LIST model);

        int Update(WAMS_RETURN_LIST model);

        #region X-Media
        XStockReturnParent XStockReturnParent(string siv);

        IList<XStockReturn> XStockReturns(string siv);

        #endregion
    }
}
