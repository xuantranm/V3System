using System;
using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;
    using System.Web.Mvc;

    using Models;

    public class CategoryViewModel : ViewModelBase
    {
        public IList<V3_List_Category> ListEntity { get; set; }

        public WAMS_CATEGORY Entity { get; set; }

        public SelectList Types { get; set; }

        public XUser UserLogin { get; set; }

        #region Entity
        public int bCategoryID { get; set; }
        public string vCategoryName { get; set; }
        public string vCategoryType { get; set; }
        public int? iType { get; set; }
        public string CategoryCode { get; set; }
        public bool? iEnable { get; set; }
        public DateTime? dCreated { get; set; }
        public DateTime? dModified { get; set; }
        public int? iCreated { get; set; }
        public int? iModified { get; set; }
        public byte[] Timestamp { get; set; }
        #endregion
    }
}