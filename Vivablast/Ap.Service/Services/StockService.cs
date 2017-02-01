using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Business.ViewModels;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class StockService : IStockService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<WAMS_STOCK> _repository;
        private readonly IStockRepository _customRepository;

        public StockService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_STOCK> stockRepository,
            IStockRepository customRepository)
        {
            _unitOfWork = unitOfWork;
            _repository = stockRepository;
            _customRepository = customRepository;
        }

        public WAMS_STOCK GetByKey(int id)
        {
            return _repository.GetByKey(id);
        }

        public XStockViewModel StockViewModelFilter(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable)
        {
            return _customRepository.StockViewModelFilter(page, size, stockCode, stockName, store, type, category, enable);
        }


        public IList<V3_List_Stock> PeListCondition(int page, int size, string stockCode, string stockName, string store,
            int type, int category, string enable, int supplier)
        {
            return _customRepository.PeListCondition(page, size, stockCode, stockName, store, type, category, enable,
                supplier);
        }

        public int PeListConditionCount(int page, int size, string stockCode, string stockName, string store, int type,
            int category, string enable, int supplier)
        {
            return _customRepository.PeListConditionCount(page, size, stockCode, stockName, store, type, category, enable,
                supplier);
        }

        public IList<V3_List_Stock> StockInListCondition(int page, int size, string stockCode, string stockName,
            string store, int type, int category, string enable, int pe)
        {
            return _customRepository.StockInListCondition(page, size, stockCode, stockName, store, type, category, enable,
                pe);
        }

        public int StockInListConditionCount(int page, int size, string stockCode, string stockName, string store,
            int type, int category, string enable, int pe)
        {
            return _customRepository.StockInListConditionCount(page, size, stockCode, stockName, store, type, category, enable,
                pe);
        }

        public IList<V3_List_Stock> StockOutListCondition(int page, int size, string stockCode, string stockName,
            int store, int type, int category)
        {
            return _customRepository.StockOutListCondition(page, size, stockCode, stockName, store, type, category);
        }

        public int StockOutListConditionCount(int page, int size, string stockCode, string stockName, int store,
            int type, int category)
        {
            return _customRepository.StockOutListConditionCount(page, size, stockCode, stockName, store, type, category);
        }

        public IList<V3_List_Stock> StockReturnListCondition(int page, int size, string stockCode, string stockName,
            int project, int type, int category)
        {
            return _customRepository.StockReturnListCondition(page, size, stockCode, stockName, project, type, category);
        }

        public int StockReturnListConditionCount(int page, int size, string stockCode, string stockName, int project,
            int type, int category)
        {
            return _customRepository.StockReturnListConditionCount(page, size, stockCode, stockName, project, type, category);
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
            return _repository.Count(m => m.vStockID == condition) > 0;
        }

        public bool ExistedName(string condition)
        {
            return _repository.Count(m => m.vStockName == condition) > 0;
        }

        public bool Insert(WAMS_STOCK stock)
        {
            _repository.Add(stock);
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool Update(WAMS_STOCK stock)
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

        public IList<V3_Stock_Quantity_Management_Result> ListStockQuantity(int page, int size, string stockCode, string stockName, string store, int type, int category, string fd, string td, string enable)
        {
            return _customRepository.ListStockQuantity(page, size, stockCode, stockName, store, type, category, fd, td, enable);
        }

        public int ListStockQuantityCount(int page, int size, string stockCode, string stockName, string store, int type, int category, string fd, string td, string enable)
        {
            return _customRepository.ListStockQuantityCount(page, size, stockCode, stockName, store, type, category, fd, td, enable);
        }

        public bool ReActive(string condition)
        {
            return true;
        }

        public string NewStockCode(int type, int category)
        {
            return _customRepository.NewStockCode(type,category);
        }
    }
}
