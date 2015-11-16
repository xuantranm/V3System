using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class StockTypeService : IStockTypeService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<WAMS_STOCK_TYPE> _repository;
        private readonly IStockTypeRepository _customRepository;

        public StockTypeService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_STOCK_TYPE> repository,
            IStockTypeRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = repository;
            _customRepository = customRepository;
        }

        public WAMS_STOCK_TYPE GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public IList<V3_List_StockType> ListCondition(int page, int size, string code, string name, string enable)
        {
            return _customRepository.ListCondition(page, size, code, name, enable);
        }

        public int ListConditionCount(int page, int size, string code, string name, string enable)
        {
            return _customRepository.ListConditionCount(page, size, code, name, enable);
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
            return _repository.Count(m => m.TypeCode == condition) > 0;
        }

        public bool ExistedName(string condition)
        {
            return _repository.Count(m => m.TypeName == condition) > 0;
        }

        public bool Insert(WAMS_STOCK_TYPE store)
        {
            _repository.Add(store);
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool Update(WAMS_STOCK_TYPE store)
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
