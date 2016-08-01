using System.IO;
using Ap.Business.ViewModels;
using Ap.Service.Seedworks;
using System;
using System.Web.Mvc;
using log4net;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using Vivablast.ViewModels;

namespace Vivablast.Controllers
{
    public class ReportController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(PeController).FullName);

        private readonly ISystemService _systemService;
        public ReportController(ISystemService systemService)
        {
            _systemService = systemService;
        }

        //
        // GET: /Report/

        public ActionResult DynamicPe()
        {
            return View();
        }

        public ActionResult LoadDynamicPe(int page, int size, int poType, string po, int stockType, int category, string stockCode, string stockName, string fd, string td)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var model = _systemService.GetDynamicPeReport(page, size, poType, po, stockType, category, stockCode, stockName, fd, td);
           return PartialView("Partials/_DynamicPeReport", model);
        }

        public void ExportToExcelDynamicPe(int page, int size, int poType, string po, int stockType, int category, string stockCode, string stockName, string fd, string td)
        {
            // Get the data to report on
            var masters = _systemService.GetDynamicPeReport(page, size, poType, po, stockType, category, stockCode, stockName, fd, td);
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
            var sheet = workbook.CreateSheet("Project");

            // Add header labels
            var rowIndex = 0;

            // Undestand as row in excel. row + 3 = xuong 3 row.
            var row = sheet.CreateRow(rowIndex);
            var cell = row.CreateCell(0);
            cell.SetCellValue("No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("Action");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("PO Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("PO Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("PO Type");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Project Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Project Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Stock Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Stock Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Stock Type");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("MRF");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(11);
            cell.SetCellValue("Category");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(12);
            cell.SetCellValue("Supplier");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(13);
            cell.SetCellValue("Unit");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(14);
            cell.SetCellValue("Quantity");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(15);
            cell.SetCellValue("Quantity Received");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(16);
            cell.SetCellValue("Quantity Pending");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(17);
            cell.SetCellValue("Weight");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            foreach (var master in masters.DynamicReports)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(master.Id);
                row.CreateCell(1).SetCellValue(master.Action);
                row.CreateCell(2).SetCellValue(master.PODate.ToString("dd/MM/yyyy"));
                row.CreateCell(3).SetCellValue(master.POCode);
                row.CreateCell(4).SetCellValue(master.POType);
                row.CreateCell(5).SetCellValue(master.ProjectCode);
                row.CreateCell(6).SetCellValue(master.ProjectName);
                row.CreateCell(7).SetCellValue(master.StockCode);
                row.CreateCell(8).SetCellValue(master.StockName);
                row.CreateCell(9).SetCellValue(master.StockType);
                row.CreateCell(10).SetCellValue(master.MRF);
                row.CreateCell(11).SetCellValue(master.Category);
                row.CreateCell(12).SetCellValue(master.Supplier);
                row.CreateCell(13).SetCellValue(master.Unit);
                row.CreateCell(14).SetCellValue(master.Quantity.ToString());
                row.CreateCell(15).SetCellValue(master.QuantityReceived.ToString());
                row.CreateCell(16).SetCellValue(master.QuantityPending.ToString());
                row.CreateCell(17).SetCellValue(master.Weight);
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

                var saveAsFileName = string.Format("DynamicPe-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", saveAsFileName));
                Response.Clear();
                Response.BinaryWrite(exportData.GetBuffer());
                Response.End();
            }
        }

        public ActionResult DynamicProject()
        {
            var model = new DynamicProjectReportViewModel();
            var projects = _systemService.ProjectList();
            model.ProjectIds = projects;
            model.ProjectNames = projects;
            model.Suppliers = _systemService.SupplierList();
            model.StockTypes = _systemService.TypeStockList();
            model.StockCategories = _systemService.CategoryStockList(0);
            return View(model);
        }

        public ActionResult LoadDynamicProject(int page, int size, int projectId, int stockTypeId, int categoryId, string stockCode, string stockName, string actionFag, int supplierId, string fd, string td)
        {
            var model = _systemService.GetDynamicProjectReport(page, size, projectId, stockTypeId, categoryId, stockCode, stockName, actionFag, supplierId, fd, td);
            return PartialView("Partials/_DynamicProjectReport", model);
        }

        public ActionResult LoadDynamicProjectGroupItems(int page, int size, int projectId, int stockTypeId, int categoryId, string stockCode, string stockName, string actionFag, int supplierId, string fd, string td)
        {
            var model = _systemService.GetDynamicProjectReport(page, size, projectId, stockTypeId, categoryId, stockCode, stockName, actionFag, supplierId, fd, td);
            return PartialView("Partials/_DynamicProjectReport", model);
        }
    }
}
