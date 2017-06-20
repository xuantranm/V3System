using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface IUserRepository
    {
        //XUser GetUserAndRole(int? id, string user);

        V3_Check_Login CheckUser(string user);

        IList<XUser> ListCondition(int page, int size, int store, string department, string user, string enable);

        int ListConditionCount(int page, int size, int store, string department, string user, string enable);

        IList<string> ListName(string condition);

        IList<string> ListEmail(string condition);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
