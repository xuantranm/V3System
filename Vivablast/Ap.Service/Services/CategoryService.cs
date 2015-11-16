using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class CategoryService : ICategoryService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<WAMS_CATEGORY> _repository;
        private readonly ICategoryRepository _customRepository;

        public CategoryService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_CATEGORY> repository,
            ICategoryRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = repository;
            _customRepository = customRepository;
        }

        public WAMS_CATEGORY GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public IList<V3_List_Category> ListCondition(int page, int size, string code, string name, int type, string enable)
        {
            return _customRepository.ListCondition(page, size, code, name, type, enable);
        }

        public int ListConditionCount(int page, int size, string code, string name, int type, string enable)
        {
            return _customRepository.ListConditionCount(page, size, code, name, type, enable);
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
            return _repository.Count(m => m.CategoryCode == condition) > 0;
        }

        public bool ExistedName(string condition)
        {
            return _repository.Count(m => m.vCategoryName == condition) > 0;
        }

        public bool Insert(WAMS_CATEGORY store)
        {
            _repository.Add(store);
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool Update(WAMS_CATEGORY store)
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
