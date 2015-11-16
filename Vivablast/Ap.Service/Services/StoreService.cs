using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class StoreService : IStoreService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<Store> _repository;
        private readonly IStoreRepository _customRepository;

        public StoreService(
            IUnitOfWork unitOfWork,
            IRepository<Store> userRepository,
            IStoreRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = userRepository;
            _customRepository = customRepository;
        }

        public Store GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public IList<V3_List_Store> ListCondition(int page, int size, string storeCode, string storeName, int country, string enable)
        {
            return _customRepository.ListCondition(page, size, storeCode, storeName, country, enable);
        }

        public int ListConditionCount(int page, int size, string storeCode, string storeName, int country, string enable)
        {
            return _customRepository.ListConditionCount(page, size, storeCode, storeName, country, enable);
        }

        public IList<string> ListCode(string condition)
        {
            return _customRepository.ListCode(condition);
        }

        public IList<string> ListName(string condition)
        {
            return _customRepository.ListName(condition);
        }

        public bool ExistedCode(string condition)
        {
            return _repository.Count(m => m.Code == condition) > 0;
        }

        public bool ExistedName(string condition)
        {
            return _repository.Count(m => m.Name == condition) > 0;
        }

        public bool Insert(Store store)
        {
            _repository.Add(store);
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool Update(Store store)
        {
            _repository.Update(store);
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
