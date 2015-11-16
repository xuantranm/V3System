using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;
    using System.Web.Mvc;

    using Vivablast.Models;

    public class AccountingViewModel : ViewModelBase
    {
        public SelectList Types { get; set; }
        public SelectList Statuss { get; set; }
        public SelectList FromStores { get; set; }

        public int FStoreId { get; set; }
        public SelectList ToStores { get; set; }
        public int TStoreId { get; set; }
        public SelectList Projects { get; set; }

        public int ProjectId { get; set; }
        public SelectList Suppliers { get; set; }

        public int SupplierId { get; set; }
        public List<V3_List_Accounting> AccountingGetListResults { get; set; }

        public V3_List_Accounting AccountingItem { get; set; }

        public XUser UserLogin { get; set; }

        //public List<AccountingUpdate> ListAccountingUpdate { get; set; } 
    }
}