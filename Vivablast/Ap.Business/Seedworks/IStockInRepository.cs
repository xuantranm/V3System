using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface IStockInRepository
    {
        IList<V3_List_StockIn> ListCondition(int page, int size, int store, int poType, string status, string po, int supplier, string srv, string stockCode, string stockName, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, int poType, string status, string po, int supplier, string srv, string stockCode, string stockName, string fd, string td, string enable);

        List<V3_List_StockIn_Detail> ListConditionDetail(int id, string enable);

        IList<V3_List_StockIn_Detail> ListConditionDetailExcel(int page, int size, int store, int poType, string status, string po,
            int supplier, string srv,
            string stockCode, string stockName, string fd, string td, string enable);

        int CheckDelete(int id);

        int Delete(int id);

        int DeleteDetail(int id);

        V3_SRV_Max SRVLastest(string type);

        int Add(WAMS_FULFILLMENT_DETAIL model);

        int Update(WAMS_FULFILLMENT_DETAIL model);
    }
}
