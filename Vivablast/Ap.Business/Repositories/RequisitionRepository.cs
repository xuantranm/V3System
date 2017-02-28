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
    public class RequisitionRepository : BaseRepository, IRequisitionRepository
    {
        public RequisitionRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        public IList<V3_List_Requisition> ListCondition(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Requisition>("dbo.V3_List_Requisition", new
            {
                page,
                size,
                enable,
                store,
                mrf,
                stockCode,
                stockName,
                status,
                fd,
                td
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Requisition>();
        }

        public int ListConditionCount(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_Requisition_Count", new
            {
                page,
                size,
                enable,
                store,
                mrf,
                stockCode,
                stockName,
                status,
                fd,
                td
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public IList<V3_RequisitionDetail_Result> ListConditionDetail(int id, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_RequisitionDetail_Result>("dbo.V3_RequisitionDetail", new
            {
                id,
                enable
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_RequisitionDetail_Result>();
        }

        public IList<V3_RequisitionDetail_Result> ListConditionDetailExcel(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_RequisitionDetail_Result>("dbo.V3_List_Requisition_Detail", new
            {
                page,
                size,
                enable,
                store,
                mrf,
                stockCode,
                stockName,
                status,
                fd,
                td
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_RequisitionDetail_Result>();
        }

        public IList<string> ListCode(string condition)
        {
            if (string.IsNullOrEmpty(condition))
            {
                return null;
            }

            var sql = GetSqlConnection();
            var result = sql.Query<string>("V3_RequisitionGetListCode", new
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
            var result = sql.Query<int>("V3_Delete_Requisition_Detail", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        public string GetCodeLastest()
        {
            var sql = GetSqlConnection();
            var result = sql.Query<string>("dbo.V3_GetMRFLastest", new
            {
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public V3_Requisition_Master GetRequisitionMasterByKey(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Requisition_Master>("dbo.V3_Requisition_Master", new
            {
                id
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();

            return result;
        }
    }
}
