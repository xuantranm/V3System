using System.Linq;
using Ap.Common.Constants;
using Ap.Common.Enums;

namespace Vivablast.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Web;
    using System.Web.Configuration;
    using System.Web.Mvc;
    using Ap.Business.Domains;
    using Ap.Service.Seedworks;
    using Newtonsoft.Json;
    using ViewModels;

    public class AjaxController : Controller
    {
        private readonly ISystemService _systemService;
        private readonly IStockService _stockService;

        public AjaxController(ISystemService systemService, IStockService stockService)
        {
            _systemService = systemService;
            _stockService = stockService;
        }
        
        #region Upload Document Controls
        public ActionResult Document(int id, int type)
        {
            var files = _systemService.GetDocumentList(id, type);

            var fileList = files.Select(s => new FileViewModel
            {
                FileId = s.Id,
                FileGuid = s.DocumentURL,
                FileName = s.DocumentName,
                ActionDate = s.ActionDate.ToString("MM/dd/yyyy"),
                Description = s.DocumentTitle
            });
            var document = new DocumentViewModel
            {
                FileList = fileList.ToList(),
                KeyId = id,
                DocumentCategoryId = type
            };

            return PartialView(type == (int) DocumentType.StockPicture ? "Partials/UploadPicture" : "Partials/UploadDocument", document);
        }

        public ActionResult UploadPicture(int? id, int type)
        {
            var result = new List<Document>();
            if (id.HasValue)
            {
                var pictures = _systemService.GetDocumentList(id.Value, type);
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
        public ActionResult UploadFile(HttpPostedFileBase file, int id, int type, int loginId)
        {
            if ((file == null) || (file.ContentLength <= 0))
                return Json(new { result = false, message = "File does not exist." });
            var fileName = Path.GetFileName(file.FileName);
            var validateFile = type == (int) DocumentType.StockPicture ? _systemService.CheckValidPictureExtension(fileName) : _systemService.CheckValidExtension(fileName);
            if (!validateFile)
            {
                const string messageErrorPicture = "Invalid file. Unfortunately it was not possible to upload the file because it is not supported by our system. We are able to accept documents in the following formats: .jpg; .jpeg; .gif; .png.";
                const string messageErrorDocument = "Invalid file. Unfortunately it was not possible to upload the file because it is not supported by our system. We are able to accept documents in the following formats: .txt; .doc; .xls; .csv; .pdf; .docx; .xlsx; .jpg; .jpeg; .gif; .png.";
                var message = type == (int)DocumentType.StockPicture ? messageErrorPicture : messageErrorDocument;
                return Json(new
                {
                    result = false,
                    message
                });
            }
            // check file size
            var maxPictureSize = Convert.ToInt64(WebConfigurationManager.AppSettings["PictureSize"]);
            var maxDocumentSize = Convert.ToInt64(WebConfigurationManager.AppSettings["DocumentSize"]);
            var maxFile = type == (int) DocumentType.StockPicture ? maxPictureSize : maxDocumentSize;
            if (file.ContentLength > maxFile * 1024)
            {
                return Json(new { result = false, message = "File size is more than " + maxFile + " bytes ("+ maxFile/1024 +" Mb), cannot be uploaded" });
            }

            var fileExtend = Path.GetExtension(fileName);
            var nameUrl = Path.GetFileNameWithoutExtension(fileName) + "_" + id + "_" + DateTime.Now.ToString("ddMMyyyyHHmmss");
            var documentUrl = nameUrl + fileExtend;
            var saveLocation = type == (int)DocumentType.StockPicture ? WebConfigurationManager.AppSettings["PathImg"] : WebConfigurationManager.AppSettings["PathDoc"];
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
            var document = _systemService.AddDocument(documentUrl, string.Empty, id, type, fileName, string.Empty, saveLocation, new byte(), loginId);
            var fileViewModel = new FileViewModel()
            {
                FileId = document.Id,
                FileGuid = documentUrl,
                FileName = fileName,
                //FileSize = Math.Round((float)file.ContentLength / 1048576, 2).ToString(),
                FileSource = fullFilePath,
                ActionDate = DateTime.Now.ToString("MM/dd/yyyy")
            };
            return Json(new { result = true, file = fileViewModel });
        }

        [HttpPost]
        public ActionResult DeleteFiles(string data)
        {
            var files = JsonConvert.DeserializeObject<List<string>>(data ?? string.Empty);
            try
            {
                foreach (var item in files)
                {
                    var id = Convert.ToInt32(item.Split(';')[0]);
                    var guidFile = item.Split(';')[1];
                    var type = Convert.ToInt32(item.Split(';')[2]);
                    _systemService.DeleteDocument(id);

                    // Delete physical
                    // Delete file and no need delete directory
                    if (type == (int) DocumentType.StockPicture)
                    {
                        if (System.IO.File.Exists(Server.MapPath(WebConfigurationManager.AppSettings["PathImg"] + guidFile)))
                        {
                            System.IO.File.Delete(Server.MapPath(WebConfigurationManager.AppSettings["PathImg"] + guidFile));
                        }
                    }
                    else
                    {
                        if (System.IO.File.Exists(Server.MapPath(WebConfigurationManager.AppSettings["PathDoc"] + guidFile)))
                        {
                            System.IO.File.Delete(Server.MapPath(WebConfigurationManager.AppSettings["PathDoc"] + guidFile));
                        }
                    }
                }

                return Json(new { result = true });
            }
            catch (Exception ex)
            {
                return Json(new { result = false, message = ex.Message });
            }
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Download(int id)
        {
            var document = GetDocumentWithBinary(id);
            if (document != null && document.DocumentFile != null)
            {
                var stream = new MemoryStream(document.DocumentFile);
                string contentType = _systemService.GetContentType(Path.GetExtension(document.DocumentName));
                var result = new FileStreamResult(stream, contentType);
                result.FileDownloadName = document.DocumentName;
                return result;
            }

            return null;
        }

        public Document GetDocumentWithBinary(int id)
        {
            var document = _systemService.GetDocumentById(id);

            if (document != null)
            {
                var filePath = Server.MapPath(WebConfigurationManager.AppSettings["PathDoc"] + document.DocumentURL);
                var file = new FileInfo(filePath);
                if (file.Exists)
                {
                    if (file.Length >= Constants.BigFileSize)
                        throw new Exception(Constants.ErrorFileTooBig);

                    document.DocumentFile = System.IO.File.ReadAllBytes(filePath);
                }
            }

            return document;
        }

        public ActionResult LoadPictureStock(int id, int type)
        {
            var files = _systemService.GetDocumentList(id, type);

            var fileList = files.Select(s => new FileViewModel
            {
                FileId = s.Id,
                FileGuid = s.DocumentURL,
                FileName = s.DocumentName,
                ActionDate = s.ActionDate.ToString("MM/dd/yyyy"),
                Description = s.DocumentTitle
            });
            var document = new DocumentViewModel
            {
                FileList = fileList.ToList(),
                KeyId = id,
                DocumentCategoryId = type
            };

            return PartialView(type == (int)DocumentType.StockPicture ? "Partials/LoadPictureStock" : "Partials/UploadDocument", document);
        }
        #endregion

        #region Stock Search
        public ActionResult SearchStock()
        {
            var model = new StockViewModel
            {
                Stores = new SelectList(this._systemService.StoreList(), "Id", "Name"),
                Types = new SelectList(this._systemService.TypeStockList(), "Id", "Name"),
                Categories = new SelectList(this._systemService.CategoryStockList(0), "Id", "Name"),
                Units = new SelectList(this._systemService.UnitStockList(0), "Id", "Name"),
                Positions = new SelectList(this._systemService.PositionStockList(), "Id", "Name"),
                Labels = new SelectList(this._systemService.LabelStockList(0), "Id", "Name"),
            };
            return PartialView("Partials/_FindStockPartial", model);
        }

        public ActionResult SearchStockRequisitionFilter(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable)
        {
            var model = _stockService.StockViewModelFilter(page, size, stockCode, stockName, store, type, category, enable);
            var totalTemp = Convert.ToDecimal(model.TotalRecords) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            model.TotalPages = totalPages;
            model.CurrentPage = page;
            model.PageSize = size;
            model.StoreVs = _systemService.StoreList();
            model.UserLogin = _systemService.GetUserAndRole(0, System.Web.HttpContext.Current.User.Identity.Name);

            return PartialView("Partials/_SearchStockRequisitionPartial", model);
        }

        public ActionResult SearchStockPeFilter(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable,int supplier)
        {
            //var totalRecord = _stockService.PeListConditionCount(page, size, stockCode, stockName, store, type, category, enable, supplier);
            //var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            //var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            //var model = new StockViewModel
            //{
            //    StockVs = _stockService.PeListCondition(page, size, stockCode, stockName, store, type, category, enable, supplier),
            //    StoreVs = _systemService.StoreList(),
            //    TotalRecords = Convert.ToInt32(totalRecord),
            //    TotalPages = totalPages,
            //    CurrentPage = page,
            //    PageSize = size,
            //};
            var model = _stockService.ProductPeViewModelFilter(page, size, stockCode, stockName, store, type, category, enable, supplier);
            var totalTemp = Convert.ToDecimal(model.TotalRecords) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            model.TotalPages = totalPages;
            model.CurrentPage = page;
            model.PageSize = size;
            model.StoreVs = _systemService.StoreList();
            model.UserLogin = _systemService.GetUserAndRole(0, System.Web.HttpContext.Current.User.Identity.Name);


            return PartialView("Partials/_SearchStockPEPartial", model);
        }

        public ActionResult SearchStockStockInFilter(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable, int pe)
        {
            var totalRecord = _stockService.StockInListConditionCount(page, size, stockCode, stockName, store, type, category, enable, pe);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new StockViewModel
            {
                StockVs = _stockService.StockInListCondition(page, size, stockCode, stockName, store, type, category, enable, pe),
                StoreVs = _systemService.StoreList(),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return PartialView("Partials/_SearchStockStockInPartial", model);
        }

        public ActionResult SearchStockStockOutFilter(int page, int size, string stockCode, string stockName, int store, int type, int category)
        {
            var totalRecord = _stockService.StockOutListConditionCount(page, size, stockCode, stockName, store, type, category);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new StockViewModel
            {
                StockVs = _stockService.StockOutListCondition(page, size, stockCode, stockName, store, type, category),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return PartialView("Partials/_SearchStockStockOutPartial", model);
        }

        public ActionResult SearchStockStockReturnFilter(int page, int size, string stockCode, string stockName, int project, int type, int category)
        {
            var totalRecord = _stockService.StockReturnListConditionCount(page, size, stockCode, stockName, project, type, category);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));
            var model = new StockViewModel
            {
                StockVs = _stockService.StockReturnListCondition(page, size, stockCode, stockName, project, type, category),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return PartialView("Partials/_SearchStockStockReturnPartial", model);
        }

        [HttpPost]
        public ActionResult GetStockCodeName(string code, string name)
        {
            var stock = _systemService.GetStockCodeName(code, name);
            return Json(stock);
        }

        [HttpPost]
        public ActionResult GetStockInformation(int id, int store)
        {
            var stock = _systemService.GetStockInformation(id, store);
            return Json(stock);
        }

        [HttpPost]
        public ActionResult GetStockInformationByCode(string code, int store)
        {
            var stock = _systemService.GetStockInformationByCode(code, store);
            return Json(stock);
        }

        [HttpPost]
        public ActionResult GetStockInformationByProjectAssigned(string code, int project)
        {
            var stock = _systemService.GetStockInformationByProjectAssigned(code, project);
            return Json(stock);
        }

        [HttpPost]
        public ActionResult PeGetStockInformation(string code, int store, int supplier)
        {
            var stock = _systemService.PeGetStockInformation(code, store, supplier);
            return Json(stock);
        }

        [HttpPost]
        public ActionResult StockInGetStockInformation(string code, int store, int pe)
        {
            var stock = _systemService.StockInGetStockInformation(code, store, pe);
            return Json(stock);
        }

        [HttpPost]
        public ActionResult StockInGetQuantity(int code, int pe)
        {
            var data = _systemService.GetStockInQuantity(code, pe);
            return Json(data);
        }
        #endregion

        #region Update current password

        #endregion
    }
}