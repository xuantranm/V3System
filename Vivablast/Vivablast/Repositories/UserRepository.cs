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

    using Common;
    using Models;
    using Interfaces;
    using ViewModels.Builders;

    public class UserRepository : Repository<WAMS_USER>, IUserRepository
    {
        private readonly V3Entities _contextSub;
        protected IDatabaseFactory DatabaseFactory { get; private set; }

        public UserRepository(IDatabaseFactory databaseFactory)
        {
            DatabaseFactory = databaseFactory;
            _contextSub = new V3Entities();
        }

        public bool CheckUser(string user, string password)
        {
            var userS = _contextSub.V3_User_CheckLogin(user.ToLower()).First();
            if (userS == null) return false;
            var hashedPassword = Helpers.CreateHash(password);
            return hashedPassword.Equals(userS.Password);
        }

        public V3_User_GetItemByCondition_Result GetUserAndRole(string userName)
        {
            return _contextSub.V3_User_GetItemByCondition(0, userName).FirstOrDefault();
        }

        public UserViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new UserViewModelBuilder
            {
                Stores = new SelectList(_contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Deparments = new SelectList(GetLookUp("department"), "LookUpValue", "LookUpValue")
            };
            return viewModelBuilder;
        }

        public UserViewModelBuilder GetViewModelBuilder(int page, int size, string userF, string dep, int store, string fd, string td)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var user = _contextSub.V3_User_GetList(page, size, "1", store, dep, userF, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
           
            var userViewModelBuilder = new UserViewModelBuilder
            {
                UserGetListResults = user,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };
            return userViewModelBuilder;
        }

        public List<V3_User_GetListRpt_Result> ReportData(int page, int size, string userF, string dep, int store, string fd, string td)
        {
            return _contextSub.V3_User_GetListRpt(page, size, "1", store, dep, userF).ToList();
        }


        public UserViewModelBuilder GetViewModelItemBuilder(int? id)
        {
            var user = new V3_User_GetItemByCondition_Result();
            if (id.HasValue)
            {
                user = _contextSub.V3_User_GetItemByCondition(id.Value, string.Empty).FirstOrDefault();
            }

            var viewModel = new UserViewModelBuilder
                {
                    Stores = new SelectList(_contextSub.V3_GetStoreDDL(), "Id", "sName"),
                    UserItem = user,
                    Deparments = new SelectList(GetLookUp("department"), "LookUpValue", "LookUpValue")
                };

            return viewModel;
        }

        public List<string> ListUserName(string condition)
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

            if (!result.Any())
            {
                var a = new List<string> { "Not found" };
                return a;
            }

            return result;
        }

        public bool CheckCurrent(string condition)
        {
            var user = _contextSub.WAMS_USER.SingleOrDefault(s => s.vUsername.ToLower().Equals(condition.ToLower()));
            return user == null;
        }

        public bool CheckDelete(int id)
        {
            if (_contextSub.WAMS_SUPPLIER.Count(s => s.iCreated == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_SUPPLIER.Count(s => s.iModified == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_FULFILLMENT_DETAIL.Count(s => s.iCreated == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_FULFILLMENT_DETAIL.Count(s => s.iModified == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_RETURN_LIST.Count(s => s.iCreated == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_RETURN_LIST.Count(s => s.iModified == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_ASSIGNNING_STOCKS.Count(s => s.iCreated == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_ASSIGNNING_STOCKS.Count(s => s.iModified == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_STOCK.Count(s => s.iCreated == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_STOCK.Count(s => s.iModified == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_PROJECT.Count(s => s.iCreated == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_PROJECT.Count(s => s.iModified == id) > 0)
            {
                return false;
            }

            if (_contextSub.Stores.Count(s => s.iCreated == id) > 0)
            {
                return false;
            }

            if (_contextSub.Stores.Count(s => s.iModified == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_USER.Count(s => s.iCreated == id) > 0)
            {
                return false;
            }

            if (_contextSub.WAMS_USER.Count(s => s.iModified == id) > 0)
            {
                return false;
            }

            return true;
        }

        public string GetVersion(object condition)
        {
            return Convert.ToBase64String(GetById(condition).Timestamp);
        }

        public bool DisableItem(int id)
        {
            var user = GetById(id);
            if (user != null)
            {
                try
                {
                    user.iEnable = true;
                    Update(user);
                    Save();
                    return true;
                }
                catch (Exception)
                {
                    return false;
                }
            }

            return false;
        }

        public WAMS_USER GetUser(int id)
        {
            return _contextSub.WAMS_USER.First(s => s.bUserId == id);
        }

        public WAMS_FUNCTION_MANAGEMENT GetUserFunction(int id)
        {
            return _contextSub.WAMS_FUNCTION_MANAGEMENT.First(s => s.bUserID == id);
        }

        protected SqlConnection GetSqlConnection()
        {
            var sql = DatabaseFactory.GetSqlConnection();
            if (sql.State != ConnectionState.Open) sql.Open();

            return sql;
        }
    }
}
