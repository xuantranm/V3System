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

    public class FulfillmentRepository : Repository<WAMS_FULFILLMENT_DETAIL>, IFulfillmentRepository
    {
        private readonly V3Entities contextSub;

        public FulfillmentRepository()
        {
            this.contextSub = new V3Entities();
        }

        public FulfillmentViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new FulfillmentViewModelBuilder
            {
                Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                PoTypes =
                    new SelectList(this.contextSub.WAMS_PO_TYPE.OrderBy(s => s.vPOTypeName), "bPOTypeID", "vPOTypeName"),
                Suppliers =
                    new SelectList(
                    this.contextSub.V3_GetSupplierDDL(),
                    "bSupplierID",
                    "vSupplierName"),
                Projects =
                    new SelectList(
                    this.contextSub.V3_GetProjectDDL(),
                    "Id",
                    "vProjectName")
            };

            return viewModelBuilder;
        }

        //public IEnumerable<PoFulfill_DDL_V> PoDdlVs(string year, int month)
        //{
        //    return
        //        this.contextSub.PoFulfill_DDL_V.AsEnumerable().Where(p => p.yYear == year && p.Month_Order == month)
        //            .OrderByDescending(p => p.yYear).ThenByDescending(p => p.Month_Order).ThenByDescending(p => p.vPOID);
        //}

        //public IEnumerable<PoFromSupplier_DDL_V> PoFromSupplierDdlVs(int suppId, int storeId)
        //{
        //    return
        //        this.contextSub.PoFromSupplier_DDL_V.AsEnumerable().Where(p => p.bSupplierID == suppId && p.iStore == storeId && p.vPOStatus == "Open")
        //            .OrderByDescending(p => p.yYear).ThenByDescending(p => p.Month_Order).ThenByDescending(p => p.vPOID);
        //}

        public FulfillmentViewModelBuilder LoadDataList(int page, int size, int store, int poType, string po, int sup, string srv, string stock, string fd, string td)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = this.contextSub.V3_StockIn_GetList(page, size, store, poType, po, sup, srv, stock, fd, td, 1, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
  

            var viewModel = new FulfillmentViewModelBuilder
            {
                FulfillmentVs = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }

        public List<V3_StockIn_GetListRpt_Result> ReportData(int page, int size, int store, int poType, string po, int sup, string srv, string stock, string fd, string td)
        {
            return this.contextSub.V3_StockIn_GetListRpt(page, size, store, poType, po, sup, srv, stock, fd, td, 1).ToList();
        } 

        public FulfillmentViewModelBuilder GetViewModelItemBuilder(int? condition)
        {
            //if (condition.HasValue)
            //{
            //    var item = this.contextSub.Fulfillment_V.Where(s => s.iEnable == true && s.vPOID == condition);
            //    {
            //        var viewModelBuilder = new FulfillmentViewModelBuilder
            //            {
            //                FulfillmentVs = item,
            //                Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
            //                Suppliers = new SelectList(this.contextSub.SupplierForFulfill_DDL_V.OrderBy(s => s.vSupplierName), "bSupplierID", "vSupplierName")
            //            };
            //        return viewModelBuilder;
            //    }
            //}
            //else
            //{
                var viewModelBuilder = new FulfillmentViewModelBuilder
                {
                    PurchaseOrder = new WAMS_PURCHASE_ORDER(),
                    //Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                    //Suppliers =
                    //    new SelectList(
                    //    this.contextSub.SupplierForFulfill_DDL_V.OrderBy(s => s.vSupplierName), "bSupplierID", "vSupplierName")
                };
                return viewModelBuilder;
            //}
        }

        public bool CheckDelete(int condition)
        {
            return true;
        }

        public bool DeleteDetail(int condition)
        {
            // this.contextSub.Database.ExecuteSqlCommand("DELETE FROM WAMS_PO_DETAILS WHERE vPOId = {0}", condition);
            return true;
        }

        public WAMS_FULFILLMENT_DETAIL GetFulfillmentDetailById(int condition)
        {
            return this.contextSub.WAMS_FULFILLMENT_DETAIL.First(s => s.ID == condition);
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

        public StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int pageSize, int poId, string ids, int? storeId, int? typeId, int? cate, string stockCode)
        {
            //var lstProduct = this.contextSub.SearchProductForFulfill_V.AsEnumerable().Where(s => s.iEnable == true && s.PoId == poId);
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
            //        //ProductForFulfillVs = lstProduct,
            //        //StoreVs = stores
            //    };
            //    return viewModelBuilder;
            //}

            return null;
        }
        
        #endregion

        public V3_GetSRVLastest_Result GetSrvLastest()
        {
            return this.contextSub.V3_GetSRVLastest("F").First();
        }
    }
}
