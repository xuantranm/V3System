using Ap.Business.Domains;
using Vivablast.Models;

namespace Vivablast.Controllers
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Web.Mvc;
    using Ap.Service.Seedworks;
    using log4net;
    using NPOI.HSSF.UserModel;
    using NPOI.SS.UserModel;
    using ViewModels;
    using Constants = Ap.Common.Constants.Constants;

    [Authorize]
    public class SupplierController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(SupplierController).FullName);

        private readonly ISystemService _systemService;
        private readonly ISupplierService _service;

        public SupplierController(ISystemService systemService, ISupplierService service)
        {
            _systemService = systemService;
            _service = service;
        }

        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null)
            {
                return RedirectToAction("Index", "Login");
            }

            if (user.UserR == 0)
            {
                return RedirectToAction("Index", "Home");
            }

            var model = new SupplierViewModel
                            {
                                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                                Countries = new SelectList(_systemService.CountryList(), "Id", "Name"),
                                Types = new SelectList(_systemService.SupplierTypeList(), "Id", "Name"),
                                Suppliers = new SelectList(_systemService.SupplierList(), "Id", "Name"),
                                UserLogin = user
                            };

            return View(model);
        }

        #region Load Condition & Autocomplete
        public ActionResult ListName(string term)
        {
            return Json(_service.ListName(term), JsonRequestBehavior.AllowGet);
        }
        #endregion

        public ActionResult LoadSupplier(int page, int size, int supplierType, int supplierId, string supplierName, string stockCode, string stockName, int country, int market, string enable)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var totalRecord = _service.ListConditionCount(page, size, supplierType, supplierId, supplierName, stockCode, stockName, country, market, enable);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new SupplierViewModel
            {
                UserLogin = _systemService.GetUserAndRole(0, userName),
                SupplierGetListResults = _service.ListCondition(page, size, supplierType, supplierId, supplierName, stockCode, stockName, country, market, enable),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };
            return PartialView("_SupplierPartial", model);
        }

        public void ExportToExcel(int page, int size, int supplierType, int supplierId, string supplierName, string stockCode, string stockName, int country, int market, string enable)
        {
            // Get the data to report on
            var masters = _service.ListCondition(page, size, supplierType, supplierId, supplierName, stockCode, stockName, country, market, enable);
            var details = _service.ListConditionDetailExcel(page, size, supplierType, supplierId, supplierName, stockCode, stockName, country, market, enable);
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
            var sheet = workbook.CreateSheet("Supplier");

            // Add header labels
            var rowIndex = 0;

            // Undestand as row in excel. row + 3 = xuong 3 row.
            var row = sheet.CreateRow(rowIndex);
            var cell = row.CreateCell(0);
            cell.SetCellValue("No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("Supplier Id");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("Supplier Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Type");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Address");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("City");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Country");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Phone 1");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Phone 2");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Mobile");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("Fax");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(11);
            cell.SetCellValue("Email");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(12);
            cell.SetCellValue("Contact");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(13);
            cell.SetCellValue("Created Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(14);
            cell.SetCellValue("Created By");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(15);
            cell.SetCellValue("Modified Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(16);
            cell.SetCellValue("Modified By");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            var no = 1;
            foreach (var master in masters)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(no);
                row.CreateCell(1).SetCellValue(master.Id);
                row.CreateCell(2).SetCellValue(master.Name);
                row.CreateCell(3).SetCellValue(master.Type);
                row.CreateCell(4).SetCellValue(master.Address);
                row.CreateCell(5).SetCellValue(master.City);
                row.CreateCell(6).SetCellValue(master.Country);
                row.CreateCell(7).SetCellValue(master.Phone);
                row.CreateCell(8).SetCellValue(master.Phone_2);
                row.CreateCell(9).SetCellValue(master.Mobile);
                row.CreateCell(10).SetCellValue(master.Fax);
                row.CreateCell(11).SetCellValue(master.Email);
                row.CreateCell(12).SetCellValue(master.Contact);
                row.CreateCell(13).SetCellValue(master.Created_Date != null
                                                   ? master.Created_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.Created_Date.ToString());
                row.CreateCell(14).SetCellValue(master.Created_By);
                row.CreateCell(15).SetCellValue(master.Modified_Date != null
                                                   ? master.Modified_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.Modified_Date.ToString());
                row.CreateCell(16).SetCellValue(master.Modified_By);
                rowIndex++;
                no++;
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
            sheet = workbook.CreateSheet("Product");

            #region Add header labels
            rowIndex = 0;
            row = sheet.CreateRow(rowIndex);

            cell = row.CreateCell(0);
            cell.SetCellValue("Supplier");
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
            cell.SetCellValue("Unit");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Category");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Part No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Ral No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
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
                if (string.Compare(detail.Supplier_Name, lastProductName) != 0)
                {
                    if (!string.IsNullOrEmpty(lastProductName))
                    {
                        // Add the subtotal row
                        // AddSubtotalRow(sheet, startRowIndexForProductDetails, rowIndex, detailSubtotalCellStyle, detailCurrencySubtotalCellStyle);
                        // rowIndex += 3;
                    }

                    productNameToShow = detail.Supplier_Name;
                    lastProductName = detail.Supplier_Name;
                    // startRowIndexForProductDetails = rowIndex;
                }

                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(productNameToShow);
                row.CreateCell(1).SetCellValue(detail.Stock_Code);
                row.CreateCell(2).SetCellValue(detail.Stock_Name);
                row.CreateCell(3).SetCellValue(detail.Type);
                row.CreateCell(4).SetCellValue(detail.Unit);
                row.CreateCell(5).SetCellValue(detail.Category);
                row.CreateCell(6).SetCellValue(detail.Part_No);
                row.CreateCell(7).SetCellValue(detail.Ral_No);
                row.CreateCell(8).SetCellValue(detail.Color);

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

                var saveAsFileName = string.Format("Supplier-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", saveAsFileName));
                Response.Clear();
                Response.BinaryWrite(exportData.GetBuffer());
                Response.End();
            }
        }

        public ActionResult LoadProductDetail(int id, string enable)
        {
            var detailList = _service.ListConditionDetail(id, enable);
            var model = new SupplierViewModel
            {
                GetProductDetails = detailList,
                TotalRecords = detailList.Count()
            };

            return PartialView("_SupplierDetailPartial", model);
        }

        public ActionResult Create(int? id)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null)
            {
                return RedirectToAction("Index", "Login");
            }
            if (user.SupplierR ==0)
            {
                return RedirectToAction("Index", "Home");
            }

            var item = new WAMS_SUPPLIER();

            if (id.HasValue)
            {
                item = _service.GetByKey(id.Value);
            }

            var model = new SupplierViewModel
            {
                Id = item.bSupplierID,
                vSupplierName = item.vSupplierName,
                vAddress = item.vAddress,
                vCity = item.vCity,
                Telephone1 = item.vPhone1,
                Telephone2 = item.vPhone2,
                Mobile = item.vMobile,
                vFax = item.vFax,
                Email = item.vEmail,
                vContactPerson = item.vContactPerson,
                fTotalMoney = item.fTotalMoney,
                bSupplierTypeID = item.bSupplierTypeID,
                iEnable = item.iEnable,
                iService = item.iService,
                dDateCreate = item.dDateCreate,
                CountryId = item.CountryId,
                iMarket = item.iMarket,
                iStore = item.iStore,
                iPayment = item.iPayment,
                dCreated = item.dCreated,
                dModified = item.dModified,
                iCreated = item.iCreated,
                iModified = item.iModified,
                Timestamp = item.Timestamp,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Types = new SelectList(_systemService.SupplierTypeList(), "Id", "Name"),
                Countries = new SelectList(_systemService.CountryList(), "Id", "Name"),
                UserLogin = user
            };

            if (!id.HasValue) return View(model);
            var temp = _service.ListConditionDetail(id.Value, "1");
            model.GetProductDetails = temp;
            model.TotalRecords = temp.Count;

            // FUNCTION
            return View(model);
        }

        [HttpPost]
        public ActionResult Create(SupplierViewModel model)
        {
            if (model.V3 != true)
            {
                return this.Json(new { result = Constants.UnSuccess });
            }

            return model.Supplier.bSupplierID != 0 ? EditResultJson(model) : CreateResultJson(model);
        }

        private JsonResult CreateResultJson(SupplierViewModel model)
        {
            if (_service.ExistedName(model.Supplier.vSupplierName))
            {
                return Json(new { result = Constants.Duplicate });
            }

            try
            {
                model.Supplier.iEnable = true;
                model.Supplier.iCreated = model.LoginId;
                model.Supplier.dCreated = DateTime.Now;
                _service.Insert(model.Supplier, model.ListProducts);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Create New Supplier!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        private JsonResult EditResultJson(SupplierViewModel model)
        {
            if (model.CheckName != model.Supplier.vSupplierName)
            {
                if (_service.ExistedName(model.Supplier.vSupplierName))
                {
                    return Json(new { result = Constants.Duplicate });
                }
            }

            var entity = _service.GetByKey(model.Supplier.bSupplierID);
            if (!Convert.ToBase64String(model.Supplier.Timestamp).Equals(Convert.ToBase64String(entity.Timestamp)))
            {
                return Json(new { result = Constants.DataJustChanged });
            }

            try
            {
                entity.vSupplierName = model.Supplier.vSupplierName;
                entity.vAddress = model.Supplier.vAddress;
                entity.vCity = model.Supplier.vCity;
                entity.vPhone1 = model.Supplier.vPhone1;
                entity.vPhone2 = model.Supplier.vPhone2;
                entity.vMobile = model.Supplier.vMobile;
                entity.vFax = model.Supplier.vFax;
                entity.vEmail = model.Supplier.vEmail;
                entity.vContactPerson = model.Supplier.vContactPerson;
                entity.bSupplierTypeID = model.Supplier.bSupplierTypeID;
                entity.iService = model.Supplier.iService;
                entity.CountryId = model.Supplier.CountryId;
                entity.iMarket = model.Supplier.iMarket;
                entity.iStore = model.Supplier.iStore;
                entity.iPayment = model.Supplier.iPayment;
                entity.iModified = model.LoginId;
                entity.dModified = DateTime.Now;
                _service.Update(entity, model.ListProducts, model.LstDeleteDetailItem);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Update Supplier!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        public ActionResult Delete(int id)
        {
            if (_service.CheckDelete(id) == 1)
            {
                return Json(new { result = Constants.UnDelete });
            }

            var fag = _service.Delete(id);
            return Json(fag == 0 ? new { result = true } : new { result = false });
        }
    }
}