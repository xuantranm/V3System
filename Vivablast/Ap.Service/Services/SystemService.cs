using System;
using System.Globalization;
using System.IO;
using System.Linq;
using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Business.ViewModels;
using Ap.Common.Constants;
using Ap.Common.Security;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class SystemService : ISystemService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<Document> _documentRepository;
        private readonly IRepository<LookUp> _lookUpRepository;
        private readonly IRepository<XUser> _userepository;
        private readonly ISystemRepository _customSystemRepository;
        private readonly IUserRepository _customUserRepository;

        public SystemService(
            IUnitOfWork unitOfWork,
            IRepository<Document> documentRepository,
            IRepository<LookUp> lookUpRepository,
            IRepository<XUser> userepository,
            ISystemRepository customSystemRepository,
            IUserRepository customUserRepository,
            IStoreRepository customStorerRepository)
        {
            _unitOfWork = unitOfWork;
            _customSystemRepository = customSystemRepository;
            _customUserRepository = customUserRepository;
            _documentRepository = documentRepository;
            _lookUpRepository = lookUpRepository;
            _userepository = userepository;
        }

        public bool CheckUser(string user, string password)
        {
            var userS = _customUserRepository.CheckUser(user.ToLower());
            if (userS == null)
            {
                return false;
            }

            var hashedPassword = UserCommon.CreateHash(password);
            return hashedPassword.Equals(userS.Password);
        }

        public XUser GetUserAndRole(int id, string user)
        {
            return id!=0 ? _userepository.First(x => x.Id.Equals(id)) : _userepository.First(x => x.UserName.Equals(user) || x.Email.Equals(user));
        }

        public V3_StockCodeName GetStockCodeName(string code, string name)
        {
            var stock = _customSystemRepository.GetStockCodeName(code, name);
            return stock;
        }

        public V3_Information_Stock GetStockInformation(int id, int store)
        {
            var stock = _customSystemRepository.GetStockInformation(id, store);
            if (stock == null)
            {
                return new V3_Information_Stock();
            }

            if (!string.IsNullOrEmpty(stock.Quantity))
            {
                var arrStores = stock.Stores.Trim().Split(';');
                var arrQuantities = stock.Quantity.Trim().Split(';');
                var results = Array.FindAll(arrStores, s => s.Equals(store.ToString(CultureInfo.InvariantCulture)));
                if (!results.Any())
                {
                    stock.Quantity = "0";
                }
                else
                {
                    var i = 0;
                    foreach (var st in arrStores)
                    {
                        if (store == Convert.ToInt32(st))
                        {
                            stock.Quantity = arrQuantities[i];
                        }

                        i++;
                    }
                }
            }

            return stock;
        }

        public V3_Information_Stock GetStockInformationByCode(string code, int store)
        {
            return _customSystemRepository.GetStockInformationByCode(code, store);
        }

        public V3_Information_Stock GetStockInformationByProjectAssigned(string code, int project)
        {
            return _customSystemRepository.GetStockInformationByCode(code, project);
        }

        public V3_Information_Stock PeGetStockInformation(string code, int store, int supplier)
        {
            return _customSystemRepository.PeGetStockInformation(code, store, supplier);
        }

        public V3_Information_Stock StockInGetStockInformation(string code, int store,int pe)
        {
            return _customSystemRepository.StockInGetStockInformation(code, store, pe);
        }

        public StockInQuantity GetStockInQuantity(int code, int pe)
        {
            return _customSystemRepository.GetStockInQuantity(code, pe);
        }

        public IList<LookUp> GetLookUp(string type)
        {
            return _customSystemRepository.GetLookUpByType(type);
        }

        public IList<V3_GetStoreDDL_Result> StoreList()
        {
            return _customSystemRepository.StoreList();
        }

        public IList<V3_GetCountryDDL_Result> CountryList()
        {
            return _customSystemRepository.CountryList();
        }

        public IList<V3_GetProjectDDL_Result> ProjectList()
        {
            return _customSystemRepository.ProjectList();
        }

        public IList<V3_GetProjectClientDDL_Result> ClientProjectList()
        {
            return _customSystemRepository.ClientProjectList();
        }

        public IList<V3_GetWorkerDDL_Result> SuppervisorList()
        {
            return _customSystemRepository.SuppervisorList();
        }

        public IList<V3_GetStockTypeDDL_Result> TypeStockList()
        {
            return _customSystemRepository.TypeStockList();
        }

        public IList<V3_GetStockCategoryDDL_Result> CategoryStockList(int type)
        {
            return _customSystemRepository.CategoryStockList(type);
        }

        public IList<V3_GetStockUnitDDL_Result> UnitStockList(int type)
        {
            return _customSystemRepository.UnitStockList(type);
        }

        public IList<V3_GetStockPositionDDL_Result> PositionStockList()
        {
            return _customSystemRepository.PositionStockList();
        }

        public IList<V3_GetStockLabelDDL_Result> LabelStockList(int type)
        {
            return _customSystemRepository.LabelStockList(type);
        }

        public IList<V3_List_PoType_Ddl> PoTypeList()
        {
            return _customSystemRepository.PoTypeList();
        }

        public IList<V3_GetSupplierDDL_Result> SupplierList()
        {
            return _customSystemRepository.SupplierList();
        }

        public IList<V3_GetSupplierTypeDDL_Result> SupplierTypeList()
        {
            return _customSystemRepository.SupplierTypeList();
        }

        public IList<V3_GetCurrencyDDL> CurrencyList()
        {
            return _customSystemRepository.CurrencyList();
        }

        public IList<V3_GetPaymentDDL> PaymentList()
        {
            return _customSystemRepository.PaymentList();
        }

        public IList<V3_GetPriceDDL> PriceList(int stock, int store, int currency)
        {
            return _customSystemRepository.PriceList(stock, store, currency);
        }

        public IList<V3_GetRequisitionDDL> RequisitionByStockList(int stock, int store)
        {
            return _customSystemRepository.RequisitionByStockList(stock, store);
        }

        public string PaymentTypeBySupplier(int supplier)
        {
            return _customSystemRepository.PaymentTypeBySupplier(supplier);
        }
        public IList<V3_DDL_PE> Ddlpe(int supplier, int store, string status)
        {
            return _customSystemRepository.Ddlpe(supplier, store, status);
        }

        public V3_Ddl SuppliersFromPe(int pe)
        {
            return _customSystemRepository.SuppliersFromPe(pe);
        }

        #region DOCUMENT
        public List<Document> GetDocumentList(int key, int type)
        {
            return _customSystemRepository.GetDocumentList(key, type);
        }

        public Document AddDocument(string documentUrl, string documentDescription, int keyId, int documentTypeId, string documentName, string documentTitle, string folderLocation, byte documentFile, int loginId)
        {
            var document = new Document
            {
                DocumentURL = documentUrl,
                DocumentDescription = documentDescription,
                KeyId = keyId,
                DocumentTypeId = documentTypeId,
                DocumentName = documentName,
                DocumentTitle = documentTitle,
                FolderLocation = folderLocation,
                ById = loginId,
                ActionDate = DateTime.Now
            };
            _documentRepository.Add(document);
            _unitOfWork.CommitChanges();
            return document;
        }

        public int InsertDocument(string documentUrl, string documentDescription, int keyId, int documentTypeId, string documentName, string documentTitle, string folderLocation, byte documentFile, int loginId)
        {
            return _customSystemRepository.InsertDocument(documentUrl, documentDescription, keyId, documentTypeId, documentName, documentTitle, folderLocation, documentFile, loginId);
        }

        public int DeleteDocument(int id)
        {
            return _customSystemRepository.DeleteDocument(id);
        }

        public bool CheckValidExtension(string fileName)
        {
            var fileExtension = fileName.Substring(fileName.LastIndexOf('.'));
            fileExtension = fileExtension.ToLower();
            switch (fileExtension)
            {
                case ".txt":
                case ".doc":
                case ".xls":
                case ".csv":
                case ".gif":
                case ".jpg":
                case ".jpeg":
                case ".png":
                case ".pdf":
                case ".docx":
                case ".xlsx":
                    return true;
                default:
                    return false;
            }
        }

        public bool CheckValidPictureExtension(string fileName)
        {
            var fileExtension = fileName.Substring(fileName.LastIndexOf('.'));
            fileExtension = fileExtension.ToLower();
            switch (fileExtension)
            {
                case ".gif":
                case ".jpg":
                case ".jpeg":
                case ".png":
                    return true;
                default:
                    return false;
            }
        }

        public string GetDocumentUrl(string documentLocation, string fileName, string fileExtend)
        {
            return documentLocation + "\\" + fileName + fileExtend;
        }

        public Document GetDocumentById(int id)
        {
            return _customSystemRepository.GetDocumentById(id);
        }

        public string GetContentType(string fileExtension)
        {
            switch (fileExtension)
            {
                case ".txt":
                    return "text/plain";
                case ".doc":
                case ".docx":
                    return "application/ms-word";
                case ".tiff":
                case ".tif":
                    return "image/tiff";
                case ".xls":
                case ".xlsx":
                case ".csv":
                    return "application/vnd.ms-excel";
                case ".gif":
                    return "image/gif";
                case ".jpg":
                case ".jpeg":
                    return "image/jpeg";
                case ".rtf":
                    return "application/rtf";
                case ".pdf":
                    return "application/pdf";
                case ".png":
                    return "image/png";
                default:
                    return "application/octet-stream";
            }
        }

        public string GetDocumentSize(string folderLocation, string documentName)
        {
            // Setting Path of the File with FileName
            string filepath = Path.Combine(folderLocation, documentName);
            string fileSize = string.Empty;

            FileInfo file = new FileInfo(filepath);

            // Checking existence of the file
            if (file.Exists == true)
            {
                long sizeInBytes = file.Length;

                // Converting Bytes into MegaBytes
                float sizeInMegaBytes = ((sizeInBytes / 1024f) / 1024f);

                if (Math.Round(sizeInMegaBytes, 2) < 0.50)
                {
                    fileSize = Constants.ErrorFileSize_Less;
                }
                else
                {
                    fileSize = Convert.ToString(Math.Round(sizeInMegaBytes, 2)) + "mb";
                }
            }

            return fileSize;
        }
        #endregion

        #region Picture
        #endregion

        #region STOCK MANAGEMENT

        public IList<V3_Stock_Quantity_Management_Result> ListTransactionStockByProject(int page, int size, int project, string type, string fd, string td)
        {
            return _customSystemRepository.ListTransactionStockByProject(page, size, project,type, fd, td);
        }

        public int CountListTransactionStockByProject(int page, int size, int project, string type, string fd, string td)
        {
            return _customSystemRepository.CountListTransactionStockByProject(page, size, project,type, fd, td);
        }
        #endregion

        #region INSERT COMMON

        public bool InsertLookUp(LookUp entity)
        {
            if (_lookUpRepository.Count(
                m => m.LookUpType.Equals(entity.LookUpType) && m.LookUpValue.Equals(entity.LookUpValue)) != 0)
                return false;
            _lookUpRepository.Add(entity);
            _unitOfWork.CommitChanges();

            return true;
        }
        #endregion

        #region X-media

        public DynamicPeReportViewModel GetDynamicPeReport(int page, int size, int poType, string po, int stockType,
            int category, string stockCode, string stockName, string fd, string td)
        {
            return _customSystemRepository.GetDynamicPeReport(page, size, poType, po, stockType, category, stockCode, stockName, fd, td);
        }

        public DynamicProjectReportViewModel GetDynamicProjectReport(int page, int size, int projectId, int stockTypeId,
            int categoryId, string stockCode, string stockName, int action, int supplierId, string fd, string td)
        {
            return _customSystemRepository.GetDynamicProjectReport(page, size, projectId, stockTypeId, categoryId,
                stockCode, stockName, action, supplierId, fd, td);
        }
        #endregion
    }
}
