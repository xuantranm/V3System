using System;
using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;
    using System.Web.Mvc;

    using Models;

    public class StockTypeViewModel : ViewModelBase
    {
        public IList<V3_List_StockType> ListEntity { get; set; }

        public WAMS_STOCK_TYPE Entity { get; set; }

        public SelectList Countries { get; set; }

        public XUser UserLogin { get; set; }

        #region Entity
        public int Id { get; set; }
        public string TypeName { get; set; }
        public string TypeCode { get; set; }
        public bool? iEnable { get; set; }
        public DateTime? dCreated { get; set; }
        public DateTime? dModified { get; set; }
        public int? iCreated { get; set; }
        public int? iModified { get; set; }
        public byte[] Timestamp { get; set; }
        #endregion
    }
}