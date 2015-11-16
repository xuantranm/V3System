using System.Collections.Generic;
using NPOI.HSSF.UserModel;
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
    public class StockOutController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(StockOutController).FullName);

        private readonly ISystemService _systemService;
        private readonly IStockOutService _service;

        public StockOutController(ISystemService systemService, IStockOutService service)
        {
            _systemService = systemService;
            _service = service;
        }

        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.StockOutR == 0) return RedirectToAction("Index", "Home");
            var model = new AssignViewModel
            {
                UserLogin = user,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                StockTypes = new SelectList(_systemService.TypeStockList(), "Id", "Name"),
                Projects = new SelectList(_systemService.ProjectList(), "Id", "vProjectID")
            };
            return View(model);
        }

        public ActionResult LoadDataList(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string siv, string fd, string td, string enable)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var totalRecord = _service.ListConditionCount(page, size, store, project, stockType, stockCode, stockName, siv, fd, td, enable);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new AssignViewModel
            {
                UserLogin = _systemService.GetUserAndRole(0, userName),
                AssignStockList = _service.ListCondition(page, size, store, project, stockType, stockCode, stockName, siv, fd, td, enable),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return PartialView("_StockOutPartial", model);
        }

        public ActionResult LoadDataDetailList(int id, string enable)
        {
            var detailList = _service.ListConditionDetail(id, enable);
            var model = new AssignViewModel
            {
                StockAssignDetailList = detailList,
                TotalRecords = detailList.Count()
            };

            return PartialView("_StockOutDetailPartial", model);
        }

        public void ExportToExcel(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string siv, string fd, string td, string enable)
        {
            // Get the data to report on
            var masters = _service.ListCondition(page, size, store, project, stockType, stockCode, stockName, siv, fd,
                td, enable);
            var details = _service.ListConditionDetailExcel(page, size, store, project, stockType, stockCode, stockName, siv, fd,
                td, enable);
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
            cell.SetCellValue("SIV");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Project Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Project Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Location");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Main Contact");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Company Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Status");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Client");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            foreach (var item in masters)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(item.No.ToString());
                row.CreateCell(1).SetCellValue(item.SIV);
                row.CreateCell(2).SetCellValue(item.Create_Date.ToString("dd/MM/yyyy"));
                row.CreateCell(3).SetCellValue(item.Project_Code);
                row.CreateCell(4).SetCellValue(item.Project_Name);
                row.CreateCell(5).SetCellValue(item.Location);
                row.CreateCell(6).SetCellValue(item.Main_Contact);
                row.CreateCell(7).SetCellValue(item.Company);
                row.CreateCell(8).SetCellValue(item.Status);
                row.CreateCell(9).SetCellValue(item.Client);
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
            cell.SetCellValue("SIV");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("Stock Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("Stock Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Quantity");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("MRF");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Stock Type");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Stock Unit");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Stock Category");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Part No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("Ral No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(11);
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
                if (String.CompareOrdinal(detail.SIV, lastProductName) != 0)
                {
                    if (!string.IsNullOrEmpty(lastProductName))
                    {
                        // Add the subtotal row
                        // AddSubtotalRow(sheet, startRowIndexForProductDetails, rowIndex, detailSubtotalCellStyle, detailCurrencySubtotalCellStyle);
                        // rowIndex += 3;
                    }

                    productNameToShow = detail.SIV;
                    lastProductName = detail.SIV;
                    // startRowIndexForProductDetails = rowIndex;
                }

                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(productNameToShow);
                row.CreateCell(1).SetCellValue(detail.Stock_Code);
                row.CreateCell(2).SetCellValue(detail.Stock_Name);
                row.CreateCell(3).SetCellValue(detail.Quantity.ToString(CultureInfo.InvariantCulture));
                row.CreateCell(4).SetCellValue(detail.AssignDate.ToString("dd/MM/yyyy"));
                row.CreateCell(5).SetCellValue(detail.MRF);
                row.CreateCell(6).SetCellValue(detail.Type);
                row.CreateCell(7).SetCellValue(detail.Unit);
                row.CreateCell(8).SetCellValue(detail.Category);
                row.CreateCell(9).SetCellValue(detail.PartNo);
                row.CreateCell(10).SetCellValue(detail.RalNo);
                row.CreateCell(11).SetCellValue(detail.Color);

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

                var saveAsFileName = string.Format("StockOut-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", saveAsFileName));
                Response.Clear();
                Response.BinaryWrite(exportData.GetBuffer());
                Response.End();
            }
        }

        public ActionResult Create(int? id)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null)
            {
                return RedirectToAction("Index", "Login");
            }

            if (user.StockOutR == 0)
            {
                return RedirectToAction("Index", "Home");
            }
           
            var model = new AssignViewModel
            {
                UserLogin = user,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Projects = new SelectList(_systemService.ProjectList(), "Id", "vProjectID"),
                ProjectNames = new SelectList(_systemService.ProjectList(), "Id", "vProjectName")
            };

            return View(model);
        }

        [HttpPost]
        public JsonResult Create(AssignAddViewModel model)
        {
            if (model.V3 != true)
            {
                return Json(new { result = Constants.UnSuccess });
            }

            return EditData(model);
        }

        private JsonResult EditData(AssignAddViewModel model)
        {
            try
            {
                //var srvNew = _service.SRVLastest("F");

                if (!string.IsNullOrEmpty(model.LstDeleteDetailItem))
                {
                    var listStrLineElements = model.LstDeleteDetailItem.Split(';').ToList();
                    foreach (var itemDetail in listStrLineElements)
                    {
                        _service.DeleteDetail(Convert.ToInt32(itemDetail));
                    }
                }
                _service.Insert(model.AssignStockItemList, model.LoginId);
                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Update Stock Out!", e);
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
    }
}