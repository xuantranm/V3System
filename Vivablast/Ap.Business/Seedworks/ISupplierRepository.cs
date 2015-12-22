using System.Collections;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface ISupplierRepository
    {
        IList<V3_List_Supplier> ListCondition(int page, int size, int supplierType, int supplierId, string supplierName, string stockCode, string stockName, int country, int market, string enable);

        int ListConditionCount(int page, int size, int supplierType, int supplierId, string supplierName, string stockCode, string stockName, int country, int market, string enable);

        IList<V3_List_Supplier_Product> ListConditionDetail(int id, string enable);

        IList<V3_List_Supplier_Product> ListConditionDetailExcel(int page, int size, int supplierType, int supplierId, string supplierName, string stockCode, string stockName, int country, int market, string enable);

        IList<string> ListName(string condition);

        int CheckDelete(int id);

        int Delete(int id);

        int DeleteDetail(int id);
    }
}
