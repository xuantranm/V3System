using System;
using System.Linq;

namespace Vivablast.Repositories
{
    using System.Collections.Generic;
    using System.Data.Objects;
    using System.Globalization;
    using System.Web.Mvc;

    using Vivablast.Models;
    using Vivablast.Repositories.Interfaces;
    using Vivablast.ViewModels.Builders;

    public class SupplierRepository : Repository<WAMS_SUPPLIER>, ISupplierRepository
    {
        private readonly V3Entities contextSub;

        public SupplierRepository()
        {
            contextSub = new V3Entities();
        }

        public SupplierViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new SupplierViewModelBuilder
            {
                Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Countries = new SelectList(contextSub.V3_GetCountryDDL(), "Id", "NameNice"),
                Types = new SelectList(contextSub.V3_GetSupplierDDL(), "bSupplierTypeID", "vSupplierTypeName"),
                Suppliers = new SelectList(contextSub.V3_GetSupplierDDL(), "bSupplierID", "vSupplierName")
            };

            return viewModelBuilder;
        }

        public SupplierViewModelBuilder GetSupplierViewModelBuilder(int page, int size, int supType, int sup, string stock, int country, int market)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = contextSub.V3_Supplier_GetList(page, size, supType, sup, stock, country, market, 1, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));

            var viewModel = new SupplierViewModelBuilder
            {
                SupplierGetListResults = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }

        public List<V3_Supplier_GetListRpt_Result> ReportData(int page, int size, int supType, int sup, string stock, int country, int market)
        {
            return contextSub.V3_Supplier_GetListRpt(page, size, supType, sup, stock, country, market, 1).ToList();
        } 

        public SupplierViewModelBuilder GetSupplierDetailModelBuilder(int condition)
        {
            //var detail =
            //    contextSub.SupplierProduct_V.AsEnumerable().Where(
            //        s => s.iEnable == true && s.bSupplierID == condition);

            //var totalRecords = detail.Count();
            var viewModelBuilder = new SupplierViewModelBuilder
            {
                //SupplierProductVs = detail,
                //TotalRecords = totalRecords
            };

            return viewModelBuilder;
        }

        public SupplierViewModelBuilder GetViewModelItemBuilder(int? condition)
        {
            if (condition.HasValue)
            {
                var item = contextSub.WAMS_SUPPLIER.FirstOrDefault(s => s.iEnable == true && s.bSupplierID == condition);
                //var itemDetailList =
                //    contextSub.SupplierProduct_V.AsEnumerable().Where(
                //        s => s.iEnable == true && s.bSupplierID == condition);
                //var totalRecords = itemDetailList.Count();
                if (item != null)
                {
                    var viewModelBuilder = new SupplierViewModelBuilder
                    {
                        //SupplierV = item,
                        //supplierProductV = new SupplierProduct_V(),
                        //SupplierProductVs = itemDetailList,
                        //TotalRecords = totalRecords,
                        Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                        Countries = new SelectList(contextSub.V3_GetCountryDDL(), "Id", "NameNice"),
                        Types = new SelectList(contextSub.V3_GetStockTypeDDL(), "bSupplierTypeID", "vSupplierTypeName")
                    };
                    return viewModelBuilder;
                }
            }
            else
            {
                var viewModelBuilder = new SupplierViewModelBuilder
                {
                    //SupplierV = new Supplier_V(),
                    //supplierProductV = new SupplierProduct_V(),
                    Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                    Countries = new SelectList(contextSub.V3_GetCountryDDL(), "Id", "NameNice"),
                    Types = new SelectList(contextSub.V3_GetStockTypeDDL(), "bSupplierTypeID", "vSupplierTypeName")
                };
                return viewModelBuilder;
            }

            return null;
        }

        public bool CheckCurrent(string condition)
        {
            var supplier = contextSub.WAMS_SUPPLIER.SingleOrDefault(s => s.vSupplierName.ToUpper().Equals(condition.ToUpper()));
            if (supplier != null)
            {
                return false;
            }

            return true;
        }

        public WAMS_SUPPLIER GetSupplier(int condition)
        {
            return contextSub.WAMS_SUPPLIER.First(s => s.bSupplierID == condition);
        }

        public WAMS_PRODUCT GetProductById(int condition)
        {
            return contextSub.WAMS_PRODUCT.FirstOrDefault(s => s.ID == condition);
        }

        public bool CheckDelete(int id)
        {
            var po = contextSub.WAMS_PURCHASE_ORDER.Count(s => s.bSupplierID == id);
            if (po > 0)
            {
                return false;
            }

            return true;
        }

        public bool DeleteDetail(int condition)
        {
            contextSub.Database.ExecuteSqlCommand("DELETE FROM WAMS_PRODUCT WHERE bSupplierID = {0}", condition);
            return true;
        }

        #region Search Product
        public StockViewModelBuilder GetStockSearchViewModelBuilder()
        {
            var viewModel = new StockViewModelBuilder
            {
                Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Types = new SelectList(contextSub.V3_GetStockTypeDDL(), "Id", "vTypeName"),
                Categories = new SelectList(contextSub.V3_GetStockCategoryDDL(null), "bCategoryID", "vCategoryName"),
                Units = new SelectList(contextSub.V3_GetStockUnitDDL(null), "bUnitID", "vUnitName"),
                Positions = new SelectList(contextSub.V3_GetStockPositionDDL(), "bPositionID", "vPositionName"),
                Labels = new SelectList(contextSub.V3_GetStockLabelDDL(null), "bLabelID", "vLabelName"),
            };
            return viewModel;
        }

        public StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int pageSize, string ids, int? storeId, int? typeId, int? cate, string stockCode)
        {
            //var lstProduct = contextSub.Stock_V.AsEnumerable().Where(s => s.iEnable == true);
            //IEnumerable<Store_V> stores;

            //#region Condtion
            //if (storeId.HasValue && storeId.Value != 1)
            //{
            //    stores = contextSub.Store_V.AsEnumerable().Where(st => st.iEnable == true && st.Id == storeId);
            //}
            //else
            //{
            //    stores = contextSub.Store_V.AsEnumerable().Where(st => st.iEnable == true && st.sName != "All");
            //}

            //if (!string.IsNullOrEmpty(ids))
            //{
            //    var lstId = ids.Split(';').Select(int.Parse).ToList();

            //    lstProduct = from rep in lstProduct
            //                 where (!lstId.Contains(rep.Id))
            //                 select rep;
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
            //        //StoreVs = stores
            //    };
            //    return viewModelBuilder;
            //}

            return null;
        }

        #endregion
    }
}