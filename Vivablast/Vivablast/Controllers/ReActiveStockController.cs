namespace Vivablast.Controllers
{
    using System;
    using System.IO;
    using System.Web.Mvc;
    using Ap.Service.Seedworks;
    using log4net;
    using NPOI.HSSF.UserModel;
    using NPOI.SS.UserModel;
    using ViewModels;

    [Authorize]
    public class ReActiveStockController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(ReActiveStockController).FullName);

        private readonly ISystemService _systemService;
        private readonly IStockService _service;

        public ReActiveStockController(ISystemService systemService, IStockService service)
        {
            _systemService = systemService;
            _service = service;
        }

        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = this._systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.StockR == 0) return RedirectToAction("Index", "Home");
            var model = new StockViewModel
            {
                UserLogin = user,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Types = new SelectList(_systemService.TypeStockList(), "Id", "Name"),
                Categories = new SelectList(_systemService.CategoryStockList(0), "Id", "Name")
            };
            return View(model);
        }

        public ActionResult LoadStock(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable)
        {
            var model = _service.StockViewModelFilter(page, size, stockCode, stockName, store, type, category, enable);
            var totalTemp = Convert.ToDecimal(model.TotalRecords) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            model.TotalPages = totalPages;
            model.CurrentPage = page;
            model.PageSize = size;
            model.UserLogin = _systemService.GetUserAndRole(0, System.Web.HttpContext.Current.User.Identity.Name);

            return PartialView("_StockPartial", model);
        }

        public void ExportToExcel(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable)
        {
            // Get the data to report on
            var masters = _service.StockViewModelFilter(page, size, stockCode, stockName, store, type, category, enable);
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
            cell.SetCellValue("MRF");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("Status");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("From");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Deliver Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Location");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Remark");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Project Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Project Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Created Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Created By");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("Modified Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(11);
            cell.SetCellValue("Modified By");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            foreach (var master in masters.StockVs)
            {
                row = sheet.CreateRow(rowIndex);
                //row.CreateCell(0).SetCellValue(master.MRF);
                //row.CreateCell(1).SetCellValue(master.Status);
                //row.CreateCell(2).SetCellValue(master.From);
                //row.CreateCell(3).SetCellValue(master.Deliver_Date != null
                //? master.Deliver_Date.Value.ToString("dd/MM/yyyy")
                //: master.Deliver_Date.ToString());
                //row.CreateCell(4).SetCellValue(master.Location);
                //row.CreateCell(5).SetCellValue(master.Remark);
                //row.CreateCell(6).SetCellValue(master.Project_Code);
                //row.CreateCell(7).SetCellValue(master.Project_Name);
                row.CreateCell(8).SetCellValue(master.dCreated != null
                                                   ? master.dCreated.Value.ToString("dd/MM/yyyy")
                                                   : master.dCreated.ToString());
                row.CreateCell(9).SetCellValue(master.Created_By);
                row.CreateCell(10).SetCellValue(master.dModified != null
                                                   ? master.dModified.Value.ToString("dd/MM/yyyy")
                                                   : master.dModified.ToString());
                row.CreateCell(11).SetCellValue(master.Modified_By);
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

                var saveAsFileName = string.Format("Re-Active-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", saveAsFileName));
                Response.Clear();
                Response.BinaryWrite(exportData.GetBuffer());
                Response.End();
            }
        }


        #region Load Condition & Autocomplete
        public ActionResult ListCode(string term)
        {
            return Json(_service.ListCode(term), JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListName(string term)
        {
            return Json(_service.ListName(term), JsonRequestBehavior.AllowGet);
        }

        public JsonResult LoadStockCodeByType(int type)
        {
            var objType = _systemService.CategoryStockList(type);
            var obgType = new SelectList(objType, "bCategoryID", "vCategoryName", 0);
            return Json(obgType);
        }

        public JsonResult LoadCategoryByType(int type)
        {
            var objType = _systemService.CategoryStockList(type);
            var obgType = new SelectList(objType, "bCategoryID", "vCategoryName", 0);
            return Json(obgType);
        }

        public JsonResult LoadUnitByType(int type)
        {
            var objType = _systemService.UnitStockList(type);
            var obgType = new SelectList(objType, "bUnitID", "vUnitName", 0);
            return Json(obgType);
        }

        public JsonResult LoadLabelByType(int type)
        {
            var objType = _systemService.LabelStockList(type);
            var obgType = new SelectList(objType, "bLabelID", "vLabelName", 0);
            return Json(obgType);
        }

        #endregion

        public JsonResult ReActive(string condition)
        {
            try
            {
                return Json(new { result = _service.ReActive(condition) });
            }
            catch (Exception e)
            {
                Log.Error("Re Active Stock " + condition, e);

                return Json(new { result = false });
            }
        }
    }
}