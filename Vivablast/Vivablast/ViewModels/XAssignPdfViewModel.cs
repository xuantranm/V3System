using System;
using Ap.Business.Domains;
using Ap.Business.Models;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;

    public class XAssignPdfViewModel
    {
        public string Mrf { get; set; }
        public string ProjectCode { get; set; }
        public string Siv { get; set; }
        public DateTime Date { get; set; }
        public XUser UserLogin { get; set; }
        public IList<XStockOut> StockOuts { get; set; }

        public decimal TotalQuantity { get; set; }
        public string DateFormat
        {
            get { return Date.ToString("dd/MM/yyyy"); }
        }
    }
}