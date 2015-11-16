using System.Collections.Generic;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Ap.Service.Seedworks
{
    public interface IAccountingService
    {
        IList<V3_List_Accounting> ListCondition(int page, int size, int type, int status, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td);

        int ListConditionCount(int page, int size, int type, int status, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td);

        IList<string> ListCode(string condition);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
