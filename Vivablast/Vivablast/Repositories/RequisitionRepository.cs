namespace Vivablast.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.Objects;
    using System.Globalization;
    using System.Linq;
    using System.Web.Mvc;

    using Vivablast.Common;
    using Vivablast.Models;
    using Vivablast.Repositories.Interfaces;
    using Vivablast.ViewModels.Builders;

    public class RequisitionRepository : Repository<WAMS_REQUISITION_MASTER>, IRequisitionRepository
    {
        private readonly V3Entities contextSub;

        public RequisitionRepository()
        {
            this.contextSub = new V3Entities();
        }

        public RequisitionViewModelBuilder GetViewModelIndex()
        {
            var reViewModelBuilder = new RequisitionViewModelBuilder
            {
                Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName")
            };

            return reViewModelBuilder;
        }

        public RequisitionViewModelBuilder GetRequisitionViewModelBuilder(int page, int size, int store, string mrf, string stock, string status, string fd, string td)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = this.contextSub.V3_Requisition_GetList(page, size, store, mrf, stock, status, fd, td, 1, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));

            var viewModel = new RequisitionViewModelBuilder
            {
                RequisitionGetListResults = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }

        public List<V3_Requisition_GetListRpt_Result> ReportData(int page, int size, int store, string mrf, string stock, string status, string fd, string td)
        {
            return contextSub.V3_Requisition_GetListRpt(page, size, store, mrf, stock, status, fd, td, 1).ToList();
        } 

        public RequisitionViewModelBuilder GetRequisitionDetailModelBuilder(string condition)
        {
            var requisitionDetail = this.contextSub.V3_RequisitionDetail(condition, 1).ToList();

            var totalRecords = requisitionDetail.Count();
            var requisitionViewModelBuilder = new RequisitionViewModelBuilder
            {
                RequisitionDetailResults = requisitionDetail,
                TotalRecords = totalRecords
            };

            return requisitionViewModelBuilder;
        }

        //checked later
        public RequisitionViewModelBuilder GetViewModelItemBuilder(string condition)
        {
            if (!string.IsNullOrEmpty(condition))
            {
                //var item = this.contextSub.REQUISITION_MASTER_V.FirstOrDefault(s => s.iEnable == true && s.vMRF == condition);
                //var itemDetailList = this.contextSub.V3_RequisitionDetail(condition, 1).ToList();
                //var totalRecords = itemDetailList.Count();
                var viewModelBuilder = new RequisitionViewModelBuilder
                {
                    //RequisitionMasterV = item,
                    //RequisitionDetailsV = new REQUISITION_DETAILS_V(),
                    //RequisitionDetailsVs = itemDetailList,
                    //TotalRecords = totalRecords,
                    Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                    Projects = new SelectList(this.contextSub.V3_GetProjectDDL(), "Id", "vProjectID"),
                    Mrf = condition
                };
                return viewModelBuilder;
            }

            var re = this.contextSub.WAMS_REQUISITION_MASTER.OrderByDescending(u => u.vMRF).FirstOrDefault();
            if (re != null)
            {
                var viewModelBuilder = new RequisitionViewModelBuilder
                    {
                        //RequisitionMasterV = new REQUISITION_MASTER_V(),
                        //RequisitionDetailsV = new REQUISITION_DETAILS_V(),
                        Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                        Projects = new SelectList(this.contextSub.V3_GetProjectDDL(), "Id", "vProjectID"),
                        Mrf = (Convert.ToInt32(re.vMRF) + 1).ToString(CultureInfo.InvariantCulture)
                    };
                return viewModelBuilder;
            }

            return null;
        }

        public WAMS_REQUISITION_DETAILS GetRequisitionDetailById(int condition)
        {
            return this.contextSub.WAMS_REQUISITION_DETAILS.FirstOrDefault(s => s.ID == condition);
        }

        public WAMS_REQUISITION_MASTER GetRequisitionMaster(int condition)
        {
            return this.contextSub.WAMS_REQUISITION_MASTER.FirstOrDefault(s => s.Id == condition);
        }

        public string CompareMRF(string condition)
        {
            var wamsRequisitionMaster = this.contextSub.WAMS_REQUISITION_MASTER.FirstOrDefault(u => u.vMRF == condition);
            return wamsRequisitionMaster != null ? wamsRequisitionMaster.vMRF : null;
        }

        public bool CheckCurrent(int condition)
        {
            return true;
        }

        public bool CheckDelete(int condition)
        {
            var po = this.contextSub.WAMS_PO_DETAILS.Count(s => s.vMRF == condition);
            if (po > 0)
            {
                return false;
            }

            return true;
        }

        public bool DeleteDetail(int condition)
        {
            this.contextSub.Database.ExecuteSqlCommand("DELETE FROM WAMS_REQUISITION_DETAILS WHERE vMRF = {0}", condition);
            return true;
        }

        #region Search Product
        public StockViewModelBuilder GetProductSearchViewModelBuilder()
        {
            var viewModel = new StockViewModelBuilder
            {
                Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Types = new SelectList(this.contextSub.V3_GetStockTypeDDL(), "Id", "vTypeName"),
                Categories = new SelectList(this.contextSub.V3_GetStockCategoryDDL(0), "bCategoryID", "vCategoryName"),
                Units = new SelectList(this.contextSub.V3_GetStockUnitDDL(0), "bUnitID", "vUnitName"),
                Positions = new SelectList(this.contextSub.V3_GetStockPositionDDL(), "bPositionID", "vPositionName"),
                Labels = new SelectList(this.contextSub.V3_GetStockLabelDDL(0), "bLabelID", "vLabelName"),
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
            //        //StoreVs = stores
            //    };
            //    return viewModelBuilder;
            //}

            return null;
        }

        //public Stock_V GetStockInformation(string condition, int sT)
        //{
        //    var stock = this.contextSub.Stock_V.First(s => s.vStockID == condition && s.iEnable == true);
        //    if (stock != null && !string.IsNullOrEmpty(stock.Quantity))
        //    {
        //        var arrStores = stock.Stores.Trim().Split(';');
        //        var arrQuantities = stock.Quantity.Trim().Split(';');
        //        var results = Array.FindAll(arrStores, s => s.Equals(sT.ToString(CultureInfo.InvariantCulture)));
        //        if (!results.Any())
        //        {
        //            stock.Quantity = "0";
        //        }
        //        else
        //        {
        //            var i = 0;
        //            foreach (var st in arrStores)
        //            {
        //                if (sT == Convert.ToInt32(st))
        //                {
        //                    stock.Quantity = arrQuantities[i];
        //                }

        //                i++;
        //            }
        //        }
        //    }

        //    return stock;
        //}

        #endregion
    }
}
