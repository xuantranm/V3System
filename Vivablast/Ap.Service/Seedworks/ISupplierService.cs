using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface ISupplierService
    {
        WAMS_SUPPLIER GetByKey(int id);

        WAMS_PRODUCT GetByKeyDetail(int id);

        IList<V3_List_Supplier> ListCondition(int page, int size, int supplierType, int supplierId, string supplierName, string stockCode, string stockName, int country, int market, string enable);

        int ListConditionCount(int page, int size, int supplierType, int supplierId, string supplierName, string stockCode, string stockName, int country, int market, string enable);

        IList<V3_List_Supplier_Product> ListConditionDetail(int id, string enable);

        IList<V3_List_Supplier_Product> ListConditionDetailExcel(int page, int size, int supplierType, int supplierId, string supplierName, string stockCode, string stockName, int country, int market, string enable);

        IList<string> ListName(string condition);

        bool ExistedName(string condition);

        bool Insert(WAMS_SUPPLIER entity, List<WAMS_PRODUCT> entityDetails);

        bool Update(WAMS_SUPPLIER entity, List<WAMS_PRODUCT> entityDetails, string LstDeleteDetailItem);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
