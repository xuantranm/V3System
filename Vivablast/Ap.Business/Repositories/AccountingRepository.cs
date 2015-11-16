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
    public class AccountingRepository : BaseRepository, IAccountingRepository
    {
        public AccountingRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        public IList<V3_List_Accounting> ListCondition(int page, int size, int type, int status, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Accounting>("dbo.V3_List_Accounting", new
            {
                page,
                size,
                type,
                status,
                sirv,
                stock,
                beginStore,
                endStore,
                project,
                supplier,
                po,
                fd,
                td
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Accounting>();
        }

        public int ListConditionCount(int page, int size, int type, int status, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_Accounting_Count", new
            {
                page,
                size,
                type,
                status,
                sirv,
                stock,
                beginStore,
                endStore,
                project,
                supplier,
                po,
                fd,
                td
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
            var result = sql.Query<string>("V3_PeGetListCode", new
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
            var result = sql.Query<int>("V3_CheckDelete_Pe", new
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
            var result = sql.Query<int>("V3_Delete_Pe", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }
    }
}
