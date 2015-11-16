using System.Collections.Generic;
using Ap.Business.Dto;
using Ap.Business.Seedworks;
using Ap.Data.Seedworks;
using Ap.Service.Seedworks;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Services
{
    public class ProjectService : IProjectService
    {
        private readonly IUnitOfWork _unitOfWork;

        private readonly IRepository<WAMS_PROJECT> _projectRepository;
        private readonly IProjectRepository _customRepository;

        public ProjectService(
            IUnitOfWork unitOfWork,
            IRepository<WAMS_PROJECT> projectRepository,
            IProjectRepository customProjectRepository)
        {
            _unitOfWork = unitOfWork;
            _projectRepository = projectRepository;
            _customRepository = customProjectRepository;
        }

        public WAMS_PROJECT GetByKey(int id)
        {
            return _projectRepository.GetByKey(id);
        }

        public WAMS_PROJECT GetByKeySp(int id)
        {
            return _customRepository.GetByKeySp(id);
        }

        public ProjectCustom CustomEntity(int id)
        {
            return _customRepository.CustomEntity(id);
        }

        public IList<V3_List_Project> ListCondition(int page, int size, string projectCode, string projectName, int country, int status, int client, string fd, string td, string enable)
        {
            return _customRepository.ListCondition(page, size, projectCode, projectName, country, status, client, fd, td, enable);
        }

        public int ListConditionCount(int page, int size, string projectCode, string projectName, int country, int status, int client, string fd, string td, string enable)
        {
            return _customRepository.ListConditionCount(page, size, projectCode, projectName, country, status, client, fd, td, enable);
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
            return _projectRepository.Count(m => m.vProjectID == condition) > 0;
        }

        public bool ExistedName(string condition)
        {
            return _projectRepository.Count(m => m.vProjectName == condition) > 0;
        }

        public bool Insert(WAMS_PROJECT project)
        {
            _projectRepository.Add(project);
            _unitOfWork.CommitChanges();
            return true;
        }

        public bool Update(WAMS_PROJECT project)
        {
            _projectRepository.Update(project);
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

        #region Client
        public int InsertClient(Project_Client model)
        {
            return _customRepository.InsertClient(model);
        }

        public int ExistedClient(string condition)
        {
            return _customRepository.ExistedClient(condition);
        }

        public IList<string> ListNameClient(string condition)
        {
            return _customRepository.ListNameClient(condition);
        }
        #endregion
    }
}