using System.Collections.Generic;
using Vivablast.Models;

namespace Vivablast.Controllers
{
    using System;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Web.Mvc;
    using Ap.Business.Domains;
    using Ap.Service.Seedworks;
    using log4net;
    using NPOI.HSSF.UserModel;
    using NPOI.SS.UserModel;
    using ViewModels;
    using Constants = Ap.Common.Constants.Constants;

    [Authorize]
    public class PeController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(PeController).FullName);

        private readonly ISystemService _systemService;
        private readonly IPOService _service;
        private readonly ISupplierService _supplierService;

        public PeController(ISystemService systemService, IPOService service, ISupplierService supplierService)
        {
            _systemService = systemService;
            _service = service;
            _supplierService = supplierService;
        }

        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.PER == 0) return RedirectToAction("Index", "Home");
            var model = new POViewModel
            {
                UserLogin = user,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Projects = new SelectList(_systemService.ProjectList(), "Id", "vProjectID"),
                PoTypes = new SelectList(this._systemService.PoTypeList(), "Id", "Name"),
                Suppliers = new SelectList(this._systemService.SupplierList(), "Id", "Name"),
            };
            return View(model);
        }

        #region Load Condition & Autocomplete
        public ActionResult ListCode(string term)
        {
            return Json(_service.ListCode(term), JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListPayment(string term)
        {
            return Json(_service.ListPayment(term), JsonRequestBehavior.AllowGet);
        }

        public JsonResult LoadPrice(int stock, int store, int currency)
        {
            var objType = _systemService.PriceList(stock, store, currency);
            var obgType = new SelectList(objType, "Id", "Value", 0);
            return Json(obgType);
        }

        public JsonResult LoadMrfByStock(int stock, int store)
        {
            var objType = _systemService.RequisitionByStockList(stock, store);
            var obgType = new SelectList(objType, "Id", "Code", 0);
            return Json(obgType);
        }

        public JsonResult LoadPaymentTypeBySupplier(int supplier)
        {
            var objType = _systemService.PaymentTypeBySupplier(supplier) ?? string.Empty;
            return Json(objType);
        }
        #endregion

        public ActionResult LoadPo(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var xPeViewModel = _service.ListCondition(page, size, store, potype, po, status, mrf, supplier, project, stockCode, stockName, fd, td, enable);
            var totalTemp = Convert.ToDecimal(xPeViewModel.TotalRecords) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new POViewModel
            {
                UserLogin = _systemService.GetUserAndRole(0, userName),
                PoGetListResults = xPeViewModel.PoGetListResults,
                TotalRecords = xPeViewModel.TotalRecords,
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return PartialView("_POPartial", model);
        }

        public ActionResult LoadPeDetail(int id, string enable)
        {
            var detailList = _service.ListConditionDetail(id, enable);
            var model = new POViewModel
            {
                PoDetailsVResults = detailList,
                TotalRecords = detailList.Count()
            };

            return PartialView("_PODetailPartial", model);
        }

        public void ExportToExcel(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable)
        {
            // Get the data to report on
            var masters = _service.ListCondition(page, size, store, potype, po, status, mrf, supplier, project, stockCode, stockName, fd, td, enable).PoGetListResults;
            var details = _service.ListConditionDetailExcel(page, size, store, potype, po, status, mrf, supplier, project, stockCode, stockName, fd, td, enable);
            // Create a new workbook
            var workbook = new HSSFWorkbook();

            #region Cell Styles
            #region HeaderLabel Cell Style
            var headerLabelCellStyle = workbook.CreateCellStyle();
            headerLabelCellStyle.Alignment = HorizontalAlignment.CENTER;
            headerLabelCellStyle.BorderBottom = CellBorderType.THIN;
            var headerLabelFont = workbook.CreateFont();
            headerLabelFont.Boldweight = (short)FontBoldWeight.BOLD;
            headerLabelCellStyle.SetFont(headerLabelFont);
            #endregion

            #region RightAligned Cell Style
            var rightAlignedCellStyle = workbook.CreateCellStyle();
            rightAlignedCellStyle.Alignment = HorizontalAlignment.RIGHT;
            #endregion

            #region Currency Cell Style
            var currencyCellStyle = workbook.CreateCellStyle();
            currencyCellStyle.Alignment = HorizontalAlignment.RIGHT;
            var formatId = HSSFDataFormat.GetBuiltinFormat("$#,##0.00");
            if (formatId == -1)
            {
                var newDataFormat = workbook.CreateDataFormat();
                currencyCellStyle.DataFormat = newDataFormat.GetFormat("$#,##0.00");
            }
            else
                currencyCellStyle.DataFormat = formatId;
            #endregion

            #region Detail Subtotal Style
            var detailSubtotalCellStyle = workbook.CreateCellStyle();
            detailSubtotalCellStyle.BorderTop = CellBorderType.THIN;
            detailSubtotalCellStyle.BorderBottom = CellBorderType.THIN;
            var detailSubtotalFont = workbook.CreateFont();
            detailSubtotalFont.Boldweight = (short)FontBoldWeight.BOLD;
            detailSubtotalCellStyle.SetFont(detailSubtotalFont);
            #endregion

            #region Detail Currency Subtotal Style
            var detailCurrencySubtotalCellStyle = workbook.CreateCellStyle();
            detailCurrencySubtotalCellStyle.BorderTop = CellBorderType.THIN;
            detailCurrencySubtotalCellStyle.BorderBottom = CellBorderType.THIN;
            var detailCurrencySubtotalFont = workbook.CreateFont();
            detailCurrencySubtotalFont.Boldweight = (short)FontBoldWeight.BOLD;
            detailCurrencySubtotalCellStyle.SetFont(detailCurrencySubtotalFont);
            formatId = HSSFDataFormat.GetBuiltinFormat("$#,##0.00");
            if (formatId == -1)
            {
                var newDataFormat = workbook.CreateDataFormat();
                detailCurrencySubtotalCellStyle.DataFormat = newDataFormat.GetFormat("$#,##0.00");
            }
            else
                detailCurrencySubtotalCellStyle.DataFormat = formatId;
            #endregion
            #endregion

            #region Master sheet
            var sheet = workbook.CreateSheet("Main");

            // Add header labels
            var rowIndex = 0;

            // Undestand as row in excel. row + 3 = xuong 3 row.
            var row = sheet.CreateRow(rowIndex);
            var cell = row.CreateCell(0);
            cell.SetCellValue("No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("PE Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("PE Type");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("PE Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Project Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Project Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Supplier");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("PE Total");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Currency");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Status");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("Term of Payment");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(11);
            cell.SetCellValue("Remark");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(12);
            cell.SetCellValue("Price Eval");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(13);
            cell.SetCellValue("Quanlity Eval");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(14);
            cell.SetCellValue("Delivery Eval");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(15);
            cell.SetCellValue("Comformancy to V3");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(16);
            cell.SetCellValue("Created Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(17);
            cell.SetCellValue("Created By");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(18);
            cell.SetCellValue("Modified Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(19);
            cell.SetCellValue("Modified By");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            foreach (var item in masters)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(item.No.ToString());
                row.CreateCell(1).SetCellValue(item.PE);
                row.CreateCell(2).SetCellValue(item.Type);
                row.CreateCell(3).SetCellValue(item.PE_Date.ToString("dd/MM/yyyy"));
                row.CreateCell(4).SetCellValue(item.Project_Code);
                row.CreateCell(5).SetCellValue(item.Project_Name);
                row.CreateCell(6).SetCellValue(item.Supplier);
                row.CreateCell(7).SetCellValue(item.Total.ToString());
                row.CreateCell(8).SetCellValue(item.Currency);
                row.CreateCell(9).SetCellValue(item.Status);
                row.CreateCell(10).SetCellValue(item.Payment_Term);
                row.CreateCell(11).SetCellValue(item.Remark);
                row.CreateCell(12).SetCellValue(item.PriceEval);
                row.CreateCell(13).SetCellValue(item.QuanlityEval);
                row.CreateCell(14).SetCellValue(item.DeliveryEval);
                row.CreateCell(15).SetCellValue(item.Comformancy);
                row.CreateCell(16).SetCellValue(item.Created_Date != null
                                                   ? item.Created_Date.Value.ToString("dd/MM/yyyy")
                                                   : item.Created_Date.ToString());
                row.CreateCell(17).SetCellValue(item.Created_By);
                row.CreateCell(18).SetCellValue(item.Modified_Date != null
                                                   ? item.Modified_Date.Value.ToString("dd/MM/yyyy")
                                                   : item.Modified_Date.ToString());
                row.CreateCell(19).SetCellValue(item.Modified_By);
                rowIndex++;
            }

            // Auto-size each column
            for (var i = 0; i < sheet.GetRow(0).LastCellNum; i++)
            {
                sheet.AutoSizeColumn(i);

                // Bump up with auto-sized column width to account for bold headers
                sheet.SetColumnWidth(i, sheet.GetColumnWidth(i) + 1024);
            }


            // Add row indicating date/time report was generated...
            sheet.CreateRow(rowIndex + 1).CreateCell(0).SetCellValue("Report generated on " + DateTime.Now.ToString("dd/MM/yyyy"));

            #endregion


            #region Detail sheet
            sheet = workbook.CreateSheet("Details");

            #region Add header labels
            rowIndex = 0;
            row = sheet.CreateRow(rowIndex);

            cell = row.CreateCell(0);
            cell.SetCellValue("PE Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("Stock Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("Stock Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Stock Type");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Quantity");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Price Unit");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("VAT");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Discount");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Import Tax");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Price");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("MRF");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(11);
            cell.SetCellValue("Delivery Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(12);
            cell.SetCellValue("Status");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(13);
            cell.SetCellValue("Unit");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(14);
            cell.SetCellValue("Category");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(15);
            cell.SetCellValue("Part No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(16);
            cell.SetCellValue("Ral No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(17);
            cell.SetCellValue("Color");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;
            #endregion

            // Add data rows
            var lastProductName = string.Empty;

            // For sum in excel
            // var startRowIndexForProductDetails = 1;
            foreach (var detail in details)
            {
                // Show a summary row for each new product
                var productNameToShow = string.Empty;
                if (string.Compare(detail.PE, lastProductName) != 0)
                {
                    if (!string.IsNullOrEmpty(lastProductName))
                    {
                        // Add the subtotal row
                        // AddSubtotalRow(sheet, startRowIndexForProductDetails, rowIndex, detailSubtotalCellStyle, detailCurrencySubtotalCellStyle);
                        // rowIndex += 3;
                    }

                    productNameToShow = detail.PE;
                    lastProductName = detail.PE;
                    // startRowIndexForProductDetails = rowIndex;
                }

                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(productNameToShow);
                row.CreateCell(1).SetCellValue(detail.Stock_Code);
                row.CreateCell(2).SetCellValue(detail.Stock_Name);
                row.CreateCell(3).SetCellValue(detail.Type);
                row.CreateCell(4).SetCellValue(detail.Quantity.ToString());
                row.CreateCell(5).SetCellValue(detail.UnitPrice.ToString());
                row.CreateCell(6).SetCellValue(detail.VAT.ToString());
                row.CreateCell(7).SetCellValue(detail.Discount.ToString());
                row.CreateCell(8).SetCellValue(detail.ImportTaxt.ToString());
                row.CreateCell(9).SetCellValue(detail.Price.ToString());
                row.CreateCell(10).SetCellValue(detail.Price.ToString());
                row.CreateCell(11).SetCellValue(detail.Price.ToString());
                row.CreateCell(12).SetCellValue(detail.Price.ToString());
                row.CreateCell(13).SetCellValue(detail.Price.ToString());
                row.CreateCell(14).SetCellValue(detail.Price.ToString());
                row.CreateCell(15).SetCellValue(detail.Price.ToString());
                row.CreateCell(16).SetCellValue(detail.Price.ToString());
                row.CreateCell(17).SetCellValue(detail.Price.ToString());

                //if (productDetail.Order.OrderDate.HasValue)
                //{
                //    cell = row.CreateCell(2);
                //    cell.SetCellValue(productDetail.Order.OrderDate.Value.ToShortDateString());
                //    cell.CellStyle = rightAlignedCellStyle;
                //}
                //cell = row.CreateCell(3);
                //cell.SetCellType(CellType.NUMERIC);
                //cell.SetCellValue((double)productDetail.UnitPrice);
                //cell.CellStyle = currencyCellStyle;
                //cell = row.CreateCell(5);
                //cell.SetCellType(CellType.NUMERIC);
                //cell.SetCellValue((double)productDetail.UnitPrice * productDetail.Quantity);
                //cell.CellStyle = currencyCellStyle;

                rowIndex++;
            }

            // Add the subtotal row for the last product
            // AddSubtotalRow(sheet, startRowIndexForProductDetails, rowIndex, detailSubtotalCellStyle, detailCurrencySubtotalCellStyle);
            // rowIndex += 2;

            // Auto-size each column
            for (var i = 0; i < sheet.GetRow(0).LastCellNum; i++)
            {
                sheet.AutoSizeColumn(i);

                // Bump up with auto-sized column width to account for bold headers
                sheet.SetColumnWidth(i, sheet.GetColumnWidth(i) + 1024);
            }


            // Add row indicating date/time report was generated...
            // sheet.CreateRow(rowIndex + 1).CreateCell(0).SetCellValue("Report generated on " + DateTime.Now.ToString("dd/MM/yyyy"));
            #endregion

            // Save the Excel spreadsheet to a MemoryStream and return it to the client
            using (var exportData = new MemoryStream())
            {
                workbook.Write(exportData);

                var saveAsFileName = string.Format("PE-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", saveAsFileName));
                Response.Clear();
                Response.BinaryWrite(exportData.GetBuffer());
                Response.End();
            }
        }

        public ActionResult PDF(int id)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null)
            {
                return RedirectToAction("Index", "Login");
            }

            if (user.PER == 0)
            {
                return RedirectToAction("Index", "Home");
            }

            var item = _service.GetByPEPDF(id);
            var model = new POViewModel
            {
                PurchaseOrderCustom = item,
                PoDetailsVResults = _service.ListConditionDetail(id, "1"),
                VAT = 10
            };
            return View(model);
        }

        public ActionResult Create(int? id)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null)
            {
                return RedirectToAction("Index", "Login");
            }

            if (user.PER == 0)
            {
                return RedirectToAction("Index", "Home");
            }

            var item = new WAMS_PURCHASE_ORDER();
            var totalDetailRecords = 0;
            var listDetail = new List<V3_Pe_Detail>();
            var poGetInformation = new V3_PE_Information();
            if (id.HasValue)
            {
                item = _service.GetByKey(id.Value);
                listDetail = _service.ListConditionDetail(id.Value, "1");
                totalDetailRecords = listDetail.Count();
                poGetInformation = _service.GetPeInformation(id.Value);
            }

            else
            {
                item.vPOID = _service.GetAutoPoCode();
                item.vPOStatus = "Open";
                item.dPODate = DateTime.Now;
                item.dDeliverDate = DateTime.Now;
            }
            var vatList = _systemService.GetLookUp(Constants.LuVat);
            vatList.Add(new LookUp
            {
                LookUpKey = "0",
                LookUpValue = "0"
            });
            vatList = vatList.OrderBy(m => m.LookUpKey).ToList();
            var model = new POViewModel
            {
                Id = item.Id,
                vPOID = item.vPOID,
                vPOStatus = item.vPOStatus,
                sPODate = item.dPODate.ToString("dd/MM/yyyy"),
                sDeliveryDate = item.dDeliverDate != null ? item.dDeliverDate.Value.ToString("dd/MM/yyyy") : string.Empty,
                vLocation = item.vLocation,
                vProjectID = item.vProjectID,
                vRemark = item.vRemark,
                Timestamp = item.Timestamp,
                UserLogin = user,
                Stores = new SelectList(this._systemService.StoreList(), "Id", "Name"),
                iStore = item.iStore != null ? item.iStore.Value : 0,
                Projects = new SelectList(this._systemService.ProjectList(), "Id", "vProjectID"),
                ProjectNames = new SelectList(this._systemService.ProjectList(), "Id", "vProjectName"),
                PoTypes = new SelectList(this._systemService.PoTypeList(), "Id", "Name"),
                bPOTypeID = item.bPOTypeID,
                Suppliers = new SelectList(this._systemService.SupplierList(), "Id", "Name"),
                bSupplierID = item.bSupplierID,
                bCurrencyTypeID = item.bCurrencyTypeID,
                Currencies = new SelectList(this._systemService.CurrencyList(), "Id", "Name"),
                Payments = new SelectList(this._systemService.PaymentList(), "Id", "Name"),
                VatList = new SelectList(vatList, Constants.LookUpKey, Constants.LookUpValue),
                Payment = item.vTermOfPayment,
                TotalRecords = totalDetailRecords,
                PoDetailsVResults = listDetail,
                PoGetInformation = poGetInformation
            };

            return View(model);
        }

        [HttpPost]
        public JsonResult Create(POViewModel model)
        {
            if (model.V3 != true)
            {
                return Json(new { result = Constants.UnSuccess });
            }
            //if (!string.IsNullOrEmpty(model.sPODate))
            //{
            //    model.PurchaseOrder.dPODate = DateTime.ParseExact(model.sPODate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            //}
            return model.PurchaseOrder.Id == 0 ? CreateData(model) : EditData(model);
        }

        private JsonResult CreateData(POViewModel model)
        {
            if (_service.ExistedCode(model.PurchaseOrder.vPOID))
            {
                return Json(new { result = Constants.DuplicateCode, mRf = (Convert.ToInt32(_service.GetAutoPoCode())).ToString(CultureInfo.InvariantCulture) });
            }
            try
            {
                var now = DateTime.Now;
                model.PurchaseOrder.vPOStatus = "Open";
                model.PurchaseOrder.iEnable = true;
                model.PurchaseOrder.iCreated = model.LoginId;
                model.PurchaseOrder.dPODate = now;
                model.PurchaseOrder.dCreated = now;
                _service.Insert(model.PurchaseOrder, model.ListPoDetailData);
                
                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Create New PE!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        private JsonResult EditData(POViewModel model)
        {
            if (model.CheckCode != model.PurchaseOrder.vPOID)
            {
                if (_service.ExistedCode(model.PurchaseOrder.vPOID))
                {
                    return Json(new { result = Constants.DuplicateCode, mRf = (Convert.ToInt32(_service.GetAutoPoCode()) + 1).ToString(CultureInfo.InvariantCulture) });
                }
            }

            var entity = _service.GetByKey(model.PurchaseOrder.Id);
            if (!Convert.ToBase64String(model.PurchaseOrder.Timestamp).Equals(Convert.ToBase64String(entity.Timestamp)))
            {
                return Json(new { result = Constants.DataJustChanged });
            }

            try
            {
                var now = DateTime.Now;
                entity.vProjectID = model.PurchaseOrder.vProjectID;
                //entity.bSupplierID = model.PurchaseOrder.bSupplierID;
                entity.bPOTypeID = model.PurchaseOrder.bPOTypeID;
                //entity.bCurrencyTypeID = model.PurchaseOrder.bCurrencyTypeID;
                //entity.dPODate = model.PurchaseOrder.dPODate;
                //entity.fPOTotal = model.PurchaseOrder.fPOTotal;
                entity.vRemark = model.PurchaseOrder.vRemark;
                entity.vPriceEval = model.PurchaseOrder.vPriceEval;
                entity.vQuanlityEval = model.PurchaseOrder.vQuanlityEval;
                entity.vDeliveryEval = model.PurchaseOrder.vDeliveryEval;
                entity.vConformancyToV3Eval = model.PurchaseOrder.vConformancyToV3Eval;
                entity.vFromCC = model.PurchaseOrder.vFromCC;
                entity.vFromContact = model.PurchaseOrder.vFromContact;
                entity.vFromTel = model.PurchaseOrder.vFromTel;
                entity.vFromFax = model.PurchaseOrder.vFromFax;
                entity.vTermOfPayment = model.PurchaseOrder.vTermOfPayment;
                entity.iExample = model.PurchaseOrder.iExample;
                //entity.vPOStatus = model.PurchaseOrder.vPOStatus;
                entity.vLocation = model.PurchaseOrder.vLocation;
                entity.dDeliverDate = model.PurchaseOrder.dDeliverDate;
                //entity.iStore = model.PurchaseOrder.iStore;
                entity.iPayment = model.PurchaseOrder.iPayment;
                entity.iModified = model.LoginId;
                entity.dModified = now;
                _service.Update(entity, model.ListPoDetailData, model.LstDeleteDetailItem);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Update PE!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        public JsonResult Delete(int id)
        {
            if (_service.CheckDelete(id) == 1)
            {
                return Json(new { result = Constants.UnDelete });
            }

            var fag = _service.Delete(id);
            return Json(fag == 0 ? new { result = true } : new { result = false });
        }

        //public ActionResult MoreProduct(int supplierId)
        //{
        //    var model = new SupplierViewModel();
        //    var temp = _supplierService.ListConditionDetail(supplierId, "1");
        //    model.GetProductDetails = temp;
        //    model.TotalRecords = temp.Count;

        //    return PartialView("_ProductPartial", model);
        //}

        //[HttpPost]
        //public ActionResult MoreProduct(SupplierViewModel model)
        //{
        //    try
        //    {
        //        var entity = _supplierService.GetByKey(model.Supplier.bSupplierID);
        //        _supplierService.Update(entity, model.ListProducts, model.LstDeleteDetailItem);

        //        return Json(new { result = Constants.Success });
        //    }
        //    catch (Exception e)
        //    {
        //        Log.Error("Create New Client!", e);
        //        return Json(new { result = Constants.UnSuccess });
        //    }
        //}


        public ActionResult NewVAT()
        {
            return PartialView("_VATPartial");
        }

        [HttpPost]
        public ActionResult NewVAT(string vat)
        {
            if (_systemService.GetLookUp(Constants.LuVat).Count(m => m.LookUpValue.Equals(vat)) > 0)
            {
                return Json(new { result = Constants.Duplicate });
            }

            try
            {
                var model = new LookUp
                {
                    LookUpType = Constants.LuVat,
                    LookUpKey = vat,
                    LookUpValue = vat,
                    Enable = true
                };
                _systemService.InsertLookUp(model);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Create New Client!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        public JsonResult LoadVAT()
        {
            var objType = _systemService.GetLookUp(Constants.LuVat);
            var obgType = new SelectList(objType, Constants.LookUpKey, Constants.LookUpValue);
            return Json(obgType);
        }
    }
}