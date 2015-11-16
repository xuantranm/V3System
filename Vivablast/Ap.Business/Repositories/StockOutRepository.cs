﻿using System.Collections;
using System.Collections.Generic;
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
    public class StockOutRepository : BaseRepository, IStockOutRepository
    {
        public StockOutRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
            : base(databaseFactory, dbContext)
        {

        }

        public IList<V3_List_StockAssign> ListCondition(int page, int size, int store, int project, int stocktype,
            string stockCode, string stockName, string siv, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_StockAssign>("dbo.V3_List_StockOut", new
            {
                page,
                size,
                store,
                project,
                stocktype,
                stockCode,
                stockName,
                siv,
                fd,
                td,
                enable
            },
                                         commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_StockAssign>();
        }

        public int ListConditionCount(int page, int size, int store, int project, int stocktype, string stockCode,
            string stockName, string siv, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("dbo.V3_List_StockOut_Count", new
            {
                page,
                size,
                store,
                project,
                stocktype,
                stockCode,
                stockName,
                siv,
                fd,
                td,
                enable
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public List<V3_List_StockAssign_Detail> ListConditionDetail(int id, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_StockAssign_Detail>("dbo.V3_StockOutDetail", new
            {
                id,
                enable
            },
            commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_StockAssign_Detail>();
        }

        public IList<V3_List_StockAssign_Detail> ListConditionDetailExcel(int page, int size, int store, int project,
            int stocktype, string stockCode, string stockName, string siv, string fd, string td, string enable)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_List_StockAssign_Detail>("dbo.V3_List_StockIn_Detail", new
            {
                page,
                size,
                store,
                project,
                stocktype,
                stockCode,
                stockName,
                siv,
                fd,
                td,
                enable
            },
            commandType: CommandType.StoredProcedure).ToList();

            sql.Close();
            return result.Any() ? result : new List<V3_List_StockAssign_Detail>(); 
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
            var result = sql.Query<int>("V3_Delete_StockIn_Detail", new
            {
                id
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        public V3_SIV_Max SIVLastest(string type)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<V3_SIV_Max>("dbo.V3_GetSIVLastest", new
            {
            },
                                         commandType: CommandType.StoredProcedure).FirstOrDefault();

            sql.Close();
            return result;
        }

        public int Add(WAMS_ASSIGNNING_STOCKS model)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_InsertStockOut", new
            {
                model.vStockID,
                model.vProjectID,
                model.bQuantity,
                model.vWorkerID,
                model.SIV,
                model.vMRF,
                model.FromStore,
                model.ToStore,
                model.iCreated,
                model.FlagFile,
                model.Description
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }

        public int Update(WAMS_ASSIGNNING_STOCKS model)
        {
            var sql = GetSqlConnection();
            var result = sql.Query<int>("V3_UpdateStockOut", new
            {
                model.bAssignningStockID,
                model.vStockID,
                model.vProjectID,
                model.bQuantity,
                model.vWorkerID,
                model.SIV,
                model.vMRF,
                model.FromStore,
                model.ToStore,
                model.iCreated,
                model.FlagFile,
                model.Description
            },
                                           commandType: CommandType.StoredProcedure).SingleOrDefault();

            sql.Close();

            return result;
        }
    }
}
