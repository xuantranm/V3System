namespace Vivablast.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.Objects;
    using System.Linq;
    using System.Web;
    using System.Web.Mvc;

    using Vivablast.Models;
    using Vivablast.Repositories.Interfaces;
    using Vivablast.ViewModels.Builders;

    public class ServiceRepository : Repository<WAMS_ITEMS_SERVICE>, IServiceRepository
    {
        private readonly V3Entities contextSub;

        public ServiceRepository()
        {
            contextSub = new V3Entities();
        }

        public ServiceViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new ServiceViewModelBuilder
            {
                Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Categories = new SelectList(contextSub.V3_GetStockCategoryDDL(8), "bCategoryID", "vCategoryName"),
            };

            return viewModelBuilder;
        }

        public ServiceViewModelBuilder GetViewModelBuilder(int page, int size, string search, int store, int category)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = contextSub.V3_Service_GetList(page, size, "1", store, category, search, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));

            var viewModel = new ServiceViewModelBuilder
            {
                ServiceGetListResults = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }

        public List<V3_Service_GetListRpt_Result> ReportData(int page, int size, string search, int store, int category)
        {
            return contextSub.V3_Service_GetListRpt(page, size, "1", store, category, search).ToList();
        }

        public ServiceViewModelBuilder GetViewModelItemBuilder(string id)
        {
            var item = contextSub.WAMS_ITEMS_SERVICE.FirstOrDefault(s => s.vIDServiceItem == id) ?? new WAMS_ITEMS_SERVICE();
            var viewModelBuilder = new ServiceViewModelBuilder
            {
                vIDServiceItem = item.vIDServiceItem,
                vServiceItemName = item.vServiceItemName,
                vDescription = item.vDescription,
                bCategoryID = item.bCategoryID,
                bUnitID = item.bUnitID,
                bPositionID = item.bPositionID,
                bWeight = item.bWeight,
                vAccountCode = item.vAccountCode,
                dCreated = item.dCreated,
                iCreated = item.iCreated,
                StoreId = item.StoreId,
                Timestamp = item.Timestamp,
                Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Categories = new SelectList(contextSub.V3_GetStockCategoryDDL(8), "bCategoryID", "vCategoryName"),
                Units = new SelectList(contextSub.V3_GetStockUnitDDL(8), "bUnitID", "vUnitName"),
                Positions = new SelectList(contextSub.V3_GetStockPositionDDL(), "bPositionID", "vPositionName")
            };
            return viewModelBuilder;
        }

        public List<string> ListServiceCode(string search)
        {
            if (!string.IsNullOrEmpty(search))
            {
                return contextSub.V3_ServiceGetListCode(search).ToList();
            }

            return null;
        }

        public List<string> ListServiceName(string search)
        {
            if (!string.IsNullOrEmpty(search))
            {
                return contextSub.V3_ServiceGetListName(search).ToList();
            }

            return null;
        }

        public bool CheckCurrent(string condition)
        {
            return true;
        }

        public bool CheckCurrentCode(string condition)
        {
            return true;
        }

        public bool CheckDelete(int id)
        {
            return true;
        }

        public WAMS_ITEMS_SERVICE GetItemService(string code)
        {
            return contextSub.WAMS_ITEMS_SERVICE.First(m => m.vIDServiceItem == code);
        }
    }
}
