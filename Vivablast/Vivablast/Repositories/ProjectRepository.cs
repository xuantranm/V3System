using System.Data;
using System.Data.SqlClient;
using Dapper;

namespace Vivablast.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.Objects;
    using System.Linq;
    using System.Web.Mvc;

    using Vivablast.Models;
    using Vivablast.Repositories.Interfaces;
    using Vivablast.ViewModels.Builders;

    public class ProjectRepository : Repository<WAMS_PROJECT>, IProjectRepository
    {
        private readonly V3Entities _contextSub;
        protected IDatabaseFactory DatabaseFactory { get; private set; }

        public ProjectRepository(IDatabaseFactory databaseFactory)
        {
            DatabaseFactory = databaseFactory;
            this._contextSub = new V3Entities();
        }

        public ProjectViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new ProjectViewModelBuilder
            {
                Countries = new SelectList(this._contextSub.V3_GetCountryDDL(), "Id", "NameNice"),
                Client = new SelectList(this._contextSub.V3_GetProjectClientDDL(), "Id", "Name"),
                Suppervisor = new SelectList(this._contextSub.V3_GetWorkerDDL(), "vWorkerID", "Suppervisor"),
                StatusProject = new SelectList(this.GetLookUp("projectstatus"), "LookUpValue", "LookUpValue"),
                Projects = new SelectList(this._contextSub.V3_GetProjectDDL(), "Id", "vProjectID")
            };
            return viewModelBuilder;
        }

        public ProjectViewModelBuilder GetViewModelBuilder(int page, int size, string projectId, int country, string status, int client, string fd, string td)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = this._contextSub.V3_Project_GetList(page, size, projectId, country, status, client, fd, td, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));

            var viewModel = new ProjectViewModelBuilder
            {
                ProjectGetListResults = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }

        public List<V3_Project_GetListRpt_Result> ReportData(int page, int size, string projectId, int country, string status, int client, string fd, string td)
        {
            return _contextSub.V3_Project_GetListRpt(page, size, projectId, country, status, client, fd, td).ToList();
        }

        public ProjectViewModelBuilder GetViewModelItemBuilder(int? id)
        {
            var project = new WAMS_PROJECT();
            if (id.HasValue)
            {
                project = _contextSub.WAMS_PROJECT.FirstOrDefault(m => m.Id == id);
            }

            var projectViewModelBuilder = new ProjectViewModelBuilder
            {
                Project = project,
                Countries = new SelectList(this._contextSub.V3_GetCountryDDL(), "Id", "NameNice"),
                Client = new SelectList(this._contextSub.V3_GetProjectClientDDL(), "Id", "Name"),
                Suppervisor = new SelectList(this._contextSub.V3_GetWorkerDDL(), "vWorkerID", "Suppervisor"),
                StatusProject = new SelectList(this.GetLookUp("projectstatus"), "LookUpValue", "LookUpValue")
            };
            return projectViewModelBuilder;
        }

        public List<string> listProjectId(string condition)
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

            if (!result.Any())
            {
                var a = new List<string> { "Not found" };
                return a;
            }

            return result;
        }

        public List<string> ListProjectName(string condition)
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

            if (!result.Any())
            {
                var a = new List<string> { "Not found" };
                return a;
            }

            return result;
        }

        public bool CheckCurrent(string condition)
        {
            var user = this._contextSub.WAMS_PROJECT.SingleOrDefault(s => s.vProjectName.ToLower().Equals(condition.ToLower()));
            return user == null;
        }

        public bool CheckCurrentCode(string condition)
        {
            var user = this._contextSub.WAMS_PROJECT.SingleOrDefault(s => s.vProjectID.ToLower().Equals(condition.ToLower()));
            return user == null;
        }

        public bool CheckDelete(int id)
        {
            var assign = this._contextSub.WAMS_ASSIGNNING_STOCKS.Count(s => s.vProjectID == id);
            if (assign > 0)
            {
                return false;
            }

            var returnStock = this._contextSub.WAMS_RETURN_LIST.Count(s => s.vProjectID == id);
            if (returnStock > 0)
            {
                return false;
            }

            var requistion = this._contextSub.WAMS_REQUISITION_MASTER.Count(s => s.vProjectID == id);
            if (requistion > 0)
            {
                return false;
            }

            var po = this._contextSub.WAMS_PURCHASE_ORDER.Count(s => s.vProjectID == id);
            if (po > 0)
            {
                return false;
            }

            return true;

            // To PO because Requisition no need project Id, PO need project Id
        }

        public WAMS_PROJECT GetProject(int id)
        {
            return this._contextSub.WAMS_PROJECT.FirstOrDefault(s => s.Id == id);
        }

        protected SqlConnection GetSqlConnection()
        {
            var sql = DatabaseFactory.GetSqlConnection();
            if (sql.State != ConnectionState.Open) sql.Open();

            return sql;
        }
    }
}
