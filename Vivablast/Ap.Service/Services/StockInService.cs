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

    public class StockInService : IStockInService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<WAMS_FULFILLMENT_DETAIL> _repository;
        private readonly IStockInRepository _customRepository;

        public StockInService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_FULFILLMENT_DETAIL> repository,
            IStockInRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = repository;
            _customRepository = customRepository;
        }

        public WAMS_FULFILLMENT_DETAIL GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public IList<V3_List_StockIn> ListStockInByPo(int id)
        {
            return new List<V3_List_StockIn>();
        }

        public IList<V3_List_StockIn> ListCondition(int page, int size, int store, int poType, string status, int po, int supplier,
            string srv, string stockCode, string stockName, string fd, string td, string enable)
        {
            return _customRepository.ListCondition(page, size, store, poType, status, po, supplier, srv, stockCode, stockName, fd, td, enable);
        }

        public int ListConditionCount(int page, int size, int store, int poType, string status, int po, int supplier, string srv,
            string stockCode, string stockName, string fd, string td, string enable)
        {
            return _customRepository.ListConditionCount(page, size, store, poType, status, po, supplier, srv, stockCode, stockName, fd, td, enable);
        }

        public List<V3_List_StockIn_Detail> ListConditionDetail(int id, string enable)
        {
            return _customRepository.ListConditionDetail(id, enable);
        }

        public IList<V3_List_StockIn_Detail> ListConditionDetailExcel(int page, int size, int store, int poType, string status, int po, int supplier, string srv,
            string stockCode, string stockName, string fd, string td, string enable)
        {
            return _customRepository.ListConditionDetailExcel(page, size, store, poType, status, po, supplier, srv, stockCode, stockName, fd, td, enable);
        }

        public int Insert(List<WAMS_FULFILLMENT_DETAIL> entityDetails, int login)
        {
            var srvNew = SRVLastest("F");

            foreach (var detail in entityDetails)
            {
                if (detail.ID != 0 && detail.iModified == 1)
                {
                    // Update quantity
                    var detailEntity = new WAMS_FULFILLMENT_DETAIL
                    {
                        ID = detail.ID,
                        vPOID = detail.vPOID,
                        vStockID = detail.vStockID,
                        dQuantity = detail.dQuantity,
                        dReceivedQuantity = detail.dReceivedQuantity,
                        dPendingQuantity = detail.dPendingQuantity,
                        dDateDelivery = detail.dDateDelivery,
                        //iShipID = detail.iShipID,
                        tDescription = detail.tDescription,
                        vMRF = detail.vMRF,
                        // dCurrenQuantity = detail.dCurrenQuantity,
                        dInvoiceDate = detail.dInvoiceDate,
                        vInvoiceNo = detail.vInvoiceNo,
                        dImportTax = detail.dImportTax,
                        SRV = srvNew,
                        iStore = detail.iStore,
                        dCreated = DateTime.Now,
                        iCreated = login,
                        FlagFile = false
                    };
                    _customRepository.Update(detailEntity);
                }
                else if (detail.ID != 0)
                {
                    var detailEntity = GetByKey(detail.ID);
                    detailEntity.tDescription = detail.tDescription;
                    detailEntity.dInvoiceDate = detail.dInvoiceDate;
                    detailEntity.vInvoiceNo = detail.vInvoiceNo;
                    detailEntity.dImportTax = detail.dImportTax;
                    detailEntity.dModified = DateTime.Now;
                    detailEntity.iModified = login;
                    _repository.Update(detailEntity);
                }
                else
                {
                    var detailEntity = new WAMS_FULFILLMENT_DETAIL
                    {
                        vPOID = detail.vPOID,
                        vStockID = detail.vStockID,
                        dQuantity = detail.dQuantity,
                        dReceivedQuantity = detail.dReceivedQuantity,
                        dPendingQuantity = detail.dPendingQuantity,
                        dDateDelivery = detail.dDateDelivery,
                        //iShipID = detail.iShipID,
                        tDescription = detail.tDescription,
                        vMRF = detail.vMRF,
                        // dCurrenQuantity = detail.dCurrenQuantity,
                        dInvoiceDate = detail.dInvoiceDate,
                        vInvoiceNo = detail.vInvoiceNo,
                        dImportTax = detail.dImportTax,
                        SRV = srvNew,
                        iStore = detail.iStore,
                        dCreated = DateTime.Now,
                        iCreated = login,
                        FlagFile = false
                    };
                    _customRepository.Add(detailEntity);
                }
            }
            //_unitOfWork.CommitChanges();
            return 1;
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

        public string SRVLastest(string type)
        {
            var code = _customRepository.SRVLastest(type);
            var yearTemp = DateTime.Today.Year.ToString(CultureInfo.InvariantCulture);
            var codeTemp = type + yearTemp;
            if (code == null)
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

        public XStockInParent XStockInParent(string siv)
        {
            return _customRepository.XStockInParent(siv);
        }

        public IList<XStockIn> XStockIns(string siv)
        {
            return _customRepository.XStockIns(siv);
        }

        #endregion
    }
}
