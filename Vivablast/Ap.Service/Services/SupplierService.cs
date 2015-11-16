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
    public class SupplierService : ISupplierService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<WAMS_SUPPLIER> _repository;
        private readonly IRepository<WAMS_PRODUCT> _repositoryDetail;
        private readonly ISupplierRepository _customRepository;

        public SupplierService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_SUPPLIER> repository,
            IRepository<WAMS_PRODUCT> repositoryDetail,
            ISupplierRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = repository;
            _repositoryDetail = repositoryDetail;
            _customRepository = customRepository;
        }

        public WAMS_SUPPLIER GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public WAMS_PRODUCT GetByKeyDetail(int id)
        {
            return _repositoryDetail.GetByKey(id);
        }

        public IList<V3_List_Supplier> ListCondition(int page, int size, int supplierType, int supplierId, string stockCode, string stockName, int country, int market, string enable)
        {
            return _customRepository.ListCondition(page, size, supplierType, supplierId, stockCode, stockName, country, market, enable);
        }

        public int ListConditionCount(int page, int size, int supplierType, int supplierId, string stockCode, string stockName, int country, int market, string enable)
        {
            return _customRepository.ListConditionCount(page, size, supplierType, supplierId, stockCode, stockName, country, market, enable);
        }

        public IList<V3_List_Supplier_Product> ListConditionDetail(int id, string enable)
        {
            return _customRepository.ListConditionDetail(id, enable);
        }

        public IList<V3_List_Supplier_Product> ListConditionDetailExcel(int page, int size, int supplierType, int supplierId, string stockCode, string stockName, int country, int market, string enable)
        {
            return _customRepository.ListConditionDetailExcel(page, size, supplierType, supplierId, stockCode, stockName, country, market, enable);
        }

        public IList<string> ListName(string condition)
        {
            return _customRepository.ListName(condition);
        }

        public bool ExistedName(string condition)
        {
            return _repository.Count(m => m.vSupplierName == condition) > 0;
        }

        public bool Insert(WAMS_SUPPLIER entity, List<WAMS_PRODUCT> entityDetails)
        {
            _repository.Add(entity);
            _unitOfWork.CommitChanges();
            if (entityDetails != null)
            {
                foreach (var detail in entityDetails)
                {
                    var detailEntity = new WAMS_PRODUCT
                    {
                        vProductID = detail.vProductID,
                        bSupplierID = entity.bSupplierID,
                        vDescription = detail.vDescription,
                        iEnable = true,
                        dCreated = entity.dCreated,
                        iCreated = entity.iCreated
                    };
                    _repositoryDetail.Add(detailEntity);
                } 
            }
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool Update(WAMS_SUPPLIER entity, List<WAMS_PRODUCT> entityDetails, string LstDeleteDetailItem)
        {
            _repository.Update(entity);
            foreach (var detail in entityDetails)
            {
                if (detail.Id != 0)
                {
                    var detailEntity = _repositoryDetail.GetByKey(detail.Id);
                    detailEntity.bSupplierID = entity.bSupplierID;
                    detailEntity.vProductID = detail.vProductID;
                    detailEntity.vDescription = detail.vDescription;
                    detailEntity.dModified = DateTime.Now;
                    detailEntity.iModified = entity.iModified;
                    _repositoryDetail.Update(detailEntity);
                }
                else
                {
                    var detailEntity = new WAMS_PRODUCT
                    {
                        bSupplierID = entity.bSupplierID,
                        vProductID = detail.vProductID,
                        vDescription = detail.vDescription,
                        iEnable = true,
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
    }
}
