using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Data.Entity.Infrastructure;
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
    public class UserRepository : BaseRepository, IUserRepository
    {
        public UserRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        //public XUser GetUserAndRole(int? id, string user)
        //{
        //    var sql = GetSqlConnection();
        //    var result = sql.Query<XUser>("dbo.XUser_Item", new
        //    {
        //        id,
        //        user
        //    }, 
        //                                 commandType: CommandType.StoredProcedure).FirstOrDefault();

        //    sql.Close();
           
        //    return result;
        //}

        public V3_Check_Login CheckUser(string user)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_Check_Login>("dbo.V3_Check_Login", new
            {
                user
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();

            return result;
        }

        public IList<XUser> ListCondition(int page, int size, int store, string department, string user, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<XUser>("dbo.XUser_List", new
            {
                page,
                size,
                enable,
                store,
                department,
                user
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<XUser>();
        }

        public int ListConditionCount(int page, int size, int store, string department, string user, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.XUser_List_Count", new
            {
                page,
                size,
                enable,
                store,
                department,
                user
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public IList<string> ListName(string condition)
        {
            if (string.IsNullOrEmpty(condition))
            {
                return null;
            }

            var sql = GetSqlConnection();
            var result = sql.Query<string>("V3_UserGetListName", new
            {
                condition
            },
                                           commandType: CommandType.StoredProcedure).ToList();

            sql.Close();

            if (result.Any()) return result;
            var a = new List<string> { "Not found" };
            return a;
        }

        public IList<string> ListEmail(string condition)
        {
            if (string.IsNullOrEmpty(condition))
            {
                return null;
            }

            var sql = GetSqlConnection();
            var result = sql.Query<string>("V3_UserGetEmail", new
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
            var result = sql.Query<int>("V3_CheckDelete_User", new
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
            var result = sql.Query<int>("V3_Delete_User", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }
    }
}
