using System.Collections;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface IRequisitionRepository
    {
        IList<V3_List_Requisition> ListCondition(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable);

        IList<V3_RequisitionDetail_Result> ListConditionDetail(int id, string enable);

        IList<V3_RequisitionDetail_Result> ListConditionDetailExcel(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable);

        IList<string> ListCode(string condition);

        int CheckDelete(int id);

        int Delete(int id);

        int DeleteDetail(int id);

        string GetCodeLastest();

        V3_Requisition_Master GetRequisitionMasterByKey(int id);
    }
}
