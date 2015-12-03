using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IPOService
    {
        WAMS_PURCHASE_ORDER GetByKey(int id);

        V3_PE_PDF GetByPEPDF(int id);

        WAMS_PO_DETAILS GetByKeyDetail(int id);

        IList<V3_List_PO> ListCondition(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable);

        List<V3_Pe_Detail> ListConditionDetail(int id, string enable);

        IList<V3_Pe_Detail> ListConditionDetailExcel(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable);

        V3_PE_Information GetPeInformation(int id);

        IList<string> ListCode(string condition);

        IList<string> ListPayment(string condition);

        bool ExistedCode(string condition);

        string GetAutoPoCode();

        bool Insert(WAMS_PURCHASE_ORDER entity, List<V3_Pe_Detail_Data> entityDetails);

        bool Update(WAMS_PURCHASE_ORDER entity, List<V3_Pe_Detail_Data> entityDetails, string lstDeleteDetailItem);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
