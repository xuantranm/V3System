using System.Globalization;
using Ap.Business.Domains;
using Ap.Common.Constants;
using Ap.Service.Seedworks;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using Vivablast.ViewModels;

namespace Vivablast.Controllers
{
    using System;
    using System.IO;
    using System.Web.Mvc;
    using log4net;

    [Authorize]
    public class ProjectController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(ProjectController).FullName);

        private readonly ISystemService _systemService;
        private readonly IProjectService _service;

        public ProjectController(ISystemService systemService, IProjectService service)
        {
            _systemService = systemService;
            _service = service;
        }

        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = this._systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.ProjectR == 0) return RedirectToAction("Index", "Home");
            var viewModel = new ProjectViewModel
            {
                UserLogin = user,
                Countries = new SelectList(this._systemService.CountryList(), "Id", "Name"),
                Client = new SelectList(this._systemService.ClientProjectList(), "Id", "Name"),
                Suppervisor = new SelectList(this._systemService.SuppervisorList(), "Id", "Name"),
                StatusProject = new SelectList(this._systemService.GetLookUp("projectstatus"), "LookUpKey", "LookUpValue"),
                Projects = new SelectList(this._systemService.ProjectList(), "Id", "vProjectID")
            };
            return View(viewModel);
        }

        public ActionResult LoadProject(int page, int size, string projectCode, string projectName, int country, int status, int client, string fd, string td, string enable)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var totalRecord = _service.ListConditionCount(page, size, projectCode, projectName, country, status, client, fd, td, enable);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            int totalPages = size == 1000 ? 1 : Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new ProjectViewModel
            {
                UserLogin = _systemService.GetUserAndRole(0, userName),
                ProjectGetListResults = _service.ListCondition(page, size, projectCode, projectName, country, status, client, fd, td, enable),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return PartialView("_ProjectPartial", model);
        }

        public void ExportToExcel(int page, int size, string projectCode, string projectName, int country, int status, int client, string fd, string td, string enable)
        {
            // Get the data to report on
            var masters = _service.ListCondition(page, size, projectCode, projectName, country, status, client, fd, td, enable);
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
            cell.SetCellValue("Projet Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("Project Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Country");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Location");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Begin Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("End Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Contact");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Status");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Client");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("Remark");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(11);
            cell.SetCellValue("Created Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(12);
            cell.SetCellValue("Created By");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(13);
            cell.SetCellValue("Modified Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(14);
            cell.SetCellValue("Modified By");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            foreach (var master in masters)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(master.Id);
                row.CreateCell(1).SetCellValue(master.Project_Code);
                row.CreateCell(2).SetCellValue(master.Project_Name);
                row.CreateCell(3).SetCellValue(master.Country);
                row.CreateCell(4).SetCellValue(master.Location);
                row.CreateCell(5).SetCellValue(master.Begin_Date.ToString("dd/MM/yyyy"));
                row.CreateCell(6).SetCellValue(master.End_Date != null
                                                   ? master.End_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.End_Date.ToString());
                row.CreateCell(7).SetCellValue(master.Main_Contact);
                row.CreateCell(8).SetCellValue(master.Status);
                row.CreateCell(9).SetCellValue(master.Client);
                row.CreateCell(10).SetCellValue(master.Remark);
                row.CreateCell(11).SetCellValue(master.Created_Date != null
                                                   ? master.Created_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.Created_Date.ToString());
                row.CreateCell(12).SetCellValue(master.Created_By);
                row.CreateCell(13).SetCellValue(master.Modified_Date != null
                                                   ? master.Modified_Date.Value.ToString("dd/MM/yyyy")
                                                   : master.Modified_Date.ToString());
                row.CreateCell(14).SetCellValue(master.Modified_By);
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

                var saveAsFileName = string.Format("Project-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", saveAsFileName));
                Response.Clear();
                Response.BinaryWrite(exportData.GetBuffer());
                Response.End();
            }
        }

        public ActionResult Detail(int id)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = this._systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.ProjectR == 0) return RedirectToAction("Index", "Home");
            var item = _service.CustomEntity(id);
            var viewModel = new ProjectViewModel
            {
                ProjectCustom = item,
                UserLogin = user
            };
            return View(viewModel);
        }

        public ActionResult TransactionStock(int page, int size, int project, string type, string fd, string td)
        {
            var totalRecord = _systemService.CountListTransactionStockByProject(page, size, project, type, fd, td);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new ProjectViewModel
            {
                StockQuantityManagementResults = _systemService.ListTransactionStockByProject(page, size, project, type, fd, td),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };
            return PartialView("_TransactionStockPartial", model);
        }

        public void ExportTransactionStock(int page, int size, int project, string type, string fd, string td)
        {
            // Get the data to report on
            var masters = _systemService.ListTransactionStockByProject(page, size, project, type, fd, td);
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
            var sheet = workbook.CreateSheet("Project Transaction");

            var projectCodeRow = sheet.CreateRow(0);
            var projectCodeCell = projectCodeRow.CreateCell(0);
            projectCodeCell.SetCellValue("Project Code");
            projectCodeCell.CellStyle = headerLabelCellStyle;

            projectCodeCell = projectCodeRow.CreateCell(1);
            projectCodeCell.SetCellValue("val Project Code");
            projectCodeCell.CellStyle = headerLabelCellStyle;

            var projectNameRow = sheet.CreateRow(1);
            var projectNameCell = projectNameRow.CreateCell(0);
            projectNameCell.SetCellValue("Project Name");
            projectNameCell.CellStyle = headerLabelCellStyle;

            projectNameCell = projectNameRow.CreateCell(1);
            projectNameCell.SetCellValue("val Project Name");
            projectNameCell.CellStyle = headerLabelCellStyle;

            // Add header labels
            var rowIndex = 2;

            // Undestand as row in excel. row + 3 = xuong 3 row.
            var row = sheet.CreateRow(rowIndex);
            var cell = row.CreateCell(0);
            cell.SetCellValue("Action");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("Stock Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Stock Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Quantity Current");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Quantity Change");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Quantity After Change");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Store");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("SIV");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("SRV");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("MRF");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(11);
            cell.SetCellValue("By");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            foreach (var master in masters)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(master.Status);
                row.CreateCell(1).SetCellValue(master.Date.ToString("dd/MM/yyyy"));
                row.CreateCell(2).SetCellValue(master.Stock_Code);
                row.CreateCell(3).SetCellValue(master.Stock_Name);
                row.CreateCell(4).SetCellValue(master.Quantity_Current.ToString());
                row.CreateCell(5).SetCellValue(master.Quantity_Change.ToString());
                row.CreateCell(6).SetCellValue(master.Quantity_After_Change.ToString());
                row.CreateCell(7).SetCellValue(master.ToStore.ToString());
                row.CreateCell(8).SetCellValue(master.SIV);
                row.CreateCell(9).SetCellValue(master.SRV);
                row.CreateCell(10).SetCellValue(master.MRF);
                row.CreateCell(11).SetCellValue(master.User);
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

                var saveAsFileName = string.Format("Project-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

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

            if (user.ProjectR == 0)
            {
                return RedirectToAction("Index", "Home");
            }

            var item = new WAMS_PROJECT
                           {
                               dBeginDate = DateTime.Now
                           };

            if (id.HasValue)
            {
                // If have eror use store procedure
                item = _service.GetByKeySp(id.Value);
            }

            var model = new ProjectViewModel
            {
                Id = item.Id,
                vProjectID = item.vProjectID,
                vProjectName = item.vProjectName,
                vLocation = item.vLocation,
                vMainContact = item.vMainContact,
                vCompanyName = item.vCompanyName,
                dBeginDate = item.dBeginDate.ToString("dd/MM/yyyy"),
                ClientId = item.ClientId,
                CountryId = item.CountryId,
                StoreId = item.StoreId,
                StatusId = item.StatusId,
                vDescription = item.vDescription,
                Timestamp = item.Timestamp,
                iCreated = item.iCreated,
                dCreated = item.dCreated,
                Countries = new SelectList(this._systemService.CountryList(), "Id", "Name"),
                Client = new SelectList(this._systemService.ClientProjectList(), "Id", "Name"),
                Suppervisor = new SelectList(this._systemService.SuppervisorList(), "vWorkerID", "Suppervisor"),
                StatusProject = new SelectList(this._systemService.GetLookUp("projectstatus"), "LookUpKey", "LookUpValue"),
                UserLogin = user
            };

            if (item.dEnd.HasValue)
            {
                model.dEnd = item.dEnd.Value.ToString("dd/MM/yyyy");
            }
            return View(model);
        }

        public ActionResult ListCode(string term)
        {
            return Json(_service.ListCode(term), JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListName(string term)
        {
            return Json(_service.ListName(term), JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult Create(ProjectViewModel model)
        {
            if (model.V3 != true)
            {
                return this.Json(new { result = Constants.UnSuccess });
            }

            return model.Id == 0 ? CreateData(model) : EditData(model);
        }

        private JsonResult CreateData(ProjectViewModel model)
        {
            if (_service.ExistedCode(model.Project.vProjectID))
            {
                return Json(new { result = Constants.DuplicateCode });
            }

            if (_service.ExistedName(model.Project.vProjectName))
            {
                return Json(new { result = Constants.Duplicate });
            }

            try
            {
                model.Project.iEnable = true;
                model.Project.iCreated = model.LoginId;
                model.Project.dCreated = DateTime.Now;
                model.Project.dBeginDate = DateTime.ParseExact(model.dBeginDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                if (!string.IsNullOrEmpty(model.dEnd))
                {
                    model.Project.dEnd = DateTime.ParseExact(model.dEnd, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                }
                _service.Insert(model.Project);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Create New Project!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        private JsonResult EditData(ProjectViewModel model)
        {
            if (model.CheckCode != model.Project.vProjectID)
            {
                if (_service.ExistedCode(model.Project.vProjectID))
                {
                    return Json(new { result = Constants.DuplicateCode });
                }
            }

            if (model.CheckName != model.Project.vProjectName)
            {
                if (_service.ExistedName(model.Project.vProjectName))
                {
                    return Json(new { result = Constants.Duplicate });
                }
            }

            var entity = _service.GetByKey(model.Project.Id);
            if (!Convert.ToBase64String(model.Project.Timestamp).Equals(Convert.ToBase64String(entity.Timestamp)))
            {
                return Json(new { result = Constants.DataJustChanged });
            }

            try
            {
                entity.vProjectID = model.Project.vProjectID;
                entity.vProjectName = model.Project.vProjectName;
                entity.vLocation = model.Project.vLocation;
                entity.vMainContact = model.Project.vMainContact;
                entity.vCompanyName = model.Project.vCompanyName;
                entity.dBeginDate = DateTime.ParseExact(model.dBeginDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                if (!string.IsNullOrEmpty(model.dEnd))
                {
                    entity.dEnd = DateTime.ParseExact(model.dEnd, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                }
                entity.ClientId = model.Project.ClientId;
                entity.CountryId = model.Project.CountryId;
                entity.StoreId = model.Project.StoreId;
                entity.StatusId = model.Project.StatusId;
                entity.vDescription = model.Project.vDescription;
                entity.iModified = model.LoginId;
                entity.dModified = DateTime.Now;
                this._service.Update(entity);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Update Project!", e);
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

        public ActionResult NewClient()
        {
            return PartialView("_ClientPartial", new Project_Client());
        }

        [HttpPost]
        public ActionResult NewClient(Project_Client model)
        {
            if (_service.ExistedClient(model.Name) > 0)
            {
                return Json(new { result = Constants.Duplicate });
            }

            try
            {
                _service.InsertClient(model);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Create New Client!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        public JsonResult LoadClient()
        {
            var objType = _systemService.ClientProjectList();
            var obgType = new SelectList(objType, "Id", "Name");
            return Json(obgType);
        }

        public ActionResult ListNameClient(string term)
        {
            return Json(_service.ListNameClient(term), JsonRequestBehavior.AllowGet);
        }
    }
}