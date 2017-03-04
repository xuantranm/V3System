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

    // SERVICE MOVE TO STOCK. REMOVE TABLE SERVICES LATER
    [Authorize]
    public class ServiceController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(ServiceController).FullName);

        private readonly ISystemService _systemService;
        private readonly IStockService _service;

        public ServiceController(ISystemService systemService, IStockService service)
        {
            _systemService = systemService;
            _service = service;
        }

        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = this._systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.StockServiceR == 0) return RedirectToAction("Index", "Home");
            var model = new ServiceViewModel
            {
                UserLogin = user,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Categories = new SelectList(_systemService.CategoryStockList(0), "Id", "Name")
            };
            return View(model);
        }

        #region Autocomplete
        public ActionResult ListCode(string term)
        {
            return Json(_service.ListCode(term), JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListName(string term)
        {
            return Json(_service.ListName(term), JsonRequestBehavior.AllowGet);
        }
        #endregion

        public ActionResult LoadDataList(int page, int size, string code, string name, string store, int category, string enable)
        {
            var model = _service.StockAndServiceViewModelFilter(page, size, code, name, store, 8, category, enable);
            var totalTemp = Convert.ToDecimal(model.TotalRecords) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            model.TotalPages = totalPages;
            model.CurrentPage = page;
            model.PageSize = size;
            model.StoreVs = _systemService.StoreList();
            model.UserLogin = _systemService.GetUserAndRole(0, System.Web.HttpContext.Current.User.Identity.Name);

            return PartialView("_ServicePartial", model);
        }

        public void ExportToExcel(int page, int size, string code, string name, string store, int category, string enable)
        {
            // Get the data to report on
            var masters = _service.StockViewModelFilter(page, size, code, name, store, 8, category, enable);
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
            var sheet = workbook.CreateSheet("Stock");

            // Add header labels
            var rowIndex = 0;

            // Undestand as row in excel. row + 3 = xuong 3 row.
            var row = sheet.CreateRow(rowIndex);
            var cell = row.CreateCell(0);
            cell.SetCellValue("No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Accounting No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Unit");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Category");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Weight");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Created Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Created By");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Modified Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("Modified By");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            foreach (var master in masters.StockVs)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(master.Id);
                row.CreateCell(1).SetCellValue(master.vStockID);
                row.CreateCell(2).SetCellValue(master.vStockName);
                row.CreateCell(3).SetCellValue(master.vAccountCode);
                row.CreateCell(4).SetCellValue(master.Unit);
                row.CreateCell(5).SetCellValue(master.Category);
                row.CreateCell(6).SetCellValue(master.bWeight.ToString());
                row.CreateCell(7).SetCellValue(master.dCreated != null
                                                   ? master.dCreated.Value.ToString("dd/MM/yyyy")
                                                   : master.dCreated.ToString());
                row.CreateCell(8).SetCellValue(master.Created_By);
                row.CreateCell(9).SetCellValue(master.dModified != null
                                                   ? master.dModified.Value.ToString("dd/MM/yyyy")
                                                   : master.dModified.ToString());
                row.CreateCell(10).SetCellValue(master.Modified_By);
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

                var saveAsFileName = string.Format("Service-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

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

            if (user.StockServiceR == 0)
            {
                return RedirectToAction("Index", "Home");
            }

            var item = new WAMS_STOCK();

            if (id.HasValue)
            {
                item = _service.GetByKey(id.Value);
            }

            var model = new StockViewModel
            {
                Id = item.Id,
                vStockID = item.vStockID,
                vStockName = item.vStockName,
                vRemark = item.vRemark,
                bUnitID = item.bUnitID,
                vBrand = item.vBrand,
                bCategoryID = item.bCategoryID,
                bPositionID = item.bPositionID,
                //bLabelID = item.bLabelID,
                bWeight = item.bWeight,
                vAccountCode = item.vAccountCode,
                iType = item.iType,
                PartNo = item.PartNo,
                PartNoFor = item.PartNoFor,
                PartNoMiniQty = item.PartNoMiniQty,
                RalNo = item.RalNo,
                ColorName = item.ColorName,
                Position = item.Position,
                SubCategory = item.SubCategory,
                UserForPaint = item.UserForPaint,
                Timestamp = item.Timestamp,
                UserLogin = user,
                Types = new SelectList(_systemService.TypeStockList(), "Id", "Name"),
                Categories = new SelectList(_systemService.CategoryStockList(0), "Id", "Name"),
                Units = new SelectList(_systemService.UnitStockList(0), "Id", "Name"),
                Positions = new SelectList(_systemService.PositionStockList(), "Id", "Name")
                //Labels = new SelectList(_systemService.LabelStockList(0), "Id", "Name")
            };

            return View(model);
        }

        [HttpPost]
        public ActionResult Create(StockViewModel model)
        {
            if (model.V3 != true)
            {
                return Json(new { result = Constants.UnSuccess });
            }

            model.iType = 8;
            model.Type = "Service";
            return model.Id == 0 ? CreateData(model) : EditData(model);
        }

        private JsonResult CreateData(StockViewModel model)
        {
            if (_service.ExistedCode(model.Stock.vStockID))
            {
                return Json(new { result = Constants.DuplicateCode });
            }

            if (_service.ExistedName(model.Stock.vStockName))
            {
                return Json(new { result = Constants.Duplicate });
            }

            try
            {
                model.Stock.iEnable = true;
                model.Stock.iCreated = model.LoginId;
                model.Stock.dCreated = DateTime.Now;
                _service.Insert(model.Stock);
                //UploadPictureBase64(model, model.Stock.Id);
                return Json(new { result = Constants.Success, id = model.Stock.Id });
            }
            catch (Exception e)
            {
                Log.Error("Create New Stock Service!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        private JsonResult EditData(StockViewModel model)
        {
            if (model.CheckCode != model.Stock.vStockID)
            {
                if (_service.ExistedCode(model.Stock.vStockID))
                {
                    return Json(new { result = Constants.DuplicateCode });
                }
            }

            if (model.CheckName != model.Stock.vStockName)
            {
                if (_service.ExistedName(model.Stock.vStockName))
                {
                    return Json(new { result = Constants.Duplicate });
                }
            }

            var entity = _service.GetByKey(model.Stock.Id);
            if (!Convert.ToBase64String(model.Stock.Timestamp).Equals(Convert.ToBase64String(entity.Timestamp)))
            {
                return Json(new { result = Constants.DataJustChanged });
            }

            try
            {
                entity.vStockID = model.Stock.vStockID;
                entity.vStockName = model.Stock.vStockName;
                entity.vRemark = model.Stock.vRemark;
                entity.bUnitID = model.Stock.bUnitID;
                entity.vBrand = model.Stock.vBrand;
                entity.bCategoryID = model.Stock.bCategoryID;
                entity.bPositionID = model.Stock.bPositionID;
                //entity.bLabelID = model.Stock.bLabelID;
                entity.bWeight = model.Stock.bWeight;
                entity.vAccountCode = model.Stock.vAccountCode;
                entity.iType = model.Stock.iType;
                entity.PartNo = model.Stock.PartNo;
                entity.PartNoFor = model.Stock.PartNoFor;
                entity.PartNoMiniQty = model.Stock.PartNoMiniQty;
                entity.RalNo = model.Stock.RalNo;
                entity.ColorName = model.Stock.ColorName;
                entity.Position = model.Stock.Position;
                entity.SubCategory = model.Stock.SubCategory;
                entity.UserForPaint = model.Stock.UserForPaint;
                entity.iModified = model.LoginId;
                entity.dModified = DateTime.Now;
                _service.Update(entity);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Update Stock Service!", e);
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
