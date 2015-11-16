using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class AccountingService : IAccountingService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IAccountingRepository _customRepository;

        public AccountingService(
            IUnitOfWork unitOfWork,
            IAccountingRepository customRepository)
        {
            _unitOfWork = unitOfWork;
           _customRepository = customRepository;
        }

        public IList<V3_List_Accounting> ListCondition(int page, int size, int type, int status, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td)
        {
            return _customRepository.ListCondition(page, size, type, status, sirv, stock, beginStore, endStore, project, supplier, po, fd, td);
        }

        public int ListConditionCount(int page, int size, int type, int status, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td)
        {
            return _customRepository.ListConditionCount(page, size, type, status, sirv, stock, beginStore, endStore, project, supplier, po, fd, td);
        }

        public IList<string> ListCode(string condition)
        {
            return _customRepository.ListCode(condition);
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
