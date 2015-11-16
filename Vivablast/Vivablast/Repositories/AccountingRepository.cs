namespace Vivablast.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.Objects;
    using System.Linq;
    using System.Web.Mvc;

    using Vivablast.Models;
    using Vivablast.Repositories.Interfaces;
    using Vivablast.ViewModels.Builders;

    public class AccountingRepository : Repository<V3_Accounting_GetList_Result>, IAccountingRepository
    {
        private readonly V3Entities contextSub;

        public AccountingRepository()
        {
            this.contextSub = new V3Entities();
        }

        public AccountingViewModelBuilder GetViewModelIndex()
        {
            var viewModelBuilder = new AccountingViewModelBuilder
            {
                FromStores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                ToStores = new SelectList(this.contextSub.V3_GetStoreDDL(), "Id", "sName"),
                Projects = new SelectList(this.contextSub.V3_GetProjectDDL(), "Id", "vProjectID"),
                Suppliers = new SelectList(this.contextSub.V3_GetSupplierDDL(), "bSupplierID", "vSupplierName")
            };

            return viewModelBuilder;
        }

        public AccountingViewModelBuilder GetViewModelList(int page, int size, int type, int status, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td)
        {
            var output = new ObjectParameter("ItemCount", typeof(int));
            var data = contextSub.V3_Accounting_GetList(page, size, type, status, sirv, stock, beginStore, endStore, project, po, supplier, fd, td, output).ToList();

            var totalRecord = output.Value;
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            var totalPages = Convert.ToInt32(Math.Ceiling(totalTemp));

            var viewModel = new AccountingViewModelBuilder
            {
                AccountingGetListResults = data,
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return viewModel;
        }

        public List<V3_Accounting_GetListRpt_Result> ExportData(int page, int size, int type, int status, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td)
        {
            return contextSub.V3_Accounting_GetListRpt(page, size, type, status, sirv, stock, beginStore, endStore, project, po, supplier, fd, td).ToList();
        }

        public void UpdateIn(AccountingUpdate model)
        {
            
        }

        public void UpdateOut(AccountingUpdate model)
        {
            
        }

        public void UpdateReturn(AccountingUpdate model)
        {
            
        }
    }
}
