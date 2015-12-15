using Ap.Business.Domains;
using Ap.Common.Security;
using Vivablast.Models;

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
    public class UserController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(UserController).FullName);

        private readonly ISystemService _systemService;
        private readonly IUserService _service;

        public UserController(ISystemService systemService, IUserService service)
        {
            _systemService = systemService;
            _service = service;
        }
        
        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.UserR == 0) return RedirectToAction("Index", "Home");
            var model = new UserViewModel
            {
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"), 
                Deparments = new SelectList(_systemService.GetLookUp(Constants.LuDepartment), "LookUpValue", "LookUpValue"), 
                UserLogin = user
            };

            return View(model);
        }

        public ActionResult LoadUser(int page, int size, int store, string department, string user, string enable)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var totalRecord = _service.ListConditionCount(page, size, store, department, user, enable);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new UserViewModel
            {
                UserLogin = _systemService.GetUserAndRole(0, userName),
                XUserList = _service.ListCondition(page, size, store, department, user, enable),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };
            return PartialView("_UserPartial", model);
        }

        public void ExportToExcel(int page, int size, int store, string department, string user, string enable)
        {
            // Get the data to report on
            var masters = _service.ListCondition(page, size, store, department, user, enable);
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
            var sheet = workbook.CreateSheet("User");

            // Add header labels
            var rowIndex = 0;

            // Undestand as row in excel. row + 3 = xuong 3 row.
            var row = sheet.CreateRow(rowIndex);
            var cell = row.CreateCell(0);
            cell.SetCellValue("User Id");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(1);
            cell.SetCellValue("User Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("First Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Last Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Email");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Tel.");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Mobile");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Department");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Right User");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Right Store");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("Right Project");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(11);
            cell.SetCellValue("Right Stock");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(12);
            cell.SetCellValue("Right Stock Out");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(13);
            cell.SetCellValue("Right Stock In");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(14);
            cell.SetCellValue("Right Stock Return");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(15);
            cell.SetCellValue("Right Stock-Reactive");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(16);
            cell.SetCellValue("Right Service");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(17);
            cell.SetCellValue("Right Requisition");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(18);
            cell.SetCellValue("Right PE");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(19);
            cell.SetCellValue("Right Accounting");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(20);
            cell.SetCellValue("Right Supplier");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(21);
            cell.SetCellValue("Right Price");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(22);
            cell.SetCellValue("Created Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(23);
            cell.SetCellValue("Created By");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(24);
            cell.SetCellValue("Modified Date");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(25);
            cell.SetCellValue("Modified By");
            cell.CellStyle = headerLabelCellStyle;
            rowIndex++;

            // Add data rows
            foreach (var master in masters)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(master.Id.ToString());
                row.CreateCell(1).SetCellValue(master.UserName);
                row.CreateCell(2).SetCellValue(master.FirstName);
                row.CreateCell(3).SetCellValue(master.LastName);
                row.CreateCell(4).SetCellValue(master.Email);
                row.CreateCell(5).SetCellValue(master.Telephone);
                row.CreateCell(6).SetCellValue(master.Mobile);
                row.CreateCell(7).SetCellValue(master.Department);
                row.CreateCell(8).SetCellValue(Constants.Action(master.UserR));
                row.CreateCell(9).SetCellValue(Constants.Action(master.StoreR));
                row.CreateCell(10).SetCellValue(Constants.Action(master.ProjectR));
                row.CreateCell(11).SetCellValue(Constants.Action(master.StockR));
                row.CreateCell(12).SetCellValue(Constants.Action(master.StockOutR));
                row.CreateCell(13).SetCellValue(Constants.Action(master.StockInR));
                row.CreateCell(14).SetCellValue(Constants.Action(master.StockReturnR));
                row.CreateCell(15).SetCellValue(Constants.Action(master.ReActiveStockR));
                row.CreateCell(16).SetCellValue(Constants.Action(master.StockServiceR));
                row.CreateCell(17).SetCellValue(Constants.Action(master.RequisitionR));
                row.CreateCell(18).SetCellValue(Constants.Action(master.PER));
                row.CreateCell(19).SetCellValue(Constants.Action(master.AccountingR));
                row.CreateCell(20).SetCellValue(Constants.Action(master.SupplierR));
                row.CreateCell(21).SetCellValue(Constants.Action(master.PriceR));
                row.CreateCell(22).SetCellValue(master.Created != null
                                                   ? master.Created.Value.ToString("dd/MM/yyyy")
                                                   : master.Created.ToString());
                row.CreateCell(23).SetCellValue(master.CreatedBy.ToString());
                row.CreateCell(24).SetCellValue(master.Modified != null
                                                   ? master.Modified.Value.ToString("dd/MM/yyyy")
                                                   : master.Modified.ToString());
                row.CreateCell(25).SetCellValue(master.ModifiedBy.ToString());
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

                var saveAsFileName = string.Format("User-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", saveAsFileName));
                Response.Clear();
                Response.BinaryWrite(exportData.GetBuffer());
                Response.End();
            }
        }

        public ActionResult Create()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.UserR < 2)
            {
                return RedirectToAction("Index", "Home");
            }
            var userItem = new XUser();
            var model = new UserViewModel
            {
                Id = userItem.Id,
                UserName = userItem.UserName,
                FirstName = userItem.FirstName,
                LastName = userItem.LastName,
                DepartmentId = userItem.DepartmentId,
                Department = userItem.Department,
                Telephone = userItem.Telephone,
                Mobile = userItem.Mobile,
                Email = userItem.Email,
                Enable = userItem.Enable,
                Password = userItem.Password,
                StoreId = userItem.StoreId,
                Store = userItem.Store,
                CreatedBy = userItem.CreatedBy,
                Created = userItem.Created,
                UserR = userItem.UserR,
                ProjectR = userItem.ProjectR,
                StoreR = userItem.StoreR,
                StockR = userItem.StockR,
                RequisitionR = userItem.RequisitionR,
                StockOutR = userItem.StockOutR,
                StockReturnR = userItem.StockReturnR,
                StockInR = userItem.StockInR,
                ReActiveStockR = userItem.ReActiveStockR,
                StockTypeR = userItem.StockTypeR,
                CategoryR = userItem.CategoryR,
                PER = userItem.PER,
                SupplierR = userItem.SupplierR,
                PriceR = userItem.PriceR,
                StockServiceR = userItem.StockServiceR,
                AccountingR = userItem.AccountingR,
                MaintenanceR = userItem.MaintenanceR,
                WorkerR = userItem.WorkerR,
                ShippmentR = userItem.ShippmentR,
                ReturnSupplierR = userItem.ReturnSupplierR,
                Timestamp = userItem.Timestamp,
                UserLogin = user,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Deparments = new SelectList(_systemService.GetLookUp(Constants.LuDepartment), Constants.LookUpKey, Constants.LookUpValue),
                Rights = new SelectList(_systemService.GetLookUp(Constants.LuRight), Constants.LookUpKey, Constants.LookUpValue)
            };

            // FUNCTION
            return View(model);
        }

        public ActionResult Edit(int id)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.UserR < 3)
            {
                return RedirectToAction("Index", "Home");
            }
            var userItem = _systemService.GetUserAndRole(id, string.Empty);
            var model = new UserViewModel
            {
                Id = userItem.Id,
                UserName = userItem.UserName,
                FirstName = userItem.FirstName,
                LastName = userItem.LastName,
                DepartmentId = userItem.DepartmentId,
                Department = userItem.Department,
                Telephone = userItem.Telephone,
                Mobile = userItem.Mobile,
                Email = userItem.Email,
                Enable = userItem.Enable,
                Password = userItem.Password,
                StoreId = userItem.StoreId,
                Store = userItem.Store,
                CreatedBy = userItem.CreatedBy,
                Created = userItem.Created,
                UserR = userItem.UserR,
                ProjectR = userItem.ProjectR,
                StoreR = userItem.StoreR,
                StockR = userItem.StockR,
                RequisitionR = userItem.RequisitionR,
                StockOutR = userItem.StockOutR,
                StockReturnR = userItem.StockReturnR,
                StockInR = userItem.StockInR,
                ReActiveStockR = userItem.ReActiveStockR,
                StockTypeR = userItem.StockTypeR,
                CategoryR = userItem.CategoryR,
                PER = userItem.PER,
                SupplierR = userItem.SupplierR,
                PriceR = userItem.PriceR,
                StockServiceR = userItem.StockServiceR,
                AccountingR = userItem.AccountingR,
                MaintenanceR = userItem.MaintenanceR,
                WorkerR = userItem.WorkerR,
                ShippmentR = userItem.ShippmentR,
                ReturnSupplierR = userItem.ReturnSupplierR,
                Timestamp = userItem.Timestamp,
                UserLogin = user,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Deparments = new SelectList(_systemService.GetLookUp(Constants.LuDepartment), Constants.LookUpKey, Constants.LookUpValue),
                Rights = new SelectList(_systemService.GetLookUp(Constants.LuRight), Constants.LookUpKey, Constants.LookUpValue)
            };

            // FUNCTION
            return View(model);
        }

        public ActionResult ListUserName(string term)
        {
            return Json(_service.ListName(term), JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListEmail(string term)
        {
            return Json(_service.ListEmail(term), JsonRequestBehavior.AllowGet);
        }

        public ActionResult CheckEmail(string email, string currentEmail)
        {
            return string.IsNullOrEmpty(currentEmail) ? Json(new {result = !_service.ExistedEmail(email)}) : Json(email != currentEmail ? new { result = !_service.ExistedEmail(email) } : new { result = true });
        }

        [HttpPost]
        public ActionResult Create(UserViewModel viewModelBuilder)
        {
            return viewModelBuilder.V3 != true ? Json(new { result = Constants.UnSuccess }) : CreateResultJson(viewModelBuilder);
        }

        private JsonResult CreateResultJson(UserViewModel viewModel)
        {
            if (_service.ExistedName(viewModel.Entity.UserName))
            {
                return Json(new { result = Constants.Duplicate });
            }

            if (_service.ExistedEmail(viewModel.Entity.Email))
            {
                return Json(new { result = Constants.DuplicateEmail });
            }

            try
            {
                viewModel.Entity.Enable = true;
                viewModel.Entity.Password = UserCommon.CreateHash(viewModel.Entity.Password);
                viewModel.Entity.CreatedBy = viewModel.LoginId;
                viewModel.Entity.Created = DateTime.Now;

                _service.Insert(viewModel.Entity);

                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Create New User!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        [HttpPost]
        public ActionResult Edit(UserViewModel viewModelBuilder)
        {
            return viewModelBuilder.V3 != true ? Json(new { result = Constants.UnSuccess }) : EditResultJson(viewModelBuilder);
        }

        private JsonResult EditResultJson(UserViewModel viewModel)
        {
            if (viewModel.CheckName != viewModel.Entity.UserName)
            {
                if (_service.ExistedName(viewModel.Entity.UserName))
                {
                    return Json(new { result = Constants.Duplicate });
                }
            }
            if (viewModel.EmailCurrent != viewModel.Entity.Email)
            {
                if (_service.ExistedEmail(viewModel.Entity.Email))
                {
                    return Json(new { result = Constants.DuplicateEmail });
                }
            }
            var user = _service.GetByKey(viewModel.Entity.Id);
            if (!Convert.ToBase64String(viewModel.Entity.Timestamp).Equals(Convert.ToBase64String(user.Timestamp)))
            {
                return Json(new { result = Constants.DataJustChanged });
            }

            try
            {
                //user.Id = viewModel.Entity.Id;
                user.UserName = viewModel.Entity.UserName;
                user.FirstName = viewModel.Entity.FirstName;
                user.LastName = viewModel.Entity.LastName;
                user.DepartmentId = viewModel.Entity.DepartmentId;
                user.Department = viewModel.Entity.Department;
                user.Telephone = viewModel.Entity.Telephone;
                user.Mobile = viewModel.Entity.Mobile;
                user.Email = viewModel.Entity.Email;
                //user.Enable = viewModel.Entity.Enable;
                user.Password = !string.IsNullOrEmpty(viewModel.Entity.Password) ? UserCommon.CreateHash(viewModel.Entity.Password) : viewModel.PasswordCurrent;
                user.StoreId = viewModel.Entity.StoreId;
                user.Store = viewModel.Entity.Store;
                //user.CreatedBy = viewModel.Entity.CreatedBy;
                //user.Created = viewModel.Entity.Created;
                user.UserR = viewModel.Entity.UserR;
                user.ProjectR = viewModel.Entity.ProjectR;
                user.StoreR = viewModel.Entity.StoreR;
                user.StockR = viewModel.Entity.StockR;
                user.RequisitionR = viewModel.Entity.RequisitionR;
                user.StockOutR = viewModel.Entity.StockOutR;
                user.StockReturnR = viewModel.Entity.StockReturnR;
                user.StockInR = viewModel.Entity.StockInR;
                user.ReActiveStockR = viewModel.Entity.ReActiveStockR;
                user.StockTypeR = viewModel.Entity.StockTypeR;
                user.CategoryR = viewModel.Entity.CategoryR;
                user.PER = viewModel.Entity.PER;
                user.SupplierR = viewModel.Entity.SupplierR;
                user.PriceR = viewModel.Entity.PriceR;
                user.StockServiceR = viewModel.Entity.StockServiceR;
                user.AccountingR = viewModel.Entity.AccountingR;
                user.MaintenanceR = viewModel.Entity.MaintenanceR;
                user.WorkerR = viewModel.Entity.WorkerR;
                user.ShippmentR = viewModel.Entity.ShippmentR;
                user.ReturnSupplierR = viewModel.Entity.ReturnSupplierR;
                //user.Password = 
                user.ModifiedBy = viewModel.LoginId;
                user.Modified = DateTime.Now;

                _service.Update(user);
                return Json(new { result = Constants.Success });
            }
            catch (Exception e)
            {
                Log.Error("Update User!", e);
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

        public ActionResult Detail(int id)
        {
            return View(_service.GetByKey(id));
        }

       
    }
}