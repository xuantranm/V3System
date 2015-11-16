using System.Collections;
using System.Collections.Generic;
using Vivablast.Models;

namespace Ap.Business.Seedworks
{
    public interface ICategoryRepository
    {
        IList<V3_List_Category> ListCondition(int page, int size, string code, string name, int type, string enable);

        int ListConditionCount(int page, int size, string code, string name, int type, string enable);

        IList<string> ListCode(string condition);

        IList<string> ListName(string condition);

        int CheckDelete(int id);

        int Delete(int id);
    }
}
