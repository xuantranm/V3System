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
    public class PriceController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(PriceController).FullName);

        private readonly ISystemService _systemService;
        private readonly IPriceService _service;

        public PriceController(ISystemService systemService, IPriceService service)
        {
            _systemService = systemService;
            _service = service;
        }
        
        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.RequisitionR == 0) return RedirectToAction("Index", "Home");
            var model = new PriceViewModel
            {
                UserLogin = user,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Suppliers = new SelectList(_systemService.SupplierList(), "Id", "Name"),
                StatusPrice = new SelectList(this._systemService.GetLookUp(Constants.LuPriceStatus), Constants.LookUpKey, Constants.LookUpValue),
            };
            return View(model);
        }

        public ActionResult LoadPrice(int page, int size, int store, int supplier, string stockCode, string stockName, int status, string fd, string td, string enable)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var totalRecord = _service.ListConditionCount(page, size, store, supplier, stockCode, stockName, status, fd, td, enable);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new PriceViewModel
            {
                UserLogin = _systemService.GetUserAndRole(0, userName),
                ListPrice = _service.ListCondition(page, size, store, supplier, stockCode, stockName, status, fd, td, enable),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return PartialView("_PricePartial", model);
        }

        public void ExportToExcel(int page, int size, int store, int supplier, string stockCode, string stockName, int status, string fd, string td, string enable)
        {
            // Get the data to report on
            var masters = _service.ListCondition(page, size, store, supplier, stockCode, stockName, status, fd, td, enable);
            //var requisitionDetails = _service.ListConditionDetailExcel(page, size, store, mrf, stockCode, stockName, status,
            //                                                     fd, td, enable);
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
            var sheet = workbook.CreateSheet("Price");

            // Add header labels
            var rowIndex = 0;

            // Undestand as row in excel. row + 3 = xuong 3 row.
            var row = sheet.CreateRow(rowIndex);
            var cell = row.CreateCell(0);
            cell.SetCellValue("Store");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("Supplier");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("Stock Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Stock Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Price");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Currency");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Status");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Start Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("End Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Created Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("Created By");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(11);
            cell.SetCellValue("Modified Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(12);
            cell.SetCellValue("Modified By");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            foreach (var master in masters)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(master.Store);
                row.CreateCell(1).SetCellValue(master.Supplier);
                row.CreateCell(2).SetCellValue(master.Stock_Code);
                row.CreateCell(3).SetCellValue(master.Stock_Name); 
                row.CreateCell(4).SetCellValue(master.Price.ToString());
                row.CreateCell(5).SetCellValue(master.Currency);
                row.CreateCell(6).SetCellValue(master.Status);
                row.CreateCell(7).SetCellValue(master.Start != null
                                                   ? master.Start.Value.ToString("dd/MM/yyyy")
                                                   : master.Start.ToString());
                row.CreateCell(8).SetCellValue(master.End != null
                                                   ? master.End.Value.ToString("dd/MM/yyyy")
                                                   : master.End.ToString());
                row.CreateCell(9).SetCellValue(master.Created_Date != null
                                                   ? master.Created_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.Created_Date.ToString());
                row.CreateCell(10).SetCellValue(master.Created_By);
                row.CreateCell(11).SetCellValue(master.Modified_Date != null
                                                   ? master.Modified_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.Modified_Date.ToString());
                row.CreateCell(12).SetCellValue(master.Modified_By);
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

            // Save the Excel spreadsheet to a MemoryStream and return it to the client
            using (var exportData = new MemoryStream())
            {
                workbook.Write(exportData);

                var saveAsFileName = string.Format("Price-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", saveAsFileName));
                Response.Clear();
                Response.BinaryWrite(exportData.GetBuffer());
                Response.End();
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

        public ActionResult Create(int? id)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null)
            {
                return RedirectToAction("Index", "Login");
            }

            if (user.PriceR == 0)
            {
                return RedirectToAction("Index", "Home");
            }

            var item = new V3_Price_By_Id();
            if (id.HasValue)
            {
                item = _service.GetByKeySp(id.Value, "1");
            }
            
            var model = new PriceViewModel
            {
                Id = item.Id,
                StockId = item.Stock_Id,
                StockCode = item.Stock_Code,
                StockName = item.Stock_Name,
                Price = item.Price,
                CurrencyId = item.Currency_Id,
                SupplierId = item.Supplier_Id,
                StoreId = item.Store_Id,
                dStart = item.Start,
                dEnd = item.End,
                StockType = item.Stock_Type,
                Unit = item.Unit,
                PartNo = item.Part_No,
                RalNo = item.Ral_No,
                ColorName = item.Color,
                Timestamp = item.Timestamp,
                UserLogin = user,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Suppliers = new SelectList(_systemService.SupplierList(), "bSupplierID", "vSupplierName"),
                Currencies = new SelectList(_systemService.CurrencyList(), "Id", "Name")
            };

            return View(model);
        }

        [HttpPost]
        public JsonResult Create(PriceViewModel model)
        {
            if (model.V3 != true)
            {
                return Json(new { result = Constants.UnSuccess });
            }

            return model.Id == 0 ? CreateData(model) : EditData(model);
        }

        private JsonResult CreateData(PriceViewModel model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.dStartTemp))
                {
                    model.ProductPrice.dStart = DateTime.ParseExact(model.dStartTemp, "MM/dd/yyyy", new CultureInfo(Constants.MyCultureInfo));
                }
                
                if (!string.IsNullOrEmpty(model.dEndTemp))
                {
                    model.ProductPrice.dEnd = DateTime.ParseExact(model.dEndTemp, "MM/dd/yyyy", new CultureInfo(Constants.MyCultureInfo));
                }
                
                model.ProductPrice.iEnable = true;
                model.ProductPrice.iCreated = model.LoginId;
                model.ProductPrice.dCreated = DateTime.Now;
                model.ProductPrice.Status = SetStatus(model.ProductPrice.dStart, model.ProductPrice.dEnd);
                _service.Insert(model.ProductPrice);
                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Create New Price!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        private JsonResult EditData(PriceViewModel model)
        {
            var entity = _service.GetByKey(model.ProductPrice.Id);
            if (!Convert.ToBase64String(model.ProductPrice.Timestamp).Equals(Convert.ToBase64String(entity.Timestamp)))
            {
                return Json(new { result = Constants.DataJustChanged });
            }

            try
            {
                if (!string.IsNullOrEmpty(model.dStartTemp))
                {
                    entity.dStart = DateTime.ParseExact(model.dStartTemp, "MM/dd/yyyy", new CultureInfo(Constants.MyCultureInfo));
                }

                if (!string.IsNullOrEmpty(model.dEndTemp))
                {
                    entity.dEnd = DateTime.ParseExact(model.dEndTemp, "MM/dd/yyyy", new CultureInfo(Constants.MyCultureInfo));
                }

                entity.Price = model.ProductPrice.Price;
                entity.CurrencyId = model.ProductPrice.CurrencyId;
                entity.SupplierId = model.ProductPrice.SupplierId;
                entity.StoreId = model.ProductPrice.StoreId;
                entity.iModified = model.LoginId;
                entity.dModified = DateTime.Now;
                entity.Status = SetStatus(entity.dStart, entity.dEnd);

                this._service.Update(entity);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Update Price!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        private int SetStatus(DateTime? datefrom, DateTime? dateto)
        {
            if (datefrom == null && dateto == null)
            {
                return 1;
            }
            if (datefrom == null && dateto >= DateTime.Now)
            {
                return 1;
            }
            if (datefrom != null && datefrom <= DateTime.Now && dateto == null)
            {
                return 1;
            }
            if (datefrom >= DateTime.Now && dateto <= DateTime.Now)
            {
                return 1;
            }
            return 2;
        }
    }
}