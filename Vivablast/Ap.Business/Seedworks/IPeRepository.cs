using System.Collections;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface IPeRepository
    {
        V3_PE_PDF GetByPEPDF(int id);

        IList<V3_List_PO> ListCondition(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable);

        int ListConditionCount(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable);

        List<V3_Pe_Detail> ListConditionDetail(int id, string enable);

        IList<V3_Pe_Detail> ListConditionDetailExcel(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable);

        V3_PE_Information GetPeInformation(int id);

        IList<string> ListCode(string condition);

        V3_GetPoId_Lastest PoLastest(string condition);

        int CheckDelete(int id);

        int Delete(int id);

        int DeleteDetail(int id);

        int UpdateRequisition(int mrf, int stock, decimal quantity);

        int UpdatePeTotal(int id);
    }
}
