using System;
using System.Web.Configuration;
using Ap.Business.Domains;
using Ap.Business.Models;
using Vivablast.Models;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;

    public class XPePdfViewModel
    {
        public V3_PE_PDF PurchaseOrderCustom { get; set; }

        public IList<V3_Pe_Detail> PoDetailsVResults { get; set; }

        //public int VAT { get; set; }

        public string Domain
        {
            get { return WebConfigurationManager.AppSettings["domain"]; }
        }
    }
}