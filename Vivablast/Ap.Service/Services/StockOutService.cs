using System.Globalization;
using Ap.Business.Seedworks;
using Vivablast.Models;

namespace Ap.Service.Services
{
    using System;
    using System.Collections.Generic;
    using Business.Domains;
    using Data.Seedworks;
    using Seedworks;

    public class StockOutService : IStockOutService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<WAMS_ASSIGNNING_STOCKS> _repository;
        private readonly IStockOutRepository _customRepository;

        public StockOutService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_ASSIGNNING_STOCKS> repository,
            IStockOutRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = repository;
            _customRepository = customRepository;
        }

        public WAMS_ASSIGNNING_STOCKS GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public IList<V3_List_StockAssign> ListCondition(int page, int size, int store, int project, int stocktype,
            string stockCode, string stockName, string siv, string fd, string td, string enable)
        {
            return _customRepository.ListCondition(page, size, store, project, stocktype, stockCode, stockName, siv, fd,
                td, enable);
        }

        public List<V3_List_StockAssign_Detail> ListConditionDetail(int id, string enable)
        {
            return _customRepository.ListConditionDetail(id, enable);
        }

        public IList<V3_List_StockAssign_Detail> ListConditionDetailExcel(int page, int size, int store, int project,
            int stocktype, string stockCode, string stockName, string siv, string fd, string td, string enable)
        {
            return _customRepository.ListConditionDetailExcel(page, size, store, project, stocktype, stockCode, stockName, siv, fd,
                td, enable);
        }

        public int ListConditionCount(int page, int size, int store, int project, int stocktype, string stockCode,
            string stockName, string siv, string fd, string td, string enable)
        {
            return _customRepository.ListConditionCount(page, size, store, project, stocktype, stockCode, stockName, siv, fd,
                td, enable);
        }

        public bool Insert(List<WAMS_ASSIGNNING_STOCKS> entityDetails, int login)
        {
            var srvNew = SIVLastest("");

            foreach (var detail in entityDetails)
            {
                if (detail.bAssignningStockID != 0 && detail.iModified == 1)
                {
                    // Update quantity
                    var detailEntity = new WAMS_ASSIGNNING_STOCKS
                    {
                        bAssignningStockID = detail.bAssignningStockID,
                        //vPOID = detail.vPOID,
                        vStockID = detail.vStockID,
                        //dQuantity = detail.dQuantity,
                        //dReceivedQuantity = detail.dReceivedQuantity,
                        //dPendingQuantity = detail.dPendingQuantity,
                        //dDateDelivery = detail.dDateDelivery,
                        ////iShipID = detail.iShipID,
                        //tDescription = detail.tDescription,
                        vMRF = detail.vMRF,
                        // dCurrenQuantity = detail.dCurrenQuantity,
                        //dInvoiceDate = detail.dInvoiceDate,
                        //vInvoiceNo = detail.vInvoiceNo,
                        //dImportTax = detail.dImportTax,
                        //SRV = srvNew,
                        //iStore = detail.iStore,
                        dCreated = DateTime.Now,
                        iCreated = login,
                        FlagFile = false
                    };
                    _customRepository.Update(detailEntity);
                }
                else if (detail.bAssignningStockID != 0)
                {
                    var detailEntity = GetByKey(detail.bAssignningStockID);
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
                    detailEntity.SIV = srvNew;
                    //detailEntity.iStore = detail.iStore;
                    //detailEntity.dCreated = createdDate;
                    //detailEntity.iCreated = login;
                    detailEntity.dModified = DateTime.Now;
                    detailEntity.iModified = login;
                    _repository.Update(detailEntity);
                }
                else
                {
                    var detailEntity = new WAMS_ASSIGNNING_STOCKS
                    {
                        vStockID = detail.vStockID,
                        vProjectID = detail.vProjectID,
                        bQuantity = detail.bQuantity,
                        vWorkerID = detail.vWorkerID,
                        SIV = srvNew,
                        vMRF = detail.vMRF,
                        FromStore = detail.FromStore,
                        ToStore = detail.ToStore,
                        iCreated = login,
                        FlagFile = false,
                        Description = detail.Description
                    };
                    _customRepository.Add(detailEntity);
                }
            }
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool ExistedCode(string condition)
        {
            return _repository.Count(m => m.vMRF == condition) > 0;
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

        public string SIVLastest(string type)
        {
            var code = _customRepository.SIVLastest(type);
            var yearTemp = DateTime.Today.Year.ToString(CultureInfo.InvariantCulture);
            var codeTemp = type + yearTemp;
            if (string.IsNullOrEmpty(code.NumSIV))
            {
                codeTemp += "000001";
            }
            else
            {
                var intMaxOrderNo = Convert.ToInt32(code.NumSIV);
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
    }
}
