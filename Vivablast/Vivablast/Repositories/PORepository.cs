namespace Vivablast.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Data.Objects;
    using System.Globalization;
    using System.Linq;
    using System.Web.Mvc;

    using Vivablast.Models;
    using Vivablast.Repositories.Interfaces;
    using Vivablast.ViewModels.Builders;

    public class PORepository : Repository<WAMS_PURCHASE_ORDER>, IPORepository
    {
        private readonly V3Entities contextSub;

        public PORepository()
        {
            this.contextSub = new V3Entities();
        }

        public POViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new POViewModelBuilder
            {
                Stores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                PoTypes = new SelectList(this.contextSub.WAMS_PO_TYPE.OrderBy(s => s.vPOTypeName), "bPOTypeID", "vPOTypeName"),
                Suppliers = new SelectList(this.contextSub.V3_GetSupplierDDL(), "bSupplierID", "vSupplierName"),
                Projects = new SelectList(this.contextSub.V3_GetProjectDDL(), "Id", "vProjectID")
            };

            return viewModelBuilder;
        }

        public POViewModelBuilder GetPurchaseOrderViewModelBuilder(int page, int size, int store, int ptype, string po, int sup, int pro, string stock, string fd, string td)
        {
           var output = new ObjectParameter("ItemCount", typeof(int));
            var data = contextSub.V3_PO_GetList(page, size, store, ptype, po, sup, pro, stock, fd, td, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));

            var viewModel = new POViewModelBuilder
            {
                PoGetListResults = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }

        public POViewModelBuilder GetPODetailModelBuilder(int condition)
        {
            var poDetail = contextSub.V3_GetPO_DETAILS_V(condition).ToList();

            var totalRecords = poDetail.Count();
            var viewModelBuilder = new POViewModelBuilder
            {
                PoDetailsVResults = poDetail,
                TotalRecords = totalRecords
            };

            return viewModelBuilder;
        }

        public List<V3_PO_GetListRpt_Result> ReportData(int page, int size, int store, int ptype, string po, int sup, int pro, string stock, string fd, string td)
        {
            return contextSub.V3_PO_GetListRpt(page, size, store, ptype, po, sup, pro, stock, fd, td).ToList();
        }


        //public POViewModelBuilder GetPODetailModelBuilder(int condition)
        //{
        //    //var temp = poId.Replace("x", "/");

        //    var poDetail = this.contextSub.PODETAIL_V.AsEnumerable().Where(s => s.iEnable == true && s.vPOID == condition);

        //    var totalRecords = poDetail.Count();
        //    var viewModelBuilder = new POViewModelBuilder
        //    {
        //        PodetailVs = poDetail,
        //        TotalRecords = totalRecords
        //    };

        //    return viewModelBuilder;
        //}


        // CHECKED LATER
        public POViewModelBuilder GetViewModelItemBuilder(int? condition)
        {
            if (condition.HasValue)
            {
                var item = contextSub.V3_PO_GetInformation(condition).First();
                var itemDetailList = contextSub.V3_GetPO_DETAILS_V(condition).ToList();
                var totalRecords = itemDetailList.Count();
                if (item != null)
                {
                    var viewModelBuilder = new POViewModelBuilder
                        {
                            PoGetInformation = item,
                            // PodetailV = new PODETAIL_V(),
                            PoDetailsVResults = itemDetailList,
                            TotalRecords = totalRecords,
                            Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                            Projects = new SelectList(contextSub.V3_GetProjectDDL(), "Id", "vProjectID"),
                            PoTypes = new SelectList(contextSub.WAMS_PO_TYPE.OrderBy(s => s.vPOTypeName), "bPOTypeID", "vPOTypeName"),
                            Currencies = new SelectList(contextSub.WAMS_CURRENCY_TYPE.OrderBy(s => s.vCurrencyName), "bCurrencyTypeID", "vCurrencyName"),
                            Payments = new SelectList(contextSub.PaymentTerms.OrderBy(s => s.PaymentName), "Id", "PaymentName"),
                            Suppliers = new SelectList(contextSub.V3_GetSupplierDDL(), "bSupplierID", "vSupplierName"),
                            poCode = item.PE
                        };
                    return viewModelBuilder;
                }
            }
            else
            {
                var viewModelBuilder = new POViewModelBuilder
                {
                    PoGetInformation = new V3_PO_GetInformation_Result(),
                    //PodetailV = new PODETAIL_V(),
                    Stores = new SelectList(contextSub.V3_GetStoreDDL(), "Id", "sName"),
                    Projects = new SelectList(contextSub.V3_GetProjectDDL(), "Id", "vProjectID"),
                    PoTypes = new SelectList(this.contextSub.WAMS_PO_TYPE.OrderBy(s => s.vPOTypeName), "bPOTypeID", "vPOTypeName"),
                    Currencies = new SelectList(this.contextSub.WAMS_CURRENCY_TYPE.OrderBy(s => s.vCurrencyName), "bCurrencyTypeID", "vCurrencyName"),
                    Payments = new SelectList(this.contextSub.PaymentTerms.OrderBy(s => s.PaymentName), "Id", "PaymentName"),
                    Suppliers =
                        new SelectList(
                        this.contextSub.V3_GetSupplierDDL(), "bSupplierID", "vSupplierName"),
                    poCode = this.GetAutoPoCode()
                };
                return viewModelBuilder;
            }

            return null;
        }

        public bool CheckCurrent(string condition)
        {
            var po = this.contextSub.WAMS_PURCHASE_ORDER.SingleOrDefault(s => s.vPOID.ToUpper().Equals(condition.ToUpper()));
            if (po != null)
            {
                return false;
            }

            return true;
        }

        public bool CheckDelete(int condition)
        {
            var fulfillment = this.contextSub.WAMS_FULFILLMENT_DETAIL.Count(s => s.vPOID == condition);
            if (fulfillment > 0)
            {
                return false;
            }

            return true;
        }

        public string GetAutoPoCode()
        {
            var monthTemp = string.Empty; 
            var yearTemp = DateTime.Today.Year.ToString(CultureInfo.InvariantCulture);
            switch (DateTime.Today.Month)
            {
                case 1:
                    monthTemp = "JAN";
                    break;
                case 2:
                    monthTemp = "FEB";
                    break;
                case 3:
                    monthTemp = "MAR";
                    break;
                case 4:
                    monthTemp = "APR";
                    break;
                case 5:
                    monthTemp = "MAY";
                    break;
                case 6:
                    monthTemp = "JUN";
                    break;
                case 7:
                    monthTemp = "JUL";
                    break;
                case 8:
                    monthTemp = "AUG";
                    break;
                case 9:
                    monthTemp = "SEP";
                    break;
                case 10:
                    monthTemp = "OCT";
                    break;
                case 11: 
                    monthTemp = "NOV"; 
                    break;
                case 12: 
                    monthTemp = "DEC"; 
                    break;
            }

            yearTemp = yearTemp.Substring(2);
            var codeTemp = monthTemp + "/" + yearTemp + "/";

            var condition = monthTemp + "/" + yearTemp + "/";
            var po = this.contextSub.V3_GetPoId_Lastest(condition).ToList();

            if (po.Count == 0)
            {
                codeTemp += "0001";
            }
            else
            {
                var intMaxOrderNo = Convert.ToInt32(po.First().Code);
                intMaxOrderNo++;
                var intOrderNoLength = intMaxOrderNo.ToString(CultureInfo.InvariantCulture).Length;
                var orderNo = string.Empty;
                for (var i = intOrderNoLength; i < 4; i++)
                {
                    orderNo += "0";
                }
                    
                orderNo += intMaxOrderNo.ToString(CultureInfo.InvariantCulture);

                codeTemp += orderNo;
            }

            return codeTemp;
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
                Positions = new SelectList(contextSub.V3_GetStockPositionDDL(), "bPositionID", "vPositionName"),
                Labels = new SelectList(this.contextSub.V3_GetStockLabelDDL(null), "bLabelID", "vLabelName"),
            };
            return viewModel;
        }

        public StockViewModelBuilder GetLstProductSearchViewModelBuilder(int page, int pageSize, int supId, string ids, int? storeId, int? typeId, int? cate, string stockCode)
        {
            //var lstProduct = this.contextSub.SearchProduct_V.AsEnumerable().Where(s => s.iEnable == true && s.SupplierId == supId);

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
            //        //ProductVs = lstProduct,
            //        //StoreVs = stores
            //    };
            //    return viewModelBuilder;
            //}

            return null;
        }

        public List<V3_GetPrice_Result> GetPriceForProduct(int stockId, int storeId, int curency)
        {
            return contextSub.V3_GetPrice(stockId, storeId, curency).ToList();
        }

        public List<V3_GetMRF_Result> GetMrfForProduct(int stockId, int storeId)
        {
            return contextSub.V3_GetMRF(stockId, storeId).ToList();
        }
        #endregion

        public string ComparePo(string condition)
        {
            var wamsPo = this.contextSub.WAMS_PURCHASE_ORDER.Where(u => u.vPOID == condition);
            if (wamsPo.Count() != 0)
            {
                return wamsPo.First().vPOID;
            }

            return null;
        }

        public WAMS_PURCHASE_ORDER GetPo(int condition)
        {
            return this.contextSub.WAMS_PURCHASE_ORDER.FirstOrDefault(s => s.Id == condition);
        }

        public WAMS_PO_DETAILS GetPoDetailById(int condition)
        {
            return this.contextSub.WAMS_PO_DETAILS.FirstOrDefault(s => s.ID == condition);
        }

        public bool DeleteDetail(int condition)
        {
            this.contextSub.Database.ExecuteSqlCommand("DELETE FROM WAMS_PO_DETAILS WHERE vPOId = {0}", condition);
            return true;
        }
    }
}
