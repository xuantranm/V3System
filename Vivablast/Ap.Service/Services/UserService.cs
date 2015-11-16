using Ap.Business.Domains;
using Ap.Business.Seedworks;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class UserService : IUserService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IRepository<XUser> _userRepository;
        private readonly IUserRepository _customUserRepository;

        public UserService(
            IUnitOfWork unitOfWork,
            IRepository<XUser> userRepository,
            IUserRepository customUserRepository)
        {
            _unitOfWork = unitOfWork;
            _customUserRepository = customUserRepository;
            _userRepository = userRepository;
        }

        public XUser GetByKey(int id)
        {
            return _userRepository.GetByKey(id);
        }

        public XUser GetByName(string name)
        {
            return _userRepository.First(x => x.UserName.Equals(name));
        }

        public IList<XUser> ListCondition(int page, int size, int store, string department, string user, string enable)
        {
            return _customUserRepository.ListCondition(page, size, store, department, user, enable);
        }

        public int ListConditionCount(int page, int size, int store, string department, string user, string enable)
        {
            return _customUserRepository.ListConditionCount(page, size, store, department, user, enable);
        }

        public IList<string> ListName(string condition)
        {
            return _customUserRepository.ListName(condition);
        }

        public IList<string> ListEmail(string condition)
        {
            return _customUserRepository.ListEmail(condition);
        }

        public bool ExistedName(string condition)
        {
            return _userRepository.Count(m => m.UserName == condition) > 0;
        }

        public bool ExistedEmail(string condition)
        {
            return _userRepository.Count(m => m.Email == condition) > 0;
        }

        public bool Insert(XUser entity)
        {
            _userRepository.Add(entity);
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool Update(XUser entity)
        {
            _userRepository.Update(entity);
            _unitOfWork.CommitChanges();
            return true;
        }

        public int CheckDelete(int id)
        {
            return _customUserRepository.CheckDelete(id);
        }

        public int Delete(int id)
        {
            return _customUserRepository.Delete(id);
        }
    }
}
