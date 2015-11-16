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

    public class ReturnRepository : Repository<WAMS_RETURN_LIST>, IReturnRepository
    {
        private readonly V3Entities contextSub;

        public ReturnRepository()
        {
            this.contextSub = new V3Entities();
        }

        public ReturnViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new ReturnViewModelBuilder
            {
                Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Projects = new SelectList(this.contextSub.V3_GetProjectDDL(), "Id", "vProjectName"),
                StockTypes = new SelectList(this.contextSub.V3_GetStockTypeDDL(), "Id", "vTypeName")
            };

            return viewModelBuilder;
        }

        public ReturnViewModelBuilder GetViewModelAssignList(int page, int size, int store, int pro, int stype, string stock, string srv, string acc, string fd, string td)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = this.contextSub.V3_ReturnStock_GetList(page, size, store, pro, stype, stock, srv, acc, fd, td, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));

            var viewModel = new ReturnViewModelBuilder
            {
                V3ReturnStockGetListResults = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }

        public List<V3_ReturnStock_GetListRpt_Result> ReportData(int page, int size, int store, int pro, int stype, string stock, string srv, string acc, string fd, string td)
        {
            return contextSub.V3_ReturnStock_GetListRpt(page, size, store, pro, stype, stock, srv, acc, fd, td).ToList();
        }




        public ReturnViewModelBuilder GetViewModelItemBuilder(string srv)
        {
            var totalRecords = 0;
            if (!string.IsNullOrEmpty(srv))
            {
                var itemDetailList = this.contextSub.V3_GetReturnedStockBySRV(srv).ToList();
                totalRecords = itemDetailList.Count();

                var viewModelBuilder = new ReturnViewModelBuilder
                {
                    Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                    Projects = new SelectList(this.contextSub.V3_GetProjectDDL(), "Id", "vProjectName"),
                    ReturnedStockBySrvResults = itemDetailList,
                    TotalRecords = totalRecords,
                    Srv = srv
                };
                return viewModelBuilder;
            }
            else
            {
                var viewModelBuilder = new ReturnViewModelBuilder
                {
                    ReturnStock = new WAMS_RETURN_LIST(),
                    Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                    Projects = new SelectList(this.contextSub.V3_GetProjectDDL(), "Id", "vProjectName"),
                    TotalRecords = totalRecords,
                    Srv = string.Empty
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

        public WAMS_RETURN_LIST GetReturnedById(int id)
        {
            return this.contextSub.WAMS_RETURN_LIST.First(s => s.bReturnListID.Equals(id));
        }

        public string GetSrv()
        {
            var currentSrv = this.contextSub.V3_GetSRVLastest("R").First().NumSRV;
            var srv = string.Empty;
            var srvNo = string.Empty;
            srv += "R";
            var year = DateTime.Now.ToString("yy");
            srv += year;

            if (string.IsNullOrEmpty(currentSrv))
            {
                srv += "000001";
            }
            else
            {
                var maxNo = Convert.ToInt32(currentSrv);
                maxNo++;
                var noLength = maxNo.ToString(CultureInfo.InvariantCulture).Length;
                for (int i = noLength; i < 6; i++)
                {
                    srvNo += "0";
                }

                srvNo += maxNo.ToString(CultureInfo.InvariantCulture);

                srv += srvNo;
            }

            // insert into SRV
            // sucess return srv, if no insert more + 1 to sucess
            this.contextSub.V3_SRV_Insert(srv, "R");
            return srv;
        }

        public void InsertReturn(WAMS_RETURN_LIST entity)
        {
            this.contextSub.V3_RETURNSTOCK_Insert(
                entity.vStockID,
                entity.vProjectID,
                entity.bQuantity,
                entity.vCondition,
                entity.SRV,
                entity.FromStore,
                entity.ToStore,
                entity.dCreated,
                entity.iCreated);
        }
    }
}
