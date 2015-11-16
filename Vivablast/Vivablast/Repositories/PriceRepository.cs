namespace Vivablast.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.Objects;
    using System.Globalization;
    using System.Linq;
    using System.Web.Mvc;

    using Vivablast.Models;
    using Vivablast.Repositories.Interfaces;
    using Vivablast.ViewModels.Builders;

    public class PriceRepository : Repository<Product_Price>, IPriceRepository
    {
        private readonly V3Entities contextSub;

        public PriceRepository()
        {
            this.contextSub = new V3Entities();
        }

        public PriceViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new PriceViewModelBuilder
            {
                Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Suppliers = new SelectList(contextSub.V3_GetSupplierDDL(), "bSupplierID", "vSupplierName")
            };

            return viewModelBuilder;
        }

        public PriceViewModelBuilder GetPriceViewModelBuilder(int page, int size, int store, int sup, string stock, string fd, string td)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = contextSub.V3_Price_GetList(page, size, store, sup, stock, fd, fd, 1, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));

            var viewModel = new PriceViewModelBuilder
            {
                PriceGetListResults = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }

        public List<V3_Price_GetListRpt_Result> ReportData(int page, int size, int store, int sup, string stock, string fd, string td)
        {
            return contextSub.V3_Price_GetListRpt(page, size, store, sup, stock, fd, td, 1).ToList();
        } 

        public PriceViewModelBuilder GetViewModelItemBuilder(int? condition)
        {
            var viewModelBuilder = new PriceViewModelBuilder();
            if (condition.HasValue)
            {
                //var item = this.contextSub.Product_Price_V.First(s => s.iEnable == true && s.Id == condition);
                //viewModelBuilder.ProductPriceV = item;
            }
            else
            {
                //viewModelBuilder.ProductPriceV = new Product_Price_V();
            }

            viewModelBuilder.Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName");
            viewModelBuilder.Suppliers = new SelectList(this.contextSub.V3_GetSupplierDDL(), "bSupplierID", "vSupplierName");
            viewModelBuilder.Currencies = new SelectList(this.contextSub.WAMS_CURRENCY_TYPE.OrderBy(s => s.vCurrencyName), "bCurrencyTypeID", "vCurrencyName");
            return viewModelBuilder;
        }

        #region Search Product
        public StockViewModelBuilder GetProductSearchViewModelBuilder()
        {
            var viewModel = new StockViewModelBuilder
            {
                Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Types = new SelectList(this.contextSub.V3_GetStockTypeDDL(), "Id", "vTypeName"),
                Categories = new SelectList(this.contextSub.V3_GetStockCategoryDDL(null), "bCategoryID", "vCategoryName"),
                Units = new SelectList(this.contextSub.V3_GetStockUnitDDL(null), "bUnitID", "vUnitName"),
                Positions = new SelectList(this.contextSub.V3_GetStockPositionDDL(), "bPositionID", "vPositionName"),
                Labels = new SelectList(this.contextSub.V3_GetStockLabelDDL(null), "bLabelID", "vLabelName"),
            };
            return viewModel;
        }

        public StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int pageSize, int? storeId, int? typeId, int? cate, string stockCode)
        {
            //var lstProduct = this.contextSub.Stock_V.AsEnumerable().Where(s => s.iEnable == true);
            //IEnumerable<Store_V> stores;

            //#region Condtion
            //if (storeId.HasValue && storeId.Value != 1)
            //{
            //    stores = this.contextSub.Store_V.AsEnumerable().Where(st => st.iEnable == true && st.Id == storeId);
            //}
            //else
            //{
            //    stores = this.contextSub.Store_V.AsEnumerable().Where(st => st.iEnable == true && st.sName != "All");
            //}

            //if (typeId.HasValue)
            //{
            //    lstProduct = lstProduct.Where(s => s.iType == typeId);
            //}

            //if (cate.HasValue)
            //{
            //    lstProduct = lstProduct.Where(s => s.bCategoryID == cate);
            //}

            //if (!string.IsNullOrEmpty(stockCode))
            //{
            //    lstProduct = lstProduct.Where(s => s.vStockID.Contains(stockCode) || s.vStockName.Contains(stockCode));
            //}
            //#endregion

            //if (lstProduct != null)
            //{
            //    var totalRecords = lstProduct.Count();

            //    var totalPages = 1;

            //    if (pageSize != 1000)
            //    {
            //        lstProduct = lstProduct.Skip((page - 1) * pageSize).Take(pageSize);
            //        totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);
            //    }

            //    var viewModelBuilder = new StockViewModelBuilder
            //    {
            //        TotalRecords = totalRecords,
            //        TotalPages = totalPages,
            //        CurrentPage = page,
            //        PageSize = pageSize,
            //        //StockVs = lstProduct,
            //        StoreVs = stores
            //    };
            //    return viewModelBuilder;
            //}

            return null;
        }
        #endregion
    }
}
