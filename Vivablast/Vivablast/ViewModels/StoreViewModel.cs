using System;
using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;
    using System.Web.Mvc;

    using Models;

    public class StoreViewModel : ViewModelBase
    {
        public IList<V3_List_Store> StoreManagements { get; set; }

        public Store Store { get; set; }

        public SelectList Countries { get; set; }

        public XUser UserLogin { get; set; }

        #region New
        public int Id { get; set; }

        public string Name { get; set; }

        public string Code { get; set; }

        public int? CountryId { get; set; }

        public string Address { get; set; }

        public string Tel { get; set; }

        public string Phone { get; set; }

        public string Description { get; set; }

        public bool? iEnable { get; set; }

        public DateTime? dCreated { get; set; }

        public DateTime? dModified { get; set; }

        public int? iCreated { get; set; }

        public int? iModified { get; set; }

        public byte[] Timestamp { get; set; }

        #endregion
    }
}