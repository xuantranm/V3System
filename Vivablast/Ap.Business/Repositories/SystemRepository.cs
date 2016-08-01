using System.Collections;
using System.Collections.Generic;
using Ap.Business.Domains;
using Ap.Business.Models;
using Ap.Business.Seedworks;
using Ap.Business.ViewModels;
using Ap.Data.Repositories;
using Ap.Data.Seedworks;
using Dapper;
using System.Data;
using System.Linq;
using Vivablast.Models;

namespace Ap.Business.Repositories
{
    public class SystemRepository : BaseRepository, ISystemRepository
    {
        public SystemRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        public V3_StockCodeName GetStockCodeName(string code, string name)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_StockCodeName>("dbo.V3_StockCodeName", new
            {
                code,
                name
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }
        
        public V3_Information_Stock GetStockInformation(int id, int store)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Information_Stock>("dbo.V3_Information_Stock", new
            {
                id,
                store
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public V3_Information_Stock GetStockInformationByCode(string code, int store)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Information_Stock>("dbo.V3_Information_Stock_Requisition", new
            {
                code,
                store
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public V3_Information_Stock GetStockInformationByProjectAssigned(string code, int project)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Information_Stock>("dbo.V3_Information_Stock_Return", new
            {
                code,
                project
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public V3_Information_Stock PeGetStockInformation(string code, int store, int supplier)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Information_Stock>("dbo.V3_Information_Stock_Pe", new
            {
                code,
                store,
                supplier
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public V3_Information_Stock StockInGetStockInformation(string code, int store, int pe)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Information_Stock>("dbo.V3_Information_Stock_StockIn", new
            {
                code,
                store,
                pe
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public StockInQuantity GetStockInQuantity(int code, int pe)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<StockInQuantity>("dbo.V3_StockInQuantity", new
            {
                code,
                pe
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        #region STOCK MANAGEMENT

        public IList<V3_Stock_Quantity_Management_Result> ListTransactionStockByProject(int page, int size, int project, string type,
            string fd, string td)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Stock_Quantity_Management_Result>("dbo.TransactionStockByProject", new
            {
                page,
                size,
                project,
                type,
                fd,
                td
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();

            return result.Any() ? result : new List<V3_Stock_Quantity_Management_Result>();
        }

        public int CountListTransactionStockByProject(int page, int size, int project, string type,
            string fd, string td)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.CountTransactionStockByProject", new
            {
                page,
                size,
                project,
                type,
                fd,
                td
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();

            return result;
        }
        #endregion

        #region DOCUMENT
        public List<Document> GetDocumentList(int key, int type)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<Document>("dbo.V3_Document", new
            {
                key,
                type
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            if (result.Any())
            {
                return result;
            }

            return new List<Document>();
        }

        public Document GetDocumentById(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<Document>("dbo.V3_DocumentById", new
            {
                id
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public int DeleteDocument(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_Delete_Document", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        public int InsertDocument(string documentUrl, string documentDescription, int keyId, int documentTypeId, string documentName, string documentTitle, string folderLocation, byte documentFile, int loginId)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_Insert_Document", new
            {
                documentUrl,
                documentDescription,
                keyId,
                documentTypeId,
                documentName,
                documentTitle,
                folderLocation,
                documentFile,
                loginId
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        #endregion

        public IList<LookUp> GetLookUpByType(string lookUpType)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<LookUp>("dbo.GetLookUp", new
            {
                lookUpType
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<LookUp>();
        }

        public IList<V3_GetStoreDDL_Result> StoreList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetStoreDDL_Result>("dbo.V3_GetStoreDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetStoreDDL_Result>();
        }
        
        public IList<V3_GetCountryDDL_Result> CountryList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetCountryDDL_Result>("dbo.V3_GetCountryDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetCountryDDL_Result>();
        }

        public IList<V3_GetProjectDDL_Result> ProjectList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetProjectDDL_Result>("dbo.V3_GetProjectDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetProjectDDL_Result>();
        }

        public IList<V3_GetProjectClientDDL_Result> ClientProjectList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetProjectClientDDL_Result>("dbo.V3_GetProjectClientDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetProjectClientDDL_Result>();
        }

        public IList<V3_GetWorkerDDL_Result> SuppervisorList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetWorkerDDL_Result>("dbo.V3_GetWorkerDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetWorkerDDL_Result>();
        }

        public IList<V3_GetStockTypeDDL_Result> TypeStockList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetStockTypeDDL_Result>("dbo.V3_GetStockTypeDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetStockTypeDDL_Result>();
        }

        public IList<V3_GetStockCategoryDDL_Result> CategoryStockList(int type)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetStockCategoryDDL_Result>("dbo.V3_GetStockCategoryDDL", new
            {
                type
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetStockCategoryDDL_Result>();
        }

        public IList<V3_GetStockUnitDDL_Result> UnitStockList(int type)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetStockUnitDDL_Result>("dbo.V3_GetStockUnitDDL", new
            {
                type
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetStockUnitDDL_Result>();
        }

        public IList<V3_GetStockPositionDDL_Result> PositionStockList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetStockPositionDDL_Result>("dbo.V3_GetStockPositionDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetStockPositionDDL_Result>();
        }

        public IList<V3_GetStockLabelDDL_Result> LabelStockList(int type)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetStockLabelDDL_Result>("dbo.V3_GetStockLabelDDL", new
            {
                type
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetStockLabelDDL_Result>();
        }

        public IList<V3_List_PoType_Ddl> PoTypeList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_PoType_Ddl>("dbo.PoTypeList", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_PoType_Ddl>();
        }

        public IList<V3_GetSupplierDDL_Result> SupplierList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetSupplierDDL_Result>("dbo.V3_GetSupplierDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetSupplierDDL_Result>();
        }

        public IList<V3_GetSupplierTypeDDL_Result> SupplierTypeList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetSupplierTypeDDL_Result>("dbo.V3_GetSupplierTypeDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetSupplierTypeDDL_Result>();
        }

        public IList<V3_GetCurrencyDDL> CurrencyList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetCurrencyDDL>("dbo.V3_GetCurrencyDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetCurrencyDDL>();
        }

        public IList<V3_GetPaymentDDL> PaymentList()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetPaymentDDL>("dbo.V3_GetPaymentDDL", new
            {
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetPaymentDDL>();
        }

        public IList<V3_GetPriceDDL> PriceList(int stock, int store, int currency)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetPriceDDL>("dbo.V3_GetPriceDDL", new
            {
                stock,
                store,
                currency
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetPriceDDL>();
        }

        public IList<V3_GetRequisitionDDL> RequisitionByStockList(int stock, int store)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_GetRequisitionDDL>("dbo.V3_GetRequisitionDDL", new
            {
                stock,
                store
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_GetRequisitionDDL>();
        }

        public string PaymentTypeBySupplier(int supplier)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<string>("dbo.V3_PaymentTypeBySupplier", new
            {
                supplier
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public XPeCodeViewModel Ddlpe(int page, int size, int supplier, int store, string status)
        {
            var model = new XPeCodeViewModel();
            var paramss = new DynamicParameters();
            paramss.Add("page", page);
            paramss.Add("size", size);
            paramss.Add("supplier", supplier);
            paramss.Add("store", store);
            paramss.Add("status", status);
            paramss.Add("out", dbType: DbType.Int32, direction: ParameterDirection.Output);

            using (var sql = GetSqlConnection())
            {
                var data = sql.Query<V3_DDL_PE>("V3_GetPEDDL", paramss, commandType: CommandType.StoredProcedure);
                sql.Close();
                model.PEs = data.ToList();
                var total = paramss.Get<int>("out");
                model.TotalRecords = total;
            }
            return model;
        }

        public V3_Ddl SuppliersFromPe(int pe)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Ddl>("dbo.V3_GetSupplierFromPe", new
            {
                pe
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        #region INSERT COMMON

        #endregion

        #region X-media

        public DynamicPeReportViewModel GetDynamicPeReport(int page, int size, int poType, string po, int stockType,
            int category, string stockCode, string stockName, string fd, string td)
        {
            var model = new DynamicPeReportViewModel();
            var paramss = new DynamicParameters();
            paramss.Add("page", page);
            paramss.Add("size", size);
            paramss.Add("poType", poType);
            paramss.Add("po", po);
            paramss.Add("stockType", stockType);
            paramss.Add("category", category);
            paramss.Add("stockCode", stockCode);
            paramss.Add("stockName", stockName);
            paramss.Add("fd", fd);
            paramss.Add("td", td);
            paramss.Add("out", dbType: DbType.Int32, direction: ParameterDirection.Output);

            using (var sql = GetSqlConnection())
            {
                var data = sql.Query<XDynamicPeReport>("XGetDynamicPeReport", paramss, commandType: CommandType.StoredProcedure);
                sql.Close();
                model.DynamicReports = data.ToList();
                var total = paramss.Get<int>("out");
                model.TotalRecords = total;
            }
            return model;
        }


        public DynamicProjectReportViewModel GetDynamicProjectReport(int page, int size, int projectId, int stockTypeId,
            int categoryId, string stockCode, string stockName, string action, int supplierId, string fd, string td)
        {
            var model = new DynamicProjectReportViewModel();
            var paramss = new DynamicParameters();
            paramss.Add("page", page);
            paramss.Add("size", size);
            paramss.Add("projectId", projectId);
            paramss.Add("stockTypeId", stockTypeId);
            paramss.Add("categoryId", categoryId);
            paramss.Add("stockCode", stockCode);
            paramss.Add("stockName", stockName);
            paramss.Add("action", action);
            paramss.Add("supplierId", supplierId);
            paramss.Add("fd", fd);
            paramss.Add("td", td);
            paramss.Add("out", dbType: DbType.Int32, direction: ParameterDirection.Output);

            using (var sql = GetSqlConnection())
            {
                var data = sql.Query<XDynamicProjectReport>("XGetDynamicProjectReport", paramss, commandType: CommandType.StoredProcedure);
                sql.Close();
                model.DynamicProjectReports = data.ToList();
                var total = paramss.Get<int>("out");
                model.TotalRecords = total;
            }
            return model;
        }
        #endregion
    }
}
