using System;
using Ap.Business.Domains;
using Vivablast.Models;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;

    using System.Web.Mvc;

    public class AssignAddViewModel : ViewModelBase
    {
        public List<WAMS_ASSIGNNING_STOCKS> AssignStockItemList { get; set; }

        public string LstDeleteDetailItem { get; set; }
    }
}