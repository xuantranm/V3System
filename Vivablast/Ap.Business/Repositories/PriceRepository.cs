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
    public class PriceRepository : BaseRepository, IPriceRepository
    {
        public PriceRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        public IList<V3_List_Price> ListCondition(int page, int size, int store, int supplier, string stockCode, string stockName, int status, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Price>("dbo.V3_List_Price", new
            {
                page,
                size,
                store,
                supplier,
                stockCode,
                stockName,
                status,
                fd,
                td,
                enable
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Price>();
        }

        public int ListConditionCount(int page, int size, int store, int supplier, string stockCode, string stockName, int status, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_Price_Count", new
            {
                page,
                size,
                store,
                supplier,
                stockCode,
                stockName,
                status,
                fd,
                td,
                enable
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public V3_Price_By_Id GetByKeySp(int id, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Price_By_Id>("V3_Price_By_Id", new
            {
                id,
                enable
            },
                                           commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();

            return result;
        }

        public int CheckDelete(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_CheckDelete_Price", new
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
            var result = sql.Query<int>("V3_Delete_Price", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }
    }
}
