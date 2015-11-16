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

    public class AssignRepository : Repository<WAMS_ASSIGNNING_STOCKS>, IAssignRepository
    {
        private readonly V3Entities contextSub;

        public AssignRepository()
        {
            this.contextSub = new V3Entities();
        }

        public AssignViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new AssignViewModelBuilder
            {
                Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Projects = new SelectList(contextSub.V3_GetProjectDDL(), "Id", "vProjectName"),
                StockTypes = new SelectList(contextSub.V3_GetStockTypeDDL(), "Id", "vTypeName")
            };

            return viewModelBuilder;
        }

        public AssignViewModelBuilder GetViewModelAssignList(int page, int size, int store, int pro, int stype, string stock, string siv, string fd, string td)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = contextSub.V3_AssignStock_GetList(page, size, store, pro, stype, stock, siv, string.Empty, fd, td, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
           
            var viewModel = new AssignViewModelBuilder
                {
                    V3AssignStockGetListResults = data,
                    TotalRecords = Convert.ToInt32(totalRecord),
                    TotalPages = totalPages,
                    CurrentPage = page,
                    PageSize = size
                };

            return viewModel;
        }

        public List<V3_AssignStock_GetListRpt_Result> ReportData(int page, int size, int store, int pro, int stype, string stock, string siv, string fd, string td)
        {
            return contextSub.V3_AssignStock_GetListRpt(page, size, store, pro, stype, stock, siv, string.Empty, fd, td).ToList();
        }


        public AssignViewModelBuilder GetViewModelItemBuilder(string siv)
        {
            var totalRecords = 0;
            if (!string.IsNullOrEmpty(siv))
            {
                var itemDetailList = this.contextSub.V3_GetAssignedStockBySIV(siv).ToList();
                totalRecords = itemDetailList.Count();

                var viewModelBuilder = new AssignViewModelBuilder
                {
                    Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                    Projects = new SelectList(this.contextSub.V3_GetProjectDDL(), "Id", "vProjectName"),
                    AssignedStockBySivResults = itemDetailList,
                    TotalRecords = totalRecords,
                    Siv = siv
                };
                return viewModelBuilder;
            }
            else
            {
                var viewModelBuilder = new AssignViewModelBuilder
                {
                    AssignStock = new WAMS_ASSIGNNING_STOCKS(),
                    Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                    Projects = new SelectList(this.contextSub.V3_GetProjectDDL(), "Id", "vProjectName"),
                    TotalRecords = totalRecords,
                    Siv = string.Empty
                };
                return viewModelBuilder;
            }
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
                Labels = new SelectList(this.contextSub.V3_GetStockLabelDDL(0), "bLabelID", "vLabelName")
            };
            return viewModel;
        }

        public StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int size, string search, string store, int type, int category)
        {
            #region SetDefaultValue
            if (String.IsNullOrEmpty(search))
            {
                search = string.Empty;
            }

            if (String.IsNullOrEmpty(store))
            {
                store = string.Empty;
            }
            #endregion

            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = this.contextSub.V3_Stock_GetList(page, size, "1", store, type, category, search, output).ToList();

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
                PageSize = size
            };

            return viewModel;
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

        public WAMS_ASSIGNNING_STOCKS GetAssignedById(int id)
        {
            return this.contextSub.WAMS_ASSIGNNING_STOCKS.First(s => s.bAssignningStockID.Equals(id));
        }

        public string GetSiv()
        {
            var currentSiv = this.contextSub.V3_GetSIVLastest().First().NumSIV;
            var siv = string.Empty;
            var sivNo = string.Empty;
            var year = DateTime.Now.ToString("yy");
            siv += year;

            if (string.IsNullOrEmpty(currentSiv))
            {
                siv += "000001";
            }
            else
            {
                var maxNo = Convert.ToInt32(currentSiv);
                maxNo++;
                var noLength = maxNo.ToString(CultureInfo.InvariantCulture).Length;
                for (var i = noLength; i < 6; i++)
                {
                    sivNo += "0";
                }

                sivNo += maxNo.ToString(CultureInfo.InvariantCulture);
                siv += sivNo;
            }

            // insert into SIV
            // sucess return siv, if no insert more + 1 to sucess
            this.contextSub.V3_SIV_Insert(siv, "A");
            return siv;
        }

        public void InsertAssign(WAMS_ASSIGNNING_STOCKS entity)
        {
            this.contextSub.V3_ASSIGNSTOCK_Insert(
                entity.vStockID,
                entity.vProjectID,
                entity.bQuantity,
                entity.vWorkerID,
                entity.SIV,
                entity.vMRF,
                entity.FromStore,
                entity.ToStore,
                entity.dCreated,
                entity.iCreated);
        }
    }
}
