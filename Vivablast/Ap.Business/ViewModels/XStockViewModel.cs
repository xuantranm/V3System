﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Ap.Business.Domains;
using Ap.Business.Models;
using Vivablast.Models;

namespace Ap.Business.ViewModels
{
    public class XStockViewModel
    {
        public IList<XStockModel> StockVs { get; set; }

        public int TotalRecords { get; set; }

        public int TotalPages { get; set; }

        public int CurrentPage { get; set; }

        public int PageSize { get; set; }

        public XUser UserLogin { get; set; }
    }
}
