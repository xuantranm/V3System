using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Ap.Business.Models;

namespace Ap.Business.ViewModels
{
    public class DynamicReportViewModel
    {
        public IList<XDynamicReport> DynamicReports { get; set; }

        public int TotalRecords { get; set; }

        public int TotalPages { get; set; }

        public int CurrentPage { get; set; }

        public int PageSize { get; set; }
    }
}
