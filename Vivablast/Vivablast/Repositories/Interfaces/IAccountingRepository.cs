namespace Vivablast.Repositories.Interfaces
{
    using System.Collections.Generic;

    using Vivablast.Models;
    using Vivablast.ViewModels.Builders;

    public interface IAccountingRepository: IRepository<V3_Accounting_GetList_Result>
    {
        AccountingViewModelBuilder GetViewModelIndex();

        AccountingViewModelBuilder GetViewModelList(int page, int size, int type, int status, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td);

        List<V3_Accounting_GetListRpt_Result> ExportData(int page, int size, int type, int status, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td);

        void UpdateIn(AccountingUpdate model);
        void UpdateOut(AccountingUpdate model);
        void UpdateReturn(AccountingUpdate model);
    }
}
