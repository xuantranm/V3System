using System;
using Ap.Business.Domains;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;

    using Vivablast.Models;
    using System.Web.Mvc;

    public class ReturnAddViewModel : ViewModelBase
    {
        public List<WAMS_RETURN_LIST> ReturnStockItemList { get; set; }

        public string LstDeleteDetailItem { get; set; }
    }
}