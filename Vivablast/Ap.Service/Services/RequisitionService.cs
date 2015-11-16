using System;
using System.Linq;
using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class RequisitionService : IRequisitionService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<WAMS_REQUISITION_MASTER> _repository;
        private readonly IRepository<WAMS_REQUISITION_DETAILS> _repositoryDetail;
        private readonly IRequisitionRepository _customRepository;

        public RequisitionService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_REQUISITION_MASTER> repository,
            IRepository<WAMS_REQUISITION_DETAILS> repositoryDetail,
            IRequisitionRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = repository;
            _repositoryDetail = repositoryDetail;
            _customRepository = customRepository;
        }

        public WAMS_REQUISITION_MASTER GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public V3_Requisition_Master GetRequisitionMasterByKey(int id)
        {
            return _customRepository.GetRequisitionMasterByKey(id);
        }
        public WAMS_REQUISITION_DETAILS GetByKeyDetail(int id)
        {
            return _repositoryDetail.GetByKey(id);
        }

        public IList<V3_List_Requisition> ListCondition(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable)
        {
            return _customRepository.ListCondition(page, size, store, mrf, stockCode, stockName, status, fd, td, enable);
        }

        public int ListConditionCount(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable)
        {
            return _customRepository.ListConditionCount(page, size, store, mrf, stockCode, stockName, status, fd, td, enable);
        }

        public IList<V3_RequisitionDetail_Result> ListConditionDetail(int id, string enable)
        {
            return _customRepository.ListConditionDetail(id, enable);
        }

        public IList<V3_RequisitionDetail_Result> ListConditionDetailExcel(int page, int size, int store, string mrf, string stockCode, string stockName, string status, string fd, string td, string enable)
        {
            return _customRepository.ListConditionDetailExcel(page, size, store, mrf, stockCode, stockName, status, fd, td, enable);
        }

        public IList<string> ListCode(string condition)
        {
            return _customRepository.ListCode(condition);
        }

        public bool ExistedCode(string condition)
        {
            return _repository.Count(m => m.vMRF == condition) > 0;
        }

        public bool Insert(WAMS_REQUISITION_MASTER entity, List<WAMS_REQUISITION_DETAILS> entityDetails)
        {
            _repository.Add(entity);
            _unitOfWork.CommitChanges();

            foreach (var detail in entityDetails)
            {
                var detailEntity = new WAMS_REQUISITION_DETAILS
                {
                    vMRF = entity.Id,
                    vStockID = detail.vStockID,
                    fQuantity = detail.fQuantity,
                    fTobePurchased = detail.fTobePurchased,
                    Remark = detail.Remark,
                    iFollowUpRequired = 1,
                    iPurchased = 0,
                    iSent = 0,
                    vStatus = "Open",
                    iEnable = true,
                    dDateAssign = entity.dCreated,
                    dCreated = entity.dCreated,
                    iCreated = entity.iCreated
                };
                _repositoryDetail.Add(detailEntity);
            }

            _unitOfWork.CommitChanges();
            return true;
        }

        public bool Update(WAMS_REQUISITION_MASTER entity, List<WAMS_REQUISITION_DETAILS> entityDetails, string LstDeleteDetailItem)
        {
            _repository.Update(entity);
            foreach (var detail in entityDetails)
            {
                if (detail.ID != 0)
                {
                    var detailEntity = _repositoryDetail.GetByKey(detail.ID);
                    detailEntity.vStockID = detail.vStockID;
                    detailEntity.fQuantity = detail.fQuantity;
                    detailEntity.fTobePurchased = detail.fTobePurchased;
                    detailEntity.Remark = detail.Remark;
                    detailEntity.dModified = DateTime.Now;
                    detailEntity.iModified = entity.iModified;
                    _repositoryDetail.Update(detailEntity);
                }
                else
                {
                    var detailEntity = new WAMS_REQUISITION_DETAILS
                    {
                        vMRF = entity.Id,
                        vStockID = detail.vStockID,
                        fQuantity = detail.fQuantity,
                        fTobePurchased = detail.fTobePurchased,
                        Remark = detail.Remark,
                        iFollowUpRequired = 1,
                        iPurchased = 0,
                        iSent = 0,
                        vStatus = "Open",
                        iEnable = true,
                        dDateAssign = entity.dCreated,
                        dCreated = entity.dCreated,
                        iCreated = entity.iCreated
                    };
                    _repositoryDetail.Add(detailEntity);
                }
            }

            if (!string.IsNullOrEmpty(LstDeleteDetailItem))
            {
                var listStrLineElements = LstDeleteDetailItem.Split(';').ToList();
                foreach (var itemDetail in listStrLineElements)
                {
                    _customRepository.DeleteDetail(Convert.ToInt32(itemDetail));
                }
            }

            _unitOfWork.CommitChanges();
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
        
        public string GetCodeLastest()
        {
            return _customRepository.GetCodeLastest();
        }
    }
}
