using Ap.Business.Domains;

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
    using Constants = Ap.Common.Constants.Constants;

    [Authorize]
    public class CategoryController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(CategoryController).FullName);

        private readonly ISystemService _systemService;
        private readonly ICategoryService _service;

        public CategoryController(ISystemService systemService, ICategoryService service)
        {
            _systemService = systemService;
            _service = service;
        }
        
        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = this._systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.CategoryR == 0) return RedirectToAction("Index", "Home");
            var model = new CategoryViewModel
                            {
                                UserLogin = user,
                                Types = new SelectList(_systemService.TypeStockList(), "Id", "Name")
                            };
            return View(model);
        }

        public ActionResult LoadData(int page, int size, string code, string name, int type, string enable)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var totalRecord = _service.ListConditionCount(page, size, code, name, type, enable);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new CategoryViewModel
            {
                UserLogin = _systemService.GetUserAndRole(0, userName),
                ListEntity = _service.ListCondition(page, size, code, name, type, enable),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return PartialView("_CategoryPartial", model);
        }

        public void ExportToExcel(int page, int size, string code, string name, int type, string enable)
        {
            // Get the data to report on
            var masters = _service.ListCondition(page, size, code, name, type, enable);
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
            var sheet = workbook.CreateSheet("Category");

            // Add header labels
            var rowIndex = 0;

            // Undestand as row in excel. row + 3 = xuong 3 row.
            var row = sheet.CreateRow(rowIndex);
            var cell = row.CreateCell(0);
            cell.SetCellValue("Key");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Created Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Created By");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Modified Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Modified By");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            foreach (var master in masters)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(master.Id);
                row.CreateCell(1).SetCellValue(master.Name);
                row.CreateCell(2).SetCellValue(master.Code);
                row.CreateCell(3).SetCellValue(master.Created_Date != null
                                                   ? master.Created_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.Created_Date.ToString());
                row.CreateCell(4).SetCellValue(master.Created_By);
                row.CreateCell(5).SetCellValue(master.Modified_Date != null
                                                   ? master.Modified_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.Modified_Date.ToString());
                row.CreateCell(6).SetCellValue(master.Modified_By);
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

                var saveAsFileName = string.Format("Category-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", saveAsFileName));
                Response.Clear();
                Response.BinaryWrite(exportData.GetBuffer());
                Response.End();
            }
        }

        public ActionResult ListCode(string term)
        {
            return Json(_service.ListCode(term), JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListName(string term)
        {
            return Json(_service.ListName(term), JsonRequestBehavior.AllowGet);
        }

        public ActionResult Create(int? id)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null)
            {
                return RedirectToAction("Index", "Login");
            }

            if (user.CategoryR == 0)
            {
                return RedirectToAction("Index", "Home");
            }

            var item = new WAMS_CATEGORY();

            if (id.HasValue)
            {
                item = _service.GetByKey(id.Value);
            }

            var model = new CategoryViewModel
            {
                bCategoryID = item.bCategoryID,
                CategoryCode = item.CategoryCode,
                vCategoryName = item.CategoryCode,
                iType = item.iType,
                Timestamp = item.Timestamp,
                iCreated = item.iCreated,
                dCreated = item.dCreated,
                UserLogin = user,
                Types = new SelectList(_systemService.TypeStockList(), "Id", "Name")
            };
            return View(model);
        }

        [HttpPost]
        public JsonResult Create(CategoryViewModel model)
        {
            if (model.V3 != true)
            {
                return Json(new { result = Constants.UnSuccess });
            }

            return model.Entity.bCategoryID == 0 ? CreateData(model) : EditData(model);
        }

        private JsonResult CreateData(CategoryViewModel model)
        {
            if (_service.ExistedCode(model.Entity.CategoryCode))
            {
                return Json(new { result = Constants.DuplicateCode });
            }

            if (_service.ExistedName(model.Entity.vCategoryName))
            {
                return Json(new { result = Constants.Duplicate });
            }

            try
            {
                model.Entity.iEnable = true;
                model.Entity.iCreated = model.LoginId;
                model.Entity.dCreated = DateTime.Now;
                _service.Insert(model.Entity);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Create New Category!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        private JsonResult EditData(CategoryViewModel model)
        {
            if (model.CheckCode != model.Entity.CategoryCode)
            {
                if (_service.ExistedCode(model.Entity.CategoryCode))
                {
                    return Json(new { result = Constants.DuplicateCode });
                }
            }

            if (model.CheckName != model.Entity.vCategoryName)
            {
                if (_service.ExistedName(model.Entity.vCategoryName))
                {
                    return Json(new { result = Constants.Duplicate });
                }
            }

            var entity = _service.GetByKey(model.Entity.bCategoryID);
            if (!Convert.ToBase64String(model.Entity.Timestamp).Equals(Convert.ToBase64String(entity.Timestamp)))
            {
                return Json(new { result = Constants.DataJustChanged });
            }

            try
            {
                entity.CategoryCode = model.Entity.CategoryCode;
                entity.vCategoryName = model.Entity.vCategoryName;
                entity.iType = model.Entity.iType;
                entity.iModified = model.LoginId;
                entity.dModified = DateTime.Now;
                _service.Update(entity);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Update Category!", e);
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
