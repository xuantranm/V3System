using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IRequisitionService
    {
        WAMS_REQUISITION_MASTER GetByKey(int id);

        WAMS_REQUISITION_DETAILS GetByKeyDetail(int id);

        IList<V3_List_Requisition> ListCondition(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable);

        IList<V3_RequisitionDetail_Result> ListConditionDetail(int id, string enable);

        IList<V3_RequisitionDetail_Result> ListConditionDetailExcel(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable);

        IList<string> ListCode(string condition);

        bool ExistedCode(string condition);

        bool Insert(WAMS_REQUISITION_MASTER entity, List<WAMS_REQUISITION_DETAILS> entityDetails);

        bool Update(WAMS_REQUISITION_MASTER entity, List<WAMS_REQUISITION_DETAILS> entityDetails, string LstDeleteDetailItem);

        int CheckDelete(int id);

        int Delete(int id);

        string GetCodeLastest();

        V3_Requisition_Master GetRequisitionMasterByKey(int id);
    }
}
