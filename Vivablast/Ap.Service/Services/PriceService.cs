using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class PriceService : IPriceService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<Product_Price> _repository;
        private readonly IPriceRepository _customRepository;

        public PriceService(
            IUnitOfWork unitOfWork,
            IRepository<Product_Price> priceRepository,
            IPriceRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = priceRepository;
            _customRepository = customRepository;
        }

        public Product_Price GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public IList<V3_List_Price> ListCondition(int page, int size, int store, int supplier, string stockCode, string stockName, int status, string fd, string td, string enable)
        {
            return _customRepository.ListCondition(page, size, store, supplier, stockCode, stockName, status, fd, td, enable);
        }

        public int ListConditionCount(int page, int size, int store, int supplier, string stockCode, string stockName, int status, string fd, string td, string enable)
        {
            return _customRepository.ListConditionCount(page, size, store, supplier, stockCode, stockName, status, fd, td, enable);
        }

        public V3_Price_By_Id GetByKeySp(int id, string enable)
        {
            return _customRepository.GetByKeySp(id, enable);
        }

        public bool Insert(Product_Price price)
        {
            _repository.Add(price);
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool Update(Product_Price price)
        {
            _repository.Update(price);
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
