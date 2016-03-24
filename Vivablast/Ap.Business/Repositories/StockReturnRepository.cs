using System.Collections;
using System.Collections.Generic;
using Ap.Business.Domains;
using Ap.Business.Models;
using Ap.Business.Seedworks;
using Ap.Data.Repositories;
using Ap.Data.Seedworks;
using Dapper;
using System.Data;
using System.Linq;
using Vivablast.Models;

namespace Ap.Business.Repositories
{
    public class StockReturnRepository : BaseRepository, IStockReturnRepository
    {
        public StockReturnRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        public IList<V3_List_StockReturn> ListCondition(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_StockReturn>("dbo.V3_List_StockReturn", new
            {
                page,
                size,
                store,
                project,
                stockType,
                stockCode,
                stockName,
                srv,
                fd,
                td,
                enable
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_StockReturn>();
        }

        public int ListConditionCount(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_StockReturn_Count", new
            {
                page,
                size,
                store,
                project,
                stockType,
                stockCode,
                stockName,
                srv,
                fd,
                td,
                enable
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public IList<V3_List_StockReturn_Detail> ListConditionDetail(string id, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_StockReturn_Detail>("dbo.V3_StockReturnDetail", new
            {
                id,
                enable
            },
            commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_StockReturn_Detail>();
        }

        public IList<V3_List_StockReturn_Detail> ListConditionDetailExcel(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_StockReturn_Detail>("dbo.V3_List_StockReturn_Detail", new
            {
                page,
                size,
                store,
                project,
                stockType,
                stockCode,
                stockName,
                srv,
                fd,
                td,
                enable
            },
            commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_StockReturn_Detail>();
        }

        public int CheckDelete(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_CheckDelete_Requisition", new
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
            var result = sql.Query<int>("V3_Delete_Requisition", new
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
            var result = sql.Query<int>("V3_Delete_StockReturn_Detail", new
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

        public int Add(WAMS_RETURN_LIST model)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_InsertStockReturn", new
            {
                model.vStockID,
                model.vProjectID,
                model.bQuantity,
                model.vCondition,
                model.SRV,
                model.FromStore,
                model.ToStore,
                model.iCreated,
                model.FlagFile
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        public int Update(WAMS_RETURN_LIST model)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_UpdateStockReturn", new
            {
                model.bReturnListID,
                model.vStockID,
                model.vProjectID,
                model.bQuantity,
                model.vCondition,
                model.SRV,
                model.FromStore,
                model.ToStore,
                model.iCreated,
                model.FlagFile
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }


        #region X-media
        public XStockReturnParent XStockReturnParent(string siv)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<XStockReturnParent>("dbo.XStockReturnParent", new
            {
                siv
            },
            commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public IList<XStockReturn> XStockReturns(string siv)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<XStockReturn>("dbo.XStockReturn", new
            {
                siv
            },
            commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result;
        }
        #endregion
    }
}
