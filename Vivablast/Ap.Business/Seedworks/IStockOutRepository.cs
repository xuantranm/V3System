using System.Collections.Generic;
using Ap.Business.Domains;
using Ap.Business.Models;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface IStockOutRepository
    {
        IList<V3_List_StockAssign> ListCondition(int page, int size, int store, int project, int stocktype, string stockCode, string stockName, string siv, string fd, string td, string enable);

        List<V3_List_StockAssign_Detail> ListConditionDetail(int id, string enable);

        IList<V3_List_StockAssign_Detail> ListConditionDetailExcel(int page, int size, int store, int project, int stocktype, string stockCode, string stockName, string siv, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, int project, int stocktype, string stockCode, string stockName, string siv, string fd, string td, string enable);

        int CheckDelete(int id);

        int Delete(int id);

        int DeleteDetail(int id);

        V3_SIV_Max SIVLastest(string type);

        int Add(WAMS_ASSIGNNING_STOCKS model);

        int Update(WAMS_ASSIGNNING_STOCKS model);

        #region X-Media
        XStockOutParent XStockOutParent(string siv);

        IList<XStockOut> XStockOuts(string siv);

        #endregion
    }
}
