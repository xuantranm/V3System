using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class ServiceService : IServiceService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<WAMS_ITEMS_SERVICE> _repository;
        private readonly IStockServiceRepository _customRepository;

        public ServiceService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_ITEMS_SERVICE> repository,
            IStockServiceRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = repository;
            _customRepository = customRepository;
        }

        public WAMS_ITEMS_SERVICE GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public IList<V3_List_Service> ListCondition(int page, int size, string code, string name, int store, int category, string enable)
        {
            return _customRepository.ListCondition(page, size, code, name, store, category, enable);
        }

        public int ListConditionCount(int page, int size, string code, string name, int store, int category, string enable)
        {
            return _customRepository.ListConditionCount(page, size, code, name, store, category, enable);
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
            return _repository.Count(m => m.vIDServiceItem == condition) > 0;
        }

        public bool ExistedName(string condition)
        {
            return _repository.Count(m => m.vServiceItemName == condition) > 0;
        }

        public bool Insert(WAMS_ITEMS_SERVICE stock)
        {
            _repository.Add(stock);
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool Update(WAMS_ITEMS_SERVICE stock)
        {
            _repository.Update(stock);
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
