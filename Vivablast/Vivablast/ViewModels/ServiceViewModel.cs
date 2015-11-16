using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Web.Mvc;

    using Vivablast.Models;

    public class ServiceViewModel : ViewModelBase
    {
        public WAMS_ITEMS_SERVICE Service { get; set; }
        public SelectList Stores;
        public SelectList Categories;
        public SelectList Units;
        public SelectList Positions;
        public IList<V3_List_Service> ServiceList { get; set; }

        public WAMS_ITEMS_SERVICE itemService { get; set; }

        #region Service
        public int Id { get; set; }
        public string vIDServiceItem { get; set; }
        public string vServiceItemName { get; set; }
        public string vDescription { get; set; }
        public int? bCategoryID { get; set; }
        public int? bUnitID { get; set; }
        public int? bPositionID { get; set; }
        public double? bWeight { get; set; }
        public string vAccountCode { get; set; }
        public DateTime? dCreated { get; set; }
        public DateTime? dModified { get; set; }
        public int? iCreated { get; set; }
        public int? iModified { get; set; }
        public int? StoreId { get; set; }
        public byte[] Timestamp { get; set; }
        #endregion

        public XUser UserLogin { get; set; }
    }
}