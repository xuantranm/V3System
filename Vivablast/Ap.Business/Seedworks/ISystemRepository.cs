using System.Collections;
using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface ISystemRepository
    {
        V3_StockCodeName GetStockCodeName(string code, string name);
        V3_Information_Stock GetStockInformation(int id, int store);

        V3_Information_Stock GetStockInformationByCode(string code, int store);

        V3_Information_Stock GetStockInformationByProjectAssigned(string code, int project);

        V3_Information_Stock PeGetStockInformation(string code, int store, int supplier);

        V3_Information_Stock StockInGetStockInformation(string code, int store, int pe);

        

        #region STOCK MANAGEMENT
        StockInQuantity GetStockInQuantity(int code, int pe);
        IList<V3_Stock_Quantity_Management_Result> ListTransactionStockByProject(int page, int size, int project, string type, string fd, string td);
        int CountListTransactionStockByProject(int page, int size, int project, string type, string fd, string td);
        #endregion


        #region DOCUMENT
        List<Document> GetDocumentList(int key, int type);

        Document GetDocumentById(int id);

        int DeleteDocument(int id);

        int InsertDocument(string documentUrl, string documentDescription, int keyId, int documentTypeId, string documentName, string documentTitle, string folderLocation, byte documentFile, int loginId);

        #endregion
        
        IList<LookUp> GetLookUpByType(string lookUpType);

        IList<V3_GetStoreDDL_Result> StoreList();

        IList<V3_GetCountryDDL_Result> CountryList();

        IList<V3_GetProjectDDL_Result> ProjectList();

        IList<V3_GetProjectClientDDL_Result> ClientProjectList();

        IList<V3_GetWorkerDDL_Result> SuppervisorList();

        IList<V3_GetStockTypeDDL_Result> TypeStockList();

        IList<V3_GetStockCategoryDDL_Result> CategoryStockList(int type);

        IList<V3_GetStockUnitDDL_Result> UnitStockList(int type);

        IList<V3_GetStockPositionDDL_Result> PositionStockList();

        IList<V3_GetStockLabelDDL_Result> LabelStockList(int type);

        IList<V3_List_PoType_Ddl> PoTypeList();

        IList<V3_GetSupplierDDL_Result> SupplierList();

        IList<V3_GetSupplierTypeDDL_Result> SupplierTypeList();

        IList<V3_GetCurrencyDDL> CurrencyList();

        IList<V3_GetPaymentDDL> PaymentList();

        IList<V3_GetPriceDDL> PriceList(int stock, int store, int currency);

        IList<V3_GetRequisitionDDL> RequisitionByStockList(int stock, int store);

        IList<V3_DDL_PE> Ddlpe(int supplier, int store, string status);

        V3_Ddl SuppliersFromPe(int pe);

        IList<string> ListPayment(string condition);
        string GetPayment(int supplier);
    }
}
