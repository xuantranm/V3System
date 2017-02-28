using System.Collections.Generic;
using Ap.Business.Seedworks;
using Ap.Data.Repositories;
using Ap.Data.Seedworks;
using Dapper;
using System.Data;
using System.Linq;
using Vivablast.Models;

namespace Ap.Business.Repositories
{
    public class StockServiceRepository : BaseRepository, IStockServiceRepository
    {
        public StockServiceRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        public IList<V3_List_Service> ListCondition(int page, int size, string code, string name, int store, int category, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Service>("dbo.V3_List_Service", new
            {
                page,
                size,
                code,
                name,
                store,
                category,
                enable
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Service>();
        }

        public int ListConditionCount(int page, int size, string code, string name, int store, int category, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_Service_Count", new
            {
                page,
                size,
                code,
                name,
                store,
                category,
                enable
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public IList<string> ListCode(string condition)
        {
            if (string.IsNullOrEmpty(condition))
            {
                return null;
            }

            var sql = GetSqlConnection();
            var result = sql.Query<string>("V3_StockServiceGetListCode", new
            {
                condition
            },
                                           commandType: CommandType.StoredProcedure).ToList();

            sql.Close();

            if (result.Any()) return result;
            var a = new List<string>();
            return a;
        }

        public IList<string> ListName(string condition)
        {
            if (string.IsNullOrEmpty(condition))
            {
                return null;
            }

            var sql = GetSqlConnection();
            var result = sql.Query<string>("V3_StockServiceGetListName", new
            {
                condition
            },
                                           commandType: CommandType.StoredProcedure).ToList();

            sql.Close();

            if (result.Any()) return result;
            var a = new List<string>();
            return a;
        }

        public int CheckDelete(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_CheckDelete_Service", new
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
            var result = sql.Query<int>("V3_Delete_Service", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        public IList<V3_Stock_Quantity_Management_Result> ListStockQuantity(int page, int size, string stockCode, string stockName, string store, int type, int category, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Stock_Quantity_Management_Result>("dbo.V3_Stock_Quantity_Management", new
            {
                page,
                size,
                stockCode,
                stockName,
                store,
                type,
                category,
                fd,
                td,
                enable
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_Stock_Quantity_Management_Result>();
        }

        public int ListStockQuantityCount(int page, int size, string stockCode, string stockName, string store, int type, int category, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_Stock_Quantity_Management_Count", new
            {
                page,
                size,
                stockCode,
                stockName,
                store,
                type,
                category,
                fd,
                td,
                enable
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }
    }
}
