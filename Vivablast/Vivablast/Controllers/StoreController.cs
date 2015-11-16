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
    public class StoreController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(StoreController).FullName);

        private readonly ISystemService _systemService;
        private readonly IStoreService _service;

        public StoreController(ISystemService systemService, IStoreService service)
        {
            _systemService = systemService;
            _service = service;
        }
        
        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = this._systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.StoreR == 0) return RedirectToAction("Index", "Home");
            var model = new StoreViewModel
                            {
                                Countries = new SelectList(_systemService.CountryList(), "Id", "Name"),
                                UserLogin = user
                            };
            return View(model);
        }

        public ActionResult LoadStore(int page, int size, string storeCode, string storeName, int country, string enable)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var totalRecord = _service.ListConditionCount(page, size, storeCode, storeName, country, enable);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new StoreViewModel
            {
                UserLogin = _systemService.GetUserAndRole(0, userName),
                StoreManagements = _service.ListCondition(page, size, storeCode, storeName, country, enable),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return PartialView("_StorePartial", model);
        }

        public void ExportToExcel(int page, int size, string storeCode, string storeName, int country, string enable)
        {
            // Get the data to report on
            var masters = _service.ListCondition(page, size, storeCode, storeName, country, enable);
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
            var sheet = workbook.CreateSheet("Store");

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
            cell.SetCellValue("Country");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Address");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Tel.");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Mobile");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Description");
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
            foreach (var master in masters)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(master.Id);
                row.CreateCell(1).SetCellValue(master.Name);
                row.CreateCell(2).SetCellValue(master.Code);
                row.CreateCell(3).SetCellValue(master.Country);
                row.CreateCell(4).SetCellValue(master.Address);
                row.CreateCell(5).SetCellValue(master.Tel);
                row.CreateCell(6).SetCellValue(master.Mobile);
                row.CreateCell(7).SetCellValue(master.Description);
                row.CreateCell(8).SetCellValue(master.Created_Date != null
                                                   ? master.Created_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.Created_Date.ToString());
                row.CreateCell(9).SetCellValue(master.Created_By);
                row.CreateCell(10).SetCellValue(master.Modified_Date != null
                                                   ? master.Modified_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.Modified_Date.ToString());
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

                var saveAsFileName = string.Format("Store-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

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

            if (user.StoreR == 0)
            {
                return RedirectToAction("Index", "Home");
            }

            var item = new Store();

            if (id.HasValue)
            {
                item = _service.GetByKey(id.Value);
            }

            var model = new StoreViewModel
            {
                Id = item.Id,
                Code = item.Code,
                Name = item.Name,
                CountryId = item.CountryId,
                Address = item.Address,
                Tel = item.Tel,
                Phone = item.Phone,
                Description = item.Description,
                Timestamp = item.Timestamp,
                iCreated = item.iCreated,
                dCreated = item.dCreated,
                UserLogin = user,
                Countries = new SelectList(_systemService.CountryList(), "Id", "Name")
            };

            // FUNCTION
            return View(model);
        }

        [HttpPost]
        public JsonResult Create(StoreViewModel model)
        {
            if (model.V3 != true)
            {
                return Json(new { result = Constants.UnSuccess });
            }

            return model.Store.Id == 0 ? CreateData(model) : EditData(model);
        }

        private JsonResult CreateData(StoreViewModel model)
        {
            if (_service.ExistedCode(model.Store.Code))
            {
                return Json(new { result = Constants.DuplicateCode });
            }

            if (_service.ExistedName(model.Store.Name))
            {
                return Json(new { result = Constants.Duplicate });
            }

            try
            {
                model.Store.iEnable = true;
                model.Store.iCreated = model.LoginId;
                model.Store.dCreated = DateTime.Now;
                _service.Insert(model.Store);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Create New Store!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        private JsonResult EditData(StoreViewModel model)
        {
            if (model.CheckCode != model.Store.Code)
            {
                if (_service.ExistedCode(model.Store.Code))
                {
                    return Json(new { result = Constants.DuplicateCode });
                }
            }

            if (model.CheckName != model.Store.Name)
            {
                if (_service.ExistedName(model.Store.Name))
                {
                    return Json(new { result = Constants.Duplicate });
                }
            }

            var entity = _service.GetByKey(model.Store.Id);
            if (!Convert.ToBase64String(model.Store.Timestamp).Equals(Convert.ToBase64String(entity.Timestamp)))
            {
                return Json(new { result = Constants.DataJustChanged });
            }

            try
            {
                entity.Code = model.Store.Code;
                entity.Name = model.Store.Name;
                entity.CountryId = model.Store.CountryId;
                entity.Address = model.Store.Address;
                entity.Tel = model.Store.Tel;
                entity.Phone = model.Store.Phone;
                entity.Description = model.Store.Description;
                entity.iModified = model.LoginId;
                entity.dModified = DateTime.Now;
                _service.Update(entity);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Update Store!", e);
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
