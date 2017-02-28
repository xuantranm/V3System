using Ap.Business.Domains;
using Ap.Business.Dto;
using Ap.Business.Seedworks;
using Ap.Data.Repositories;
using Ap.Data.Seedworks;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Vivablast.Models;

namespace Ap.Business.Repositories
{
    public class ProjectRepository : BaseRepository, IProjectRepository
    {
        public ProjectRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }


        public WAMS_PROJECT GetByKeySp(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<WAMS_PROJECT>("V3_ProjectById", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();

            return result;
        }

        public ProjectCustom CustomEntity(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<ProjectCustom>("dbo.V3_Project_Custom", new
            {
                id
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public IList<V3_List_Project> ListCondition(int page, int size, string projectCode, string projectName, int country, int status, int client, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_Project>("dbo.V3_List_Project", new
            {
                page,
                size,
                projectCode,
                projectName,
                country,
                status,
                client,
                fd,
                td,
                enable
            }, 
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_Project>();
        }

        public int ListConditionCount(int page, int size, string projectCode, string projectName, int country, int status, int client, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_Project_Count", new
            {
                page,
                size,
                projectCode,
                projectName,
                country,
                status,
                client,
                fd,
                td,
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
            var result = sql.Query<string>("V3_ProjectGetListCode", new
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
            var result = sql.Query<string>("V3_ProjectGetListName", new
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
            var result = sql.Query<int>("V3_CheckDelete_Project", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();

            return result;
        }

        public int Delete(int id)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_Delete_Project", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();

            return result;
        }

        #region Client
        public int InsertClient(Project_Client model)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_Insert_Client", new
            {
                model.Name,
                model.iCreated
            },
                                           commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();

            return result;
        }

        public int ExistedClient(string condition)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_Check_Client", new
            {
                condition
            },
                                           commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();

            return result;
        }

        public IList<string> ListNameClient(string condition)
        {
            if (string.IsNullOrEmpty(condition))
            {
                return null;
            }

            var sql = GetSqlConnection();
            var result = sql.Query<string>("V3_ProjectGetListNameClient", new
            {
                condition
            },
                                           commandType: CommandType.StoredProcedure).ToList();

            sql.Close();

            if (result.Any()) return result;
            var a = new List<string>();
            return a;
        }
        #endregion
    }
}
