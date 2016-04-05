using System;
using System.Web.Configuration;
using Ap.Business.Domains;
using Ap.Business.Models;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;

    public class XInPdfViewModel
    {
        public string From { get; set; }
        public string To { get; set; }
        public string ProjectCode { get; set; }
        public string ProjectName { get; set; }
        public string Srv { get; set; }
        public DateTime Date { get; set; }

        public XUser UserLogin { get; set; }
        public IList<XStockIn> StockIns { get; set; }

        public decimal TotalQuantity { get; set; }
        public string DateFormat
        {
            get { return Date.ToString("dd/MM/yyyy"); }
        }

        public string Domain
        {
            get { return WebConfigurationManager.AppSettings["domain"]; }
        }
    }
}