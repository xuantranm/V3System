using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Web.Mvc;

    using Models;

    public class StockCreateViewModel : ViewModelBase
    {
        public WAMS_STOCK Stock { get; set; }

        public SelectList Stores;

        public int? StoreId { get; set; }

        public SelectList Types;

        public SelectList Categories;
        
        public SelectList Units;
        
        public SelectList Positions;
        
        public SelectList Labels;
    }
}
