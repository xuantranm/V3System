using System;
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
    public class StockRepository : BaseRepository, IStockRepository
    {
        public StockRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        public XStockViewModel StockViewModelFilter(int page, int size, string stockCode, string stockName, string store, int type,
            int category, string enable)
        {
            var model = new XStockViewModel();
            var paramss = new DynamicParameters();
            paramss.Add("page", page);
            paramss.Add("size", size);
            paramss.Add("stockCode", stockCode);
            paramss.Add("stockName", stockName);
            paramss.Add("store", store);
            paramss.Add("type", type);
            paramss.Add("category", category);
            paramss.Add("enable", enable);
            paramss.Add("out", dbType: DbType.Int32, direction: ParameterDirection.Output);

            using (var sql = GetSqlConnection())
            {
                var data = sql.Query<XStockModel>("XGetListStock", paramss, commandType: CommandType.StoredProcedure);
                sql.Close();
                model.StockVs = data.ToList();
                var total = paramss.Get<int>("out");
                model.TotalRecords = total;
                var totalTemp = Convert.ToDecimal(total) / Convert.ToDecimal(size);
                model.TotalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            }

            return model;
        }

        public XStockViewModel ProductPeViewModelFilter(int page, int size, string stockCode, string stockName, string store, int type,
            int category, string enable, int supplier)
        {
            var model = new XStockViewModel();
            var paramss = new DynamicParameters();
            paramss.Add("page", page);
            paramss.Add("size", size);
            paramss.Add("stockCode", stockCode);
            paramss.Add("stockName", stockName);
            paramss.Add("store", store);
            paramss.Add("type", type);
            paramss.Add("category", category);
            paramss.Add("enable", enable);
            paramss.Add("supplier", supplier);
            paramss.Add("out", dbType: DbType.Int32, direction: ParameterDirection.Output);

            using (var sql = GetSqlConnection())
            {
                var data = sql.Query<XStockModel>("XGetListProductPe", paramss, commandType: CommandType.StoredProcedure);
                sql.Close();
                model.StockVs = data.ToList();
                var total = paramss.Get<int>("out");
                model.TotalRecords = total;
                var totalTemp = Convert.ToDecimal(total) / Convert.ToDecimal(size);
                model.TotalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            }

            return model;
        }

        public IList<V3_List_Stock> PeListCondition(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable, int supplier)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Stock>("dbo.V3_List_Stock_Pe", new
            {
                page,
                size,
                stockCode,
                stockName,
                store,
                type,
                category,
                enable,
                supplier
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Stock>();
        }

        public int PeListConditionCount(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable, int supplier)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_Stock_Pe_Count", new
            {
                page,
                size,
                stockCode,
                stockName,
                store,
                type,
                category,
                enable,
                supplier
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public IList<V3_List_Stock> StockInListCondition(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable, int pe)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Stock>("dbo.V3_List_Stock_StockIn", new
            {
                page,
                size,
                stockCode,
                stockName,
                store,
                type,
                category,
                enable,
                pe
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Stock>();
        }

        public int StockInListConditionCount(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable, int pe)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_Stock_StockIn_Count", new
            {
                page,
                size,
                stockCode,
                stockName,
                store,
                type,
                category,
                enable,
                pe
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public IList<V3_List_Stock> StockOutListCondition(int page, int size, string stockCode, string stockName, int store, int type, int category)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Stock>("dbo.V3_List_Stock_StockOut", new
            {
                page,
                size,
                stockCode,
                stockName,
                store,
                type,
                category
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Stock>();
        }

        public int StockOutListConditionCount(int page, int size, string stockCode, string stockName, int store, int type, int category)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_Stock_StockOut_Count", new
            {
                page,
                size,
                stockCode,
                stockName,
                store,
                type,
                category
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public IList<V3_List_Stock> StockReturnListCondition(int page, int size, string stockCode, string stockName, int project, int type, int category)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Stock>("dbo.V3_List_Stock_StockReturn", new
            {
                page,
                size,
                stockCode,
                stockName,
                project,
                type,
                category
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Stock>();
        }

        public int StockReturnListConditionCount(int page, int size, string stockCode, string stockName, int project, int type, int category)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_Stock_StockReturn_Count", new
            {
                page,
                size,
                stockCode,
                stockName,
                project,
                type,
                category
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
            var result = sql.Query<string>("V3_StockGetListCode", new
            {
                condition
            },
                                           commandType: CommandType.StoredProcedure).ToList();

            sql.Close();

            if (result.Any()) return result;
            var a = new List<string> { "Not found" };
            return a;
        }

        public IList<string> ListName(string condition)
        {
            if (string.IsNullOrEmpty(condition))
            {
                return null;
            }

            var sql = GetSqlConnection();
            var result = sql.Query<string>("V3_StockGetListName", new
            {
                condition
            },
                                           commandType: CommandType.StoredProcedure).ToList();

            sql.Close();

            if (result.Any()) return result;
            var a = new List<string> { "Not found" };
            return a;
        }

        public int CheckDelete(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_CheckDelete_Stock", new
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
            var result = sql.Query<int>("V3_Delete_Stock", new
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

        public string NewStockCode(int type, int category)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<string>("dbo.V3_NewStockCode", new
            {
               type,
               category
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }
    }
}
