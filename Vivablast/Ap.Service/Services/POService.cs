using System;
using System.Globalization;
using System.Linq;
using Ap.Business.Domains;
using Ap.Business.Dto;
using Ap.Business.Seedworks;
using Ap.Common.Constants;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class POService : IPOService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<WAMS_PURCHASE_ORDER> _repository;
        private readonly IRepository<WAMS_PO_DETAILS> _repositoryDetail;
        private readonly IPeRepository _customRepository;

        public POService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_PURCHASE_ORDER> repository,
            IRepository<WAMS_PO_DETAILS> repositoryDetail,
            IPeRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = repository;
            _repositoryDetail = repositoryDetail;
            _customRepository = customRepository;
        }

        public WAMS_PURCHASE_ORDER GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public V3_PE_PDF GetByPEPDF(int id)
        {
            return _customRepository.GetByPEPDF(id);
        }

        public WAMS_PO_DETAILS GetByKeyDetail(int id)
        {
            return _repositoryDetail.GetByKey(id);
        }

        public IList<V3_List_PO> ListCondition(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable)
        {
            return _customRepository.ListCondition(page, size, store, potype, po, status, mrf, supplier, project, stockCode, stockName, fd, td, enable);
        }

        public int ListConditionCount(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable)
        {
            return _customRepository.ListConditionCount(page, size, store, potype, po, status, mrf, supplier, project, stockCode, stockName, fd, td, enable);
        }

        public List<V3_Pe_Detail> ListConditionDetail(int id, string enable)
        {
            return _customRepository.ListConditionDetail(id, enable);
        }

        public IList<V3_Pe_Detail> ListConditionDetailExcel(int page, int size, int store, int potype, string po, string status, string mrf, int supplier, int project, string stockCode, string stockName, string fd, string td, string enable)
        {
            return _customRepository.ListConditionDetailExcel(page, size, store, potype, po, status, mrf, supplier,
                                                              project, stockCode, stockName, fd, td, enable);
        }

        public V3_PE_Information GetPeInformation(int id)
        {
            return _customRepository.GetPeInformation(id);
        }

        public IList<string> ListCode(string condition)
        {
            return _customRepository.ListCode(condition);
        }

        public IList<string> ListPayment(string condition)
        {
            return _customRepository.ListPayment(condition);
        }

        public bool ExistedCode(string condition)
        {
            return _repository.Count(m => m.vPOID == condition) > 0;
        }

        public string GetAutoPoCode()
        {
            var monthTemp = string.Empty;
            var yearTemp = DateTime.Today.Year.ToString(CultureInfo.InvariantCulture);
            switch (DateTime.Today.Month)
            {
                case 1:
                    monthTemp = "JAN";
                    break;
                case 2:
                    monthTemp = "FEB";
                    break;
                case 3:
                    monthTemp = "MAR";
                    break;
                case 4:
                    monthTemp = "APR";
                    break;
                case 5:
                    monthTemp = "MAY";
                    break;
                case 6:
                    monthTemp = "JUN";
                    break;
                case 7:
                    monthTemp = "JUL";
                    break;
                case 8:
                    monthTemp = "AUG";
                    break;
                case 9:
                    monthTemp = "SEP";
                    break;
                case 10:
                    monthTemp = "OCT";
                    break;
                case 11:
                    monthTemp = "NOV";
                    break;
                case 12:
                    monthTemp = "DEC";
                    break;
            }

            yearTemp = yearTemp.Substring(2);
            var codeTemp = monthTemp + "/" + yearTemp + "/";

            var condition = monthTemp + "/" + yearTemp + "/";
            var po = _customRepository.PoLastest(condition);

            if (string.IsNullOrEmpty(po.vPOID))
            {
                codeTemp += "0001";
            }
            else
            {
                var intMaxOrderNo = Convert.ToInt32(po.Code);
                intMaxOrderNo++;
                var intOrderNoLength = intMaxOrderNo.ToString(CultureInfo.InvariantCulture).Length;
                var orderNo = string.Empty;
                for (var i = intOrderNoLength; i < 4; i++)
                {
                    orderNo += "0";
                }

                orderNo += intMaxOrderNo.ToString(CultureInfo.InvariantCulture);

                codeTemp += orderNo;
            }

            return codeTemp;
        }

        public bool Insert(WAMS_PURCHASE_ORDER entity, List<V3_Pe_Detail_Data> entityDetails)
        {
            _repository.Add(entity);
            _unitOfWork.CommitChanges();
            var listRequisitionUpdate = new List<PeRequisitionUpdate>();
            foreach (var detail in entityDetails)
            {
                var detailEntity = new WAMS_PO_DETAILS
                {
                    vPOID = entity.Id,
                    vMRF = detail.MRFId,
                    iDiscount = int.Parse(detail.Discount, new CultureInfo(Constants.MyCultureInfo)),
                    vProductID = detail.StockId,
                    fQuantity = decimal.Parse(detail.Quantity, new CultureInfo(Constants.MyCultureInfo)),
                    fVAT = int.Parse(detail.VAT, new CultureInfo(Constants.MyCultureInfo)),
                    fItemTotal = decimal.Parse(detail.ItemTotal, new CultureInfo(Constants.MyCultureInfo)),
                    vRemark = detail.Remark,
                    vPODetailStatus = "Open",
                    fUnitPrice = decimal.Parse(detail.UnitPrice, new CultureInfo(Constants.MyCultureInfo)),
                    PriceId = detail.Price_Id,
                    iEnable = true,
                    dDateAssign = entity.dCreated,
                    dCreated = entity.dCreated,
                    iCreated = entity.iCreated
                };
                _repositoryDetail.Add(detailEntity);
                var listMrf = detail.MRFId.Split(';').ToList();
                listRequisitionUpdate.AddRange(listMrf.Select(mrf => new PeRequisitionUpdate
                {
                    Mrf = Convert.ToInt32(mrf), Stock = detail.StockId, Quantity = decimal.Parse(detail.Quantity, new CultureInfo(Constants.MyCultureInfo))
                }));
            }
            _unitOfWork.CommitChanges();
            // Update Total PE
            _customRepository.UpdatePeTotal(entity.Id);
            // Update Requisition
            foreach (var requistionUpdate in listRequisitionUpdate)
            {
                _customRepository.UpdateRequisition(requistionUpdate.Mrf, requistionUpdate.Stock, requistionUpdate.Quantity);
            }
            // Insert New Payment Type
            _customRepository.UpdatePaymentType(entity.vTermOfPayment);
            return true;
        }

        public bool Update(WAMS_PURCHASE_ORDER entity, List<V3_Pe_Detail_Data> entityDetails, string lstDeleteDetailItem)
        {
            _repository.Update(entity);
            foreach (var detail in entityDetails)
            {
                if (detail.Id != 0)
                {
                    var detailEntity = _repositoryDetail.GetByKey(detail.Id);
                    detailEntity.vProductID = detail.StockId;
                    detailEntity.fQuantity = decimal.Parse(detail.Quantity, new CultureInfo(Constants.MyCultureInfo));
                    detailEntity.PriceId = detail.Price_Id;
                    detailEntity.fUnitPrice = decimal.Parse(detail.UnitPrice, new CultureInfo(Constants.MyCultureInfo));
                    detailEntity.iDiscount = int.Parse(detail.Discount, new CultureInfo(Constants.MyCultureInfo));
                    detailEntity.fVAT = int.Parse(detail.VAT, new CultureInfo(Constants.MyCultureInfo));
                    detailEntity.fItemTotal = decimal.Parse(detail.ItemTotal, new CultureInfo(Constants.MyCultureInfo));
                    detailEntity.vRemark = detail.Remark;
                    detailEntity.dModified = DateTime.Now;
                    detailEntity.iModified = entity.iModified;
                    _repositoryDetail.Update(detailEntity);
                }
                else
                {
                    var detailEntity = new WAMS_PO_DETAILS
                    {
                        vPOID = entity.Id,
                        vMRF = detail.MRFId,
                        iDiscount = int.Parse(detail.Discount, new CultureInfo(Constants.MyCultureInfo)),
                        vProductID = detail.StockId,
                        fQuantity = decimal.Parse(detail.Quantity, new CultureInfo(Constants.MyCultureInfo)),
                        fVAT = int.Parse(detail.VAT, new CultureInfo(Constants.MyCultureInfo)),
                        fItemTotal = decimal.Parse(detail.ItemTotal, new CultureInfo(Constants.MyCultureInfo)),
                        vRemark = detail.Remark,
                        vPODetailStatus = "Open",
                        fUnitPrice = decimal.Parse(detail.UnitPrice, new CultureInfo(Constants.MyCultureInfo)),
                        PriceId = detail.Price_Id,
                        iEnable = true,
                        dDateAssign = entity.dCreated,
                        dCreated = entity.dCreated,
                        iCreated = entity.iCreated
                    };
                    _repositoryDetail.Add(detailEntity);
                }
            }

            if (!string.IsNullOrEmpty(lstDeleteDetailItem))
            {
                var listStrLineElements = lstDeleteDetailItem.Split(';').ToList();
                foreach (var itemDetail in listStrLineElements)
                {
                    _customRepository.DeleteDetail(Convert.ToInt32(itemDetail));
                }
            }
            _unitOfWork.CommitChanges();
            // Update Total PE
            _customRepository.UpdatePeTotal(entity.Id);

            // Insert New Payment Type
            _customRepository.UpdatePaymentType(entity.vTermOfPayment);
            return true;
        }

        public int CheckDelete(int id)
        {
            return _customRepository.CheckDelete(id);
        }

        public int Delete(int id)
        {
            return _customRepository.Delete(id);
        }
    }
}
