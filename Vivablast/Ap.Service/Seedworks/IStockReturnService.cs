using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IStockReturnService
    {
        WAMS_RETURN_LIST GetByKey(int id);

        IList<V3_List_StockReturn> ListCondition(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable);

        IList<V3_List_StockReturn_Detail> ListConditionDetail(string id, string enable);

        IList<V3_List_StockReturn_Detail> ListConditionDetailExcel(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable);

        bool Insert(List<WAMS_RETURN_LIST> entityDetails, int login);

        bool ExistedCode(string condition);

        int CheckDelete(int id);

        int Delete(int id);

        int DeleteDetail(int id);

        string SRVLastest(string type);
    }
}
