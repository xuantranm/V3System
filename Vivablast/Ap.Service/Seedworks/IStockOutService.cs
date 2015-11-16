using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IStockOutService
    {
        WAMS_ASSIGNNING_STOCKS GetByKey(int id);

        IList<V3_List_StockAssign> ListCondition(int page, int size, int store, int project, int stocktype, string stockCode, string stockName, string siv, string fd, string td, string enable);

        List<V3_List_StockAssign_Detail> ListConditionDetail(int id, string enable);

        IList<V3_List_StockAssign_Detail> ListConditionDetailExcel(int page, int size, int store, int project, int stocktype, string stockCode, string stockName, string siv, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, int project, int stocktype, string stockCode, string stockName, string siv, string fd, string td, string enable);

        bool Insert(List<WAMS_ASSIGNNING_STOCKS> entityDetails, int login);

        bool ExistedCode(string condition);

        int CheckDelete(int id);

        int DeleteDetail(int id);

        int Delete(int id);

        string SIVLastest(string type);
    }
}
