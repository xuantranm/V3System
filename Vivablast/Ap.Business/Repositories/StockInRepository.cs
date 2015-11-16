using System.Collections.Generic;
using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Data.Repositories;
using Ap.Data.Seedworks;
using Dapper;
using System.Data;
using System.Linq;
using Vivablast.Models;

namespace Ap.Business.Repositories
{
    public class StockInRepository : BaseRepository, IStockInRepository
    {
        public StockInRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        public IList<V3_List_StockIn> ListCondition(int page, int size, int store, int poType, string status, string po, int supplier,
            string srv, string stockCode, string stockName, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_StockIn>("dbo.V3_List_StockIn", new
            {
                page,
                size,
                store,
                poType,
                status,
                po,
                supplier,
                srv,
                stockCode,
                stockName,
                fd,
                td,
                enable
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_StockIn>();
        }

        public int ListConditionCount(int page, int size, int store, int poType, string status, string po, int supplier, string srv,
            string stockCode, string stockName, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_StockIn_Count", new
            {
                page,
                size,
                store,
                poType,
                status,
                po,
                supplier,
                srv,
                stockCode,
                stockName,
                fd,
                td,
                enable
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public List<V3_List_StockIn_Detail> ListConditionDetail(int id, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_StockIn_Detail>("dbo.V3_StockInDetail", new
            {
                id,
                enable
            },
            commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_StockIn_Detail>();
        }

        public IList<V3_List_StockIn_Detail> ListConditionDetailExcel(int page, int size, int store, int poType, string status,
            string po,
            int supplier, string srv,
            string stockCode, string stockName, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_StockIn_Detail>("dbo.V3_List_StockIn_Detail", new
            {
                page,
                size,
                store,
                poType,
                status,
                po,
                supplier,
                srv,
                stockCode,
                stockName,
                fd,
                td,
                enable
            },
            commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_StockIn_Detail>(); 
        }

        public int CheckDelete(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_CheckDelete_StockIn", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        public int Delete(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_Delete_StockIn", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        public int DeleteDetail(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_Delete_StockIn_Detail", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        public V3_SRV_Max SRVLastest(string type)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_SRV_Max>("dbo.V3_GetSRVLastest", new
            {
                type
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public int Add(WAMS_FULFILLMENT_DETAIL model)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_InsertStockIn", new
            {
                model.vPOID,
                model.vStockID,
                model.dQuantity,
                model.dReceivedQuantity,
                model.dPendingQuantity,
                model.dDateDelivery,
                model.iShipID,
                model.tDescription,
                model.vMRF,
                model.dCurrenQuantity,
                model.dInvoiceDate,
                model.vInvoiceNo,
                model.dImportTax,
                model.SRV,
                model.iStore,
                model.iCreated,
                model.FlagFile
,
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        public int Update(WAMS_FULFILLMENT_DETAIL model)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_UpdateStockIn", new
            {
                model.ID,
                model.vPOID,
                model.vStockID,
                model.dQuantity,
                model.dReceivedQuantity,
                model.dPendingQuantity,
                model.dDateDelivery,
                model.iShipID,
                model.tDescription,
                model.vMRF,
                model.dCurrenQuantity,
                model.dInvoiceDate,
                model.vInvoiceNo,
                model.dImportTax,
                model.SRV,
                model.iStore,
                model.iCreated,
                model.FlagFile
,
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }
    }
}
