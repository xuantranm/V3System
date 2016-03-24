using System.Globalization;
using Ap.Business.Models;
using Ap.Business.Seedworks;
using Vivablast.Models;

namespace Ap.Service.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Business.Domains;
    using Data.Seedworks;
    using Seedworks;

    public class StockReturnService : IStockReturnService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<WAMS_RETURN_LIST> _repository;
        private readonly IStockReturnRepository _customRepository;

        public StockReturnService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_RETURN_LIST> repository,
            IStockReturnRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = repository;
            _customRepository = customRepository;
        }

        public WAMS_RETURN_LIST GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public IList<V3_List_StockReturn> ListCondition(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable)
        {
            return _customRepository.ListCondition(page, size, store, project, stockType, stockCode, stockName, srv, fd, td, enable);
        }

        public IList<V3_List_StockReturn_Detail> ListConditionDetail(string id, string enable)
        {
            return _customRepository.ListConditionDetail(id, enable);
        }

        public IList<V3_List_StockReturn_Detail> ListConditionDetailExcel(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable)
        {
            return _customRepository.ListConditionDetailExcel(page, size, store, project, stockType, stockCode, stockName, srv, fd, td, enable);
        }

        public int ListConditionCount(int page, int size, int store, int project, int stockType, string stockCode, string stockName, string srv, string fd, string td, string enable)
        {
            return _customRepository.ListConditionCount(page, size, store, project, stockType, stockCode, stockName, srv, fd, td, enable);
        }

        public bool Insert(List<WAMS_RETURN_LIST> entityDetails, int login)
        {
            var srvNew = SRVLastest("R");

            foreach (var detail in entityDetails)
            {
                if (detail.bReturnListID != 0 && detail.iModified == 1)
                {
                    var detailEntity = GetByKey(detail.bReturnListID);
                    //detailEntity.vPOID = detail.vPOID;
                    //detailEntity.vStockID = detail.vStockID;
                    //detailEntity.dQuantity = detail.dQuantity;
                    //detailEntity.dReceivedQuantity = detail.dReceivedQuantity;
                    //detailEntity.dPendingQuantity = detail.dPendingQuantity;
                    //detailEntity.dDateDelivery = detail.dDateDelivery;
                    //detailEntity.iShipID = detail.iShipID;
                    //detailEntity.tDescription = detail.tDescription;
                    //detailEntity.vMRF = detail.vMRF;
                    // detailEntity.dCurrenQuantity = detail.dCurrenQuantity;
                    //detailEntity.dInvoiceDate = detail.dInvoiceDate;
                    //detailEntity.vInvoiceNo = detail.vInvoiceNo;
                    //detailEntity.dImportTax = detail.dImportTax;
                    //detailEntity.iEnable = true;
                    //detailEntity.dDateAssign = detail.dDateAssign;
                    //detailEntity.SRV = detail.SRV;
                    //detailEntity.iStore = detail.iStore;
                    //detailEntity.dCreated = createdDate;
                    //detailEntity.iCreated = login;
                    detailEntity.dModified = DateTime.Now;
                    detailEntity.iModified = login;
                    _repository.Update(detailEntity);
                }
                else if (detail.bReturnListID != 0)
                {
                    var detailEntity = new WAMS_RETURN_LIST
                    {
                        //vPOID = detail.vPOID,
                        vStockID = detail.vStockID,
                        //dQuantity = detail.dQuantity,
                        //dReceivedQuantity = detail.dReceivedQuantity,
                        //dPendingQuantity = detail.dPendingQuantity,
                        //dDateDelivery = detail.dDateDelivery,
                        //iShipID = detail.iShipID,
                        //tDescription = detail.tDescription,
                        //vMRF = detail.vMRF,
                        // dCurrenQuantity = detail.dCurrenQuantity,
                        //dInvoiceDate = detail.dInvoiceDate,
                        //vInvoiceNo = detail.vInvoiceNo,
                        //dImportTax = detail.dImportTax,
                        //iEnable = true,
                        //dDateAssign = DateTime.Now,
                        SRV = srvNew,
                        //iStore = detail.iStore,
                        dCreated = DateTime.Now,
                        iCreated = login
                    };
                    _repository.Add(detailEntity);
                }
                else
                {
                    var detailEntity = new WAMS_RETURN_LIST
                    {
                        vStockID = detail.vStockID,
                        vProjectID = detail.vProjectID,
                        bQuantity = detail.bQuantity,
                        ToStore = detail.ToStore,
                        SRV = srvNew,
                        vCondition = detail.vCondition,
                        iCreated = login,
                        FlagFile = false
                    };
                    _customRepository.Add(detailEntity);
                }
            }
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool ExistedCode(string condition)
        {
            return true;
        }

        public int CheckDelete(int id)
        {
            return _customRepository.CheckDelete(id);
        }

        public int DeleteDetail(int id)
        {
            return _customRepository.DeleteDetail(id);
        }

        public int Delete(int id)
        {
            return _customRepository.Delete(id);
        }

        public string SRVLastest(string type)
        {
            var code = _customRepository.SRVLastest(type);
            var yearTemp = DateTime.Today.Year.ToString(CultureInfo.InvariantCulture);
            var codeTemp = type + yearTemp;
            if (string.IsNullOrEmpty(code.NumSRV))
            {
                codeTemp += "000001";
            }
            else
            {
                var intMaxOrderNo = Convert.ToInt32(code.NumSRV);
                intMaxOrderNo++;
                var intOrderNoLength = intMaxOrderNo.ToString(CultureInfo.InvariantCulture).Length;
                var orderNo = string.Empty;
                for (var i = intOrderNoLength; i < 6; i++)
                {
                    orderNo += "0";
                }

                orderNo += intMaxOrderNo.ToString(CultureInfo.InvariantCulture);

                codeTemp += orderNo;
            }

            return codeTemp;
        }

        #region X-Media

        public XStockReturnParent XStockReturnParent(string siv)
        {
            return _customRepository.XStockReturnParent(siv);
        }

        public IList<XStockReturn> XStockReturns(string siv)
        {
            return _customRepository.XStockReturns(siv);
        }

        #endregion
    }
}
