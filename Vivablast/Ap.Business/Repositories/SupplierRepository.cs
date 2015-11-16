using System.Collections;
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
    public class SupplierRepository : BaseRepository, ISupplierRepository
    {
        public SupplierRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        public IList<V3_List_Supplier> ListCondition(int page, int size, int supplierType, int supplierId, string stockCode, string stockName, int country, int market, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Supplier>("dbo.V3_List_Supplier", new
            {
                page,
                size,
                supplierType,
                supplierId,
                stockCode,
                stockName,
                country,
                market,
                enable
            },
                   commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Supplier>();
        }

        public int ListConditionCount(int page, int size, int supplierType, int supplierId, string stockCode, string stockName, int country, int market, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_Supplier_Count", new
            {
                page,
                size,
                supplierType,
                supplierId,
                stockCode,
                stockName,
                country,
                market,
                enable
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public IList<V3_List_Supplier_Product> ListConditionDetail(int id, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Supplier_Product>("dbo.V3_SupplierProduct", new
            {
                id,
                enable
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Supplier_Product>();
        }

        public IList<V3_List_Supplier_Product> ListConditionDetailExcel(int page, int size, int supplierType, int supplierId, string stockCode, string stockName, int country, int market, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Supplier_Product>("dbo.V3_List_Supplier_Product", new
            {
                page,
                size,
                supplierType,
                supplierId,
                stockCode,
                stockName,
                country,
                market,
                enable
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Supplier_Product>();
        }

        public IList<string> ListName(string condition)
        {
            if (string.IsNullOrEmpty(condition))
            {
                return null;
            }

            var sql = GetSqlConnection();
            var result = sql.Query<string>("V3_SupplierGetListName", new
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
            var result = sql.Query<int>("V3_CheckDelete_Supplier", new
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
            var result = sql.Query<int>("V3_Delete_Supplier", new
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
            var result = sql.Query<int>("V3_Delete_Supplier_Detail", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }
    }
}
