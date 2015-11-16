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

    public class StoreRepository : Repository<Store>, IStoreRepository
    {
        private readonly V3Entities contextSub;

        public StoreRepository()
        {
            this.contextSub = new V3Entities();
        }

        public StoreViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new StoreViewModelBuilder
            {
                Countries = new SelectList(this.contextSub.V3_GetCountryDDL(), "Id", "NameNice")
            };
            return viewModelBuilder;
        }

        public StoreViewModelBuilder GetViewModelBuilder(int page, int size, string search, int country)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = contextSub.V3_Store_GetList(page, size, "1", search, country, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));

            var viewModel = new StoreViewModelBuilder
            {
                StoreManagements = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }

        public List<V3_Store_GetListRpt_Result> ReportData(int page, int size, string search, int country)
        {
            return contextSub.V3_Store_GetListRpt(page, size, "1", search, country).ToList();
        }

        public StoreViewModelBuilder GetViewModelItemBuilder(int id)
        {
            var store = this.contextSub.Stores.FirstOrDefault(s => s.Id.Equals(id));
            var storeViewModelBuilder = new StoreViewModelBuilder
            {
                Countries = new SelectList(this.contextSub.V3_GetCountryDDL(), "Id", "NameNice"),
                Store = store ?? new Store()
            };
            return storeViewModelBuilder;
        }

        public List<string> listData(string search)
        {
            if (!string.IsNullOrEmpty(search))
            {
                // Take(10) avoid slowly system
                var resultName =
                    this.contextSub.Stores.AsEnumerable().Where(
                        s => s.iEnable.Equals(true) && s.sName.ToUpper().Contains(search.ToUpper())).Take(5)
                        .Select(s => s.sName).ToList();
                var resultCode = this.contextSub.Stores.AsEnumerable().Where(
                        s => s.iEnable.Equals(true) && s.sCode.ToUpper().Contains(search.ToUpper())).Take(5)
                        .Select(s => s.sCode).ToList();
                return resultName.Union(resultCode).ToList();
            }

            return null;
        }

        public bool CheckDelete(int id)
        {
            if (this.contextSub.WAMS_USER.Count(s => s.storeId == id) > 0)
            {
                return false;
            }

            if (this.contextSub.Store_Stock.Count(s => s.Store == id) > 0)
            {
                return false;
            }

            if (this.contextSub.WAMS_PROJECT.Count(s => s.iStore == id) > 0)
            {
                return false;
            }

            if (this.contextSub.WAMS_REQUISITION_MASTER.Count(s => s.iStore == id) > 0)
            {
                return false;
            }

            if (this.contextSub.WAMS_PURCHASE_ORDER.Count(s => s.iStore == id) > 0)
            {
                return false;
            }

            return true;
        }

        public bool CheckCurrent(string condition)
        {
            var store = this.contextSub.Stores.FirstOrDefault(s => s.sName.ToUpper().Equals(condition.ToUpper()));
            if (store != null)
            {
                return false;
            }

            return true;
        }

        public Store GetStore(int id)
        {
            return this.contextSub.Stores.FirstOrDefault(s => s.Id == id);
        }
    }
}
