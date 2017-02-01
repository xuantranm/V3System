using ImageProcessor;
using ImageProcessor.Imaging;
using ImageProcessor.Imaging.Formats;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;

namespace Vivablast.Controllers
{
    using System.Collections.Generic;
    using System.Web.Configuration;
    using Ap.Business.Domains;
    using Ap.Common.Constants;
    using Ap.Common.Enums;
    using Ap.Service.Seedworks;
    using ViewModels;
    using System;
    using System.Drawing;
    using System.IO;
    using System.Web;
    using System.Web.Mvc;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using log4net;

    [Authorize]
    public class StockController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(StockController).FullName);

        private readonly ISystemService _systemService;
        private readonly IStockService _service;

        public StockController(ISystemService systemService, IStockService service)
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
            model.StoreVs = _systemService.StoreList();
            model.UserLogin = _systemService.GetUserAndRole(0, System.Web.HttpContext.Current.User.Identity.Name);

            return PartialView("_StockPartial", model);
        }

        public void ExportToExcel(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable)
        {
            // Get the data to report on
            var masters = _service.StockViewModelFilter(page, size, stockCode, stockName, store, type, category, enable);
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
            cell.SetCellValue("Stock Code");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(2);
            cell.SetCellValue("Stock Name");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(3);
            cell.SetCellValue("Accounting No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(4);
            cell.SetCellValue("Stock Type");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(5);
            cell.SetCellValue("Unit");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(6);
            cell.SetCellValue("Category");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(7);
            cell.SetCellValue("Weight");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(8);
            cell.SetCellValue("Ral No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(9);
            cell.SetCellValue("Part No");
            cell.CellStyle = headerLabelCellStyle;

            cell = row.CreateCell(10);
            cell.SetCellValue("Color");
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
            foreach (var master in masters.StockVs)
            {
                row = sheet.CreateRow(rowIndex);
                row.CreateCell(0).SetCellValue(master.Id);
                row.CreateCell(1).SetCellValue(master.vStockID);
                row.CreateCell(2).SetCellValue(master.vStockName);
                row.CreateCell(3).SetCellValue(master.vAccountCode);
                row.CreateCell(4).SetCellValue(master.Type);
                row.CreateCell(5).SetCellValue(master.Unit);
                row.CreateCell(6).SetCellValue(master.Category);
                row.CreateCell(7).SetCellValue(master.bWeight.ToString());
                row.CreateCell(8).SetCellValue(master.RalNo);
                row.CreateCell(9).SetCellValue(master.PartNo);
                row.CreateCell(10).SetCellValue(master.ColorName);
                row.CreateCell(11).SetCellValue(master.dCreated != null
                                                   ? master.dCreated.Value.ToString("dd/MM/yyyy")
                                                   : master.dCreated.ToString());
                row.CreateCell(12).SetCellValue(master.Created_By);
                row.CreateCell(13).SetCellValue(master.dModified != null
                                                   ? master.dModified.Value.ToString("dd/MM/yyyy")
                                                   : master.dModified.ToString());
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

                var saveAsFileName = string.Format("Stock-{0}.xls", DateTime.Now.ToString("ddMMyyyyHHmmss")).Replace("/", "-");

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", saveAsFileName));
                Response.Clear();
                Response.BinaryWrite(exportData.GetBuffer());
                Response.End();
            }
        }

        #region Load Condition & Autocomplete
        public JsonResult LoadStockCodeByType(int type, int category)
        {
            var data = _service.NewStockCode(type,category);
            return Json(data);
        }

        public ActionResult ListCode(string term)
        {
            return Json(_service.ListCode(term), JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListName(string term)
        {
            return Json(_service.ListName(term), JsonRequestBehavior.AllowGet);
        }

        public JsonResult LoadCategoryByType(int type)
        {
            var objType = _systemService.CategoryStockList(type);
            var obgType = new SelectList(objType, "Id", "Name", 0);
            return Json(obgType);
        }

        public JsonResult LoadUnitByType(int type)
        {
            var objType = _systemService.UnitStockList(type);
            var obgType = new SelectList(objType, "Id", "Name", 0);
            return Json(obgType);
        }

        public JsonResult LoadLabelByType(int type)
        {
            var objType = _systemService.LabelStockList(type);
            var obgType = new SelectList(objType, "Id", "Name", 0);
            return Json(obgType);
        }

        #endregion

        public ActionResult Create(int? id)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null)
            {
                return RedirectToAction("Index", "Login");
            }

            if (user.StockR == 0)
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
        public JsonResult Create(StockViewModel model)
        {
            if (model.V3 != true)
            {
                return Json(new { result = Constants.UnSuccess });
            }

            return model.Stock.Id == 0 ? CreateData(model) : EditData(model);
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
                return Json(new { result = Constants.Success, id= model.Stock.Id });
            }
            catch (Exception e)
            {
                Log.Error("Create New Stock!", e);
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
                Log.Error("Update Stock!", e);
                return Json(new { result = Constants.UnSuccess });
            }
        }

        public ActionResult Manage(int? id)
        {
            if (!id.HasValue)
            {
                id = 0;
            }

            var information = _systemService.GetStockInformation(id.Value, 0);
            var model = new StockViewModel
            {
                StockInformation = information,
                iType = information.TypeId,
                bCategoryID = information.CategoryId,
                vStockName = information.Stock_Name,
                vStockID = information.Stock_Code,
                Stores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Types = new SelectList(_systemService.TypeStockList(), "Id", "Name"),
                Categories = new SelectList(_systemService.CategoryStockList(0), "Id", "Name"),
                Units = new SelectList(_systemService.UnitStockList(0), "Id", "Name"),
                Positions = new SelectList(_systemService.PositionStockList(), "Id", "Name"),
                //Labels = new SelectList(_systemService.LabelStockList(0), "Id", "Name")
            };
            return View(model);
        }

        public ActionResult GetStockManagementQty(int page, int size, string stockCode, string stockName, string store, int type, int category, string fd, string td, string enable)
        {
            var totalRecord = _service.ListStockQuantityCount(page, size, stockCode, stockName, store, type, category, fd, td, enable);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new StockViewModel
                            {
                                StockQuantityManagementResults = _service.ListStockQuantity(page, size, stockCode, stockName, store, type, category, fd, td, enable),
                                TotalRecords = Convert.ToInt32(totalRecord),
                                TotalPages = totalPages,
                                CurrentPage = page,
                                PageSize = size
                            };
            return PartialView("_LstQtyMngPartial", model);
        }

        public void QtyExportToExcel(int page, int size, string stockCode, string stockName, string store, int type, int category, string fd, string td, string enable)
        {
            try
            {
                var grid = new GridView
                {
                    DataSource = _service.ListStockQuantity(page, size, stockCode, stockName, store, type, category, fd, td, enable)
                };

                grid.DataBind();

                Response.ClearContent();
                var fileName = "QtyStockList_" + DateTime.Now.ToString("ddMMyyyyHHmmss");
                Response.AddHeader("content-disposition", "attachment; filename=" + fileName + ".xls");
                Response.ContentType = "application/excel";
                var sw = new StringWriter();
                var htw = new HtmlTextWriter(sw);

                // Change the Header Row back to white color
                grid.HeaderRow.BackColor = Color.Red;
                grid.HeaderRow.ForeColor = Color.White;

                for (int i = 0; i < grid.Rows.Count; i++)
                {
                    GridViewRow row = grid.Rows[i];

                    // Change Color back to white and fore color to black
                    row.BackColor = Color.White;
                    row.ForeColor = Color.Black;

                    // Apply text style to each row using styles class
                    row.Attributes.Add("class", "classname");

                    // Applying style to Alternating Row back to magenta and fore color to white
                    if (i % 2 != 0)
                    {
                        row.BackColor = Color.PowderBlue;
                        row.ForeColor = Color.Black;
                    }
                }

                grid.RenderControl(htw);

                Response.Write(sw.ToString());

                Response.End();
            }
            catch (Exception ex) { }

        }

        public JsonResult Delete(int id)
        {
            if (_service.CheckDelete(id) == 1)
            {
                _service.DeActive(id);
                return Json(new { result = false });
            }

            var fag = _service.Delete(id);
            return Json(fag == 0 ? new { result = true } : new { result = false });
        }

        #region DOCUMENT

        public JsonResult LoadDocuments(int? id)
        {
            var result = new List<Document>();
            if (id.HasValue)
            {
                var pictures = _systemService.GetDocumentList(id.Value, (int)DocumentType.StockPicture);
                foreach (var picture in pictures)
                {
                    if (System.IO.File.Exists(Server.MapPath(WebConfigurationManager.AppSettings["PathImg"] + picture.DocumentURL)))
                    {
                        result.Add(picture);
                    }
                }
            }

            return this.Json(result);
        }

        [HttpPost]
        public ActionResult UploadDocument(HttpPostedFileBase file, int id, int loginId)
        {
            if ((file == null) || (file.ContentLength <= 0))
                return Json(new { result = false, message = "File does not exist." });
            var fileName = Path.GetFileName(file.FileName);

            if (!_systemService.CheckValidPictureExtension(fileName))
            {
                return Json(new
                {
                    result = false,
                    message = "Invalid file. Unfortunately it was not possible to upload the file because it is not supported by our system. We are able to accept documents in the following formats: .jpg; .jpeg"
                });
            }
            // check file size
            if (file.ContentLength > Convert.ToInt64(WebConfigurationManager.AppSettings["fileSize"]))
            {
                return Json(new { result = false, message = "File size is more than 3 MB, cannot be uploaded" });
            }

            var fileExtend = Path.GetExtension(fileName);
            var nameUrl = Path.GetFileNameWithoutExtension(fileName) + "_" + id + "_" + DateTime.Now.ToString("ddMMyyyyHHmmss");
            var documentUrl = nameUrl + fileExtend;
            var saveLocation = WebConfigurationManager.AppSettings["PathImg"];
            var fullFilePath = _systemService.GetDocumentUrl(saveLocation, nameUrl, fileExtend);
            try
            {
                file.SaveAs(Server.MapPath(fullFilePath));
            }
            catch (Exception e)
            {
                return Json(new { result = false, message = e.Message });
            }

            // Save to db
            var fag = this._systemService.InsertDocument(documentUrl, string.Empty, id, (int)DocumentType.StockPicture, fileName, string.Empty, saveLocation, new byte(), loginId);
            return Json(fag == 0 ? new { result = true } : new { result = false });
        }

        [HttpPost]
        public JsonResult DeleteDocument(int id, string fileName)
        {
            try
            {
                // Delete file and no need delete directory
                if (System.IO.File.Exists(Server.MapPath(WebConfigurationManager.AppSettings["PathImg"] + fileName)))
                {
                    System.IO.File.Delete(Server.MapPath(WebConfigurationManager.AppSettings["PathImg"] + fileName));
                }

                var fag = _systemService.DeleteDocument(id);
                return Json(fag == 0 ? new { result = true } : new { result = false });
            }
            catch (Exception e)
            {
                return this.Json(new { result = false });
            }
        }

        #endregion

        public ActionResult StockType()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = this._systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.StockR == 0) return RedirectToAction("Index", "Home");
            var model = new StoreViewModel
            {
                Countries = new SelectList(_systemService.CountryList(), "Id", "Name"),
                UserLogin = user
            };
            return View(model);
        }

        #region File Extend
        static byte[] ImageToByteArray(System.Drawing.Image imageIn)
        {
            using (var ms = new MemoryStream())
            {
                imageIn.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                return ms.ToArray();
            }
        }
        static byte[] Overlay(byte[] photo, System.Drawing.Image overlay, int offset, int quality = 100, int opacity = 100)
        {
            var position = new Point();
            using (var ms = new MemoryStream(photo))
            {
                var image = System.Drawing.Image.FromStream(ms);
                position.X = image.Width - overlay.Width - offset;
                position.Y = image.Height - overlay.Height - offset;
            }

            var imagelayer = new ImageLayer
            {
                Image = overlay,
                Position = position,
                Opacity = opacity
            };

            using (var inStream = new MemoryStream(photo))
            {
                using (var outStream = new MemoryStream())
                {
                    using (var imageFactory = new ImageFactory(preserveExifData: true))
                    {
                        imageFactory.Load(inStream)
                            .Overlay(imagelayer)
                            .Format(new JpegFormat())
                            .Quality(quality)
                            .BackgroundColor(Color.White)
                            .Save(outStream);

                        return outStream.ToArray();
                    }
                }
            }
        }

        //public void UploadPictureBase64(ProjectBankCreateViewModel model, int id)
        //{
        //    if (model.File64S == null)
        //    {
        //        return;
        //    }
        //    var type = Common.Business.Bank;

        //    var uploadFolderNoneMapPath = Utilities.DirectoryPhysical(string.Empty) + DateTime.Now.Day + DateTime.Now.Month + "/";
        //    //Set mappath
        //    var uploadFolder = Server.MapPath(uploadFolderNoneMapPath);
        //    if (!Directory.Exists(uploadFolder))
        //        Directory.CreateDirectory(uploadFolder);

        //    int i = 0;
        //    int pi = 0;
        //    foreach (var file64 in model.File64S)
        //    {
        //        var idPicture = model.FileIds[i];
        //        var title = string.IsNullOrEmpty(model.Titles[i]) ? String.Empty : model.Titles[i];
        //        var main = Convert.ToInt32(model.Mains[i]);

        //        var position = (pi + 1);
        //        if (model.FilePositions.Contains(position))
        //        {
        //            pi = model.FilePositions.Max() + 1;
        //            position = pi;
        //        }

        //        if (!string.IsNullOrEmpty(file64))
        //        {
        //            #region New File
        //            var orginalName = file64.Split(',')[0];
        //            var file = file64.Split(',')[2];
        //            var photoByte = Convert.FromBase64String(file);
        //            const string format = "jpg";
        //            //model.Main = model.Main;
        //            var picture = new FileViewModel
        //            {
        //                File =
        //                    new File
        //                    {
        //                        ObjectId = id,
        //                        Type = type,
        //                        OrginalName = orginalName,
        //                        Title = title,
        //                        FileType = format,
        //                        Main = main,
        //                        Position = position,
        //                        Path = uploadFolderNoneMapPath
        //                    }
        //            };
        //            var cache = new MemoryCache("watermark");
        //            var watermark = (byte[])cache.Get("watermark");
        //            if (watermark == null)
        //            {
        //                var policy = new CacheItemPolicy
        //                {
        //                    UpdateCallback = null,
        //                    SlidingExpiration = new TimeSpan(364, 23, 59, 59, 0)
        //                };
        //                watermark = ImageToByteArray(Image.FromFile(Server.MapPath("~/images/watermark.png")));
        //                cache.Add("watermark", watermark, policy);
        //            }

        //            Image newImage;

        //            using (var ms = new MemoryStream(watermark))
        //            {
        //                newImage = Image.FromStream(ms);
        //            }
        //            var photoBytes = Overlay(photoByte, newImage, 20);
        //            var settings = new ResizeSettings { Scale = ScaleMode.DownscaleOnly, Format = format };

        //            // filename with placeholder for size
        //            if (picture.GetConvertedFileName() == null ||
        //                string.IsNullOrWhiteSpace(picture.GetConvertedFileName()))
        //            {
        //                //picture.SetFileName(DateTime.Now.Day + DateTime.Now.Month + "_" + picture.CreateFilename() + "_{0}." + format);
        //                //picture.File.FileName = DateTime.Now.Day + DateTime.Now.Month + "_" + picture.CreateFilename() + "_{0}." + format;

        //                // Use for change name to display image 2, 3, 4,...
        //                picture.SetFileName(position + "_" + type + id + "_{0}." + format);
        //                picture.File.FileName = position + "_" + type + id + "_853." + format;
        //            }

        //            // First, we save the original image without any watermarking
        //            if (!System.IO.File.Exists(picture.GetFilePathPhysical(FileViewModel.PictureSize.Original)))
        //            {
        //                settings.MaxWidth = 1024;
        //                settings.MaxHeight = 768;
        //                ImageBuilder.Current.Build(photoBytes,
        //                    uploadFolder + picture.SetFileName(FileViewModel.PictureSize.Original),
        //                    settings,
        //                    false, false);

        //                // save biggest version as original
        //                //if (string.IsNullOrWhiteSpace(picture.OriginalFilepath))
        //                //    picture.FileName = picture.GetFilePath(FileViewModel.PictureSize.Original);

        //                // reset if a seekable stream. Will fail on the next resizing if not seekable
        //            }

        //            if (!System.IO.File.Exists(picture.GetFilePathPhysical(FileViewModel.PictureSize.Large)))
        //            {
        //                var dest = uploadFolder + picture.SetFileName(FileViewModel.PictureSize.Large);
        //                //var dest = uploadFolder + fileName + "_" + FileViewModel.PictureSize.Large;
        //                settings.MaxWidth = 1024;
        //                settings.MaxHeight = 768;
        //                if (picture.WaterMarkLarge == FileViewModel.WatermarkType.None)
        //                    ImageBuilder.Current.Build(photoBytes, dest, settings, false, false);
        //                // save biggest version as original
        //                //if (string.IsNullOrWhiteSpace(picture.File.Path))
        //                //    picture.File.Path = picture.GetFilePath(FileViewModel.PictureSize.Large);
        //            }

        //            if (!System.IO.File.Exists(picture.GetFilePathPhysical(FileViewModel.PictureSize.Medium)))
        //            {
        //                var dest = uploadFolder + picture.SetFileName(FileViewModel.PictureSize.Medium);
        //                //var dest = uploadFolder + fileName + FileViewModel.PictureSize.Medium;
        //                settings.MaxWidth = 631;
        //                settings.MaxHeight = 394;
        //                if (picture.WaterMarkLarge == FileViewModel.WatermarkType.None)
        //                    ImageBuilder.Current.Build(photoBytes, dest, settings, false, false);
        //                // save biggest version as original
        //                //if (string.IsNullOrWhiteSpace(picture.File.Path))
        //                //    picture.File.Path = picture.GetFilePath(FileViewModel.PictureSize.Medium);
        //            }

        //            if (!System.IO.File.Exists(picture.GetFilePathPhysical(FileViewModel.PictureSize.Small)))
        //            {
        //                var dest = uploadFolder + picture.SetFileName(FileViewModel.PictureSize.Small);
        //                //var dest = uploadFolder + fileName + FileViewModel.PictureSize.Small;
        //                settings.MaxWidth = 214;
        //                settings.MaxHeight = 133;
        //                if (picture.WaterMarkLarge == FileViewModel.WatermarkType.None)
        //                    ImageBuilder.Current.Build(photoBytes, dest, settings, false, false);
        //                // save biggest version as original
        //                //if (string.IsNullOrWhiteSpace(picture.File.Path))
        //                //    picture.File.Path = picture.GetFilePath(FileViewModel.PictureSize.Small);
        //            }

        //            if (!System.IO.File.Exists(picture.GetFilePathPhysical(FileViewModel.PictureSize.Tiny)))
        //            {
        //                var dest = uploadFolder + picture.SetFileName(FileViewModel.PictureSize.Tiny);
        //                //var dest = uploadFolder + fileName + FileViewModel.PictureSize.Tiny;
        //                settings.MaxWidth = 110;
        //                settings.MaxHeight = 110;
        //                if (picture.WaterMarkLarge == FileViewModel.WatermarkType.None)
        //                    ImageBuilder.Current.Build(photoBytes, dest, settings, false, false);
        //                // save biggest version as original
        //                //if (string.IsNullOrWhiteSpace(picture.File.Path))
        //                //    picture.File.Path = picture.GetFilePath(FileViewModel.PictureSize.Tiny);
        //            }
        //            // INSERT INTO DB
        //            _projectService.InsertUpdateFile(picture.File);
        //            #endregion
        //        }
        //        else
        //        {
        //            _projectService.UpdateFile(idPicture, title, main, model.FilePositions[i]);
        //        }
        //        i++;
        //        pi++;
        //        //return Json(true);
        //    }
        //}

        //public void DeletePhysical(string picture)
        //{
        //    if (picture == null)
        //        return;
        //    var sizes = new List<string>
        //    {
        //        ((int)FileViewModel.PictureSize.Original).ToString(),
        //        ((int)FileViewModel.PictureSize.Large).ToString(),
        //        ((int)FileViewModel.PictureSize.Medium).ToString(),
        //        ((int)FileViewModel.PictureSize.Small).ToString(),
        //        ((int)FileViewModel.PictureSize.Tiny).ToString(),
        //    };
        //    foreach (var dir in sizes.Select(size => Server.MapPath(String.Format(picture, size))))
        //    {
        //        System.IO.File.Delete(dir);
        //    }
        //}
        #endregion
    }
}