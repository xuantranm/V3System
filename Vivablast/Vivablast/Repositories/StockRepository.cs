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

    public class StockRepository : Repository<WAMS_STOCK>, IStockRepository
    {
        private readonly V3Entities contextSub;

        public StockRepository()
        {
            contextSub = new V3Entities();
        }

        #region New
        public StockViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new StockViewModelBuilder
            {
                Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Types = new SelectList(contextSub.V3_GetStockTypeDDL(), "Id", "vTypeName"),
                Categories = new SelectList(contextSub.V3_GetStockCategoryDDL(0), "bCategoryID", "vCategoryName"),
                //StoreVs = contextSub.V3_GetStoreDDL()
            };
            return viewModelBuilder;
        }

        public StockViewModelBuilder GetViewModelBuilder(int page, int size, string search, string store, int type, int category)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = contextSub.V3_Stock_GetList(page, size, "1", store, type, category, search, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));

            var viewModel = new StockViewModelBuilder
            {
                StockVs = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size,
                //StoreVs = contextSub.Store_V
            };

            return viewModel;
        }

        public List<V3_Stock_GetListRpt_Result> ReportData(int page, int size, string search, string store, int type, int category)
        {
            return contextSub.V3_Stock_GetListRpt(page, size, "1", store, type, category, search).ToList();
        }

        public StockViewModelBuilder GetViewModelBuilderReActive(int page, int size, string search, string store, int type, int category)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = contextSub.V3_Stock_GetList(page, size, "0", store, type, category, search, output).ToList();

            var totalPages = 1;
            var totalRecord = output.Value;
            if (size != 1000)
            {
                totalPages = Convert.ToInt32(totalRecord) / size;
            }

            var viewModel = new StockViewModelBuilder
            {
                StockVs = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size,
                StoreDdlResults = contextSub.V3_GetStoreDDL().ToList()
            };

            return viewModel;
        }

        public List<V3_Stock_GetListRpt_Result> ReportDataReactive(int page, int size, string search, string store, int type, int category)
        {
            return contextSub.V3_Stock_GetListRpt(page, size, "0", store, type, category, search).ToList();
        }

        public StockViewModelBuilder GetViewModelItemBuilder(string id)
        {
            var item = contextSub.WAMS_STOCK.FirstOrDefault(s => s.vStockID == id) ?? new WAMS_STOCK();
            var viewModelBuilder = new StockViewModelBuilder
            {
                Stock = item,
                Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Types = new SelectList(contextSub.V3_GetStockTypeDDL(), "Id", "vTypeName"),
                Categories = new SelectList(contextSub.V3_GetStockCategoryDDL(0), "bCategoryID", "vCategoryName"),
                Units = new SelectList(contextSub.V3_GetStockUnitDDL(0), "bUnitID", "vUnitName"),
                Positions = new SelectList(contextSub.V3_GetStockPositionDDL(), "bPositionID", "vPositionName"),
                Labels = new SelectList(contextSub.V3_GetStockLabelDDL(0), "bLabelID", "vLabelName")
            };
            return viewModelBuilder;
        }

        public List<string> ListStockCode(string search)
        {
            if (!string.IsNullOrEmpty(search))
            {
                // Take(10) avoid slowly system
                return contextSub.V3_StockGetListCode(search).ToList();
                //var resultName =
                //    contextSub.Stock_V.AsEnumerable().Where(
                //        s => s.iEnable.Equals(0) && s.vStockName.ToUpper().Contains(search.ToUpper())).Take(10)
                //        .Select(s => s.vStockName).ToList();
                //var resultStockId =
                //    contextSub.Stock_V.AsEnumerable().Where(
                //        s => s.iEnable.Equals(0) && s.vStockID.ToUpper().Contains(search.ToUpper())).Take(10)
                //        .Select(s => s.vStockID).ToList();
                //return resultName.Union(resultStockId).ToList();
            }

            return null;
        }

        public List<string> ListStockName(string search)
        {
            if (!string.IsNullOrEmpty(search))
            {
                return contextSub.V3_StockGetListName(search).ToList();
            }

            return null;
        }

        public StockViewModelBuilder GetViewModelItemQuantityManagementBuilder(string id)
        {
            var stock = contextSub.V3_GetStockInformation(1, id).FirstOrDefault();

            var viewModelBuilder = new StockViewModelBuilder
            {
                StockInformation = stock
            };
            return viewModelBuilder;
        }

        public StockViewModelBuilder GetViewModelListQtyMng(int page, int size, string stock, string fd, string td)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = contextSub.V3_Stock_Quantity_Management(page, size, stock, fd, td, output).ToList();

            var totalPages = 1;
            var totalRecord = output.Value;
            if (size != 1000)
            {
                totalPages = Convert.ToInt32(totalRecord) / size;
            }

            var viewModel = new StockViewModelBuilder
            {
                StockQuantityManagementResults = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }


        #endregion

        public bool CheckCurrent(string condition)
        {
            var user = contextSub.WAMS_STOCK.FirstOrDefault(s => s.vStockName.ToLower().Equals(condition.ToLower()));
            return user == null;
        }

        public bool CheckCurrentCode(string condition)
        {
            var user = contextSub.WAMS_STOCK.FirstOrDefault(s => s.vStockID.ToLower().Equals(condition.ToLower()));
            return user == null;
        }

        public bool CheckDelete(int condition)
        {
            var assign = contextSub.WAMS_ASSIGNNING_STOCKS.Count(s => s.vStockID == condition);
            if (assign > 0)
            {
                return false;
            }

            var returnStock = contextSub.WAMS_RETURN_LIST.Count(s => s.vStockID == condition);
            if (returnStock > 0)
            {
                return false;
            }

            var fulfillment = contextSub.WAMS_FULFILLMENT_DETAIL.Count(s => s.vStockID == condition);
            if (fulfillment > 0)
            {
                return false;
            }

            var requisition = contextSub.WAMS_REQUISITION_DETAILS.Count(s => s.vStockID == condition);
            if (requisition > 0)
            {
                return false;
            }

            var po = contextSub.WAMS_PO_DETAILS.Count(s => s.vProductID == condition);
            if (po > 0)
            {
                return false;
            }

            return true;
        }

        public WAMS_STOCK GetStock(string code)
        {
            return contextSub.WAMS_STOCK.First(s => s.vStockID == code);
        }

        public bool ReActive(string condition)
        {
            try
            {
                contextSub.Database.ExecuteSqlCommand("UPDATE WAMS_STOCK SET iEnable=1 WHERE vStockId = {0}", condition);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public IEnumerable<V3_GetStockTypeDDL_Result> Types()
        {
            return contextSub.V3_GetStockTypeDDL();
        }

        public IEnumerable<V3_GetStockCategoryDDL_Result> Categories(int? typeId)
        {
            return contextSub.V3_GetStockCategoryDDL(typeId);
        }

        public IEnumerable<V3_GetSupplierDDL_Result> Suppliers()
        {
            return contextSub.V3_GetSupplierDDL();
        }

        public IEnumerable<V3_GetStockUnitDDL_Result> Units(int? typeId)
        {
            return contextSub.V3_GetStockUnitDDL(typeId);
        }

        public IEnumerable<V3_GetStockPositionDDL_Result> Positions()
        {
            return contextSub.V3_GetStockPositionDDL();
        }

        public IEnumerable<V3_GetStockLabelDDL_Result> Labels(int? typeId)
        {
            return contextSub.V3_GetStockLabelDDL(typeId);
        }
    }
}
