using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IUserService
    {
        XUser GetByKey(int id);

        XUser GetByName(string name); 

        IList<XUser> ListCondition(int page, int size, int store, string department, string user, string enable);

        int ListConditionCount(int page, int size, int store, string department, string user, string enable);

        IList<string> ListName(string condition);

        IList<string> ListEmail(string condition);

        bool ExistedName(string condition);

        bool ExistedEmail(string condition);

        bool Insert(XUser entity);

        bool Update(XUser entity);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
