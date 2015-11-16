using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IStockInService
    {
        WAMS_FULFILLMENT_DETAIL GetByKey(int id);

        IList<V3_List_StockIn> ListStockInByPo(int id);

        IList<V3_List_StockIn> ListCondition(int page, int size, int store, int poType, string status, string po, int supplier, string srv, string stockCode, string stockName, string fd, string td, string enable);

        List<V3_List_StockIn_Detail> ListConditionDetail(int id, string enable);

        IList<V3_List_StockIn_Detail> ListConditionDetailExcel(int page, int size, int store, int poType, string status, string po,
            int supplier, string srv,
            string stockCode, string stockName, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, int poType, string status, string po, int supplier, string srv, string stockCode, string stockName, string fd, string td, string enable);

        int Insert(List<WAMS_FULFILLMENT_DETAIL> entityDetails, int login);

        bool ExistedCode(string condition);

        int CheckDelete(int id);

        int Delete(int id);

        int DeleteDetail(int id);

        string SRVLastest(string type);
    }
}
