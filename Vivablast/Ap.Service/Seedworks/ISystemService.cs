using System.Collections.Generic;
using Ap.Business.Domains;
using Ap.Business.ViewModels;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface ISystemService
    {
        bool CheckUser(string user, string password);

        XUser GetUserAndRole(int id, string user);

        V3_StockCodeName GetStockCodeName(string code, string name);

        V3_Information_Stock GetStockInformation(int id, int store);

        V3_Information_Stock GetStockInformationByCode(string code, int store);

        V3_Information_Stock GetStockInformationByProjectAssigned(string code, int project);

        V3_Information_Stock PeGetStockInformation(string code, int store, int supplier);

        V3_Information_Stock StockInGetStockInformation(string code, int store, int pe);

        StockInQuantity GetStockInQuantity(int code, int pe);

        IList<LookUp> GetLookUp(string type);

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

        string PaymentTypeBySupplier(int supplier);

        XPeCodeViewModel Ddlpe(int page, int size, int supplier, int store, string status);

        V3_Ddl SuppliersFromPe(int pe);

        bool InsertLookUp(LookUp entity);

        #region DOCUMENT
        List<Document> GetDocumentList(int key, int type);

        Document AddDocument(string documentUrl, string documentDescription, int keyId, int documentTypeId, string documentName, string documentTitle, string folderLocation, byte documentFile, int loginId);

        int InsertDocument(string documentUrl, string documentDescription, int keyId, int documentTypeId, string documentName, string documentTitle, string folderLocation, byte documentFile, int loginId);

        int DeleteDocument(int id);

        bool CheckValidExtension(string fileName);

        bool CheckValidPictureExtension(string fileName);

        string GetDocumentUrl(string documentLocation, string fileName, string fileExtend);

        Document GetDocumentById(int documentId);

        string GetContentType(string fileExtension);

        string GetDocumentSize(string folderLocation, string documentName);

        #endregion

        #region STOCK MANAGEMENT
        IList<V3_Stock_Quantity_Management_Result> ListTransactionStockByProject(int page, int size, int project, string type, string fd, string td);
        int CountListTransactionStockByProject(int page, int size, int project, string type, string fd, string td);
        #endregion

        #region X-media

        DynamicPeReportViewModel GetDynamicPeReport(int page, int size, int poType, string po, int stockType, int category, string stockCode, string stockName, string fd, string td);

        DynamicProjectReportViewModel GetDynamicProjectReport(int page, int size, int projectId, int stockTypeId, int categoryId, string stockCode, string stockName, string action, int supplierId, string fd, string td);

        DynamicProjectReportViewModel GetDynamicProjectGroupItemReport(int page, int size, int projectId, int stockTypeId, int categoryId, string stockCode, string stockName, string action, int supplierId, string fd, string td);

        #endregion
    }
}
