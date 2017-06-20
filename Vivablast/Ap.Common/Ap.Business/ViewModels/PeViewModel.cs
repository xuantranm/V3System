using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Ap.Business.Models;
using Vivablast.Models;

namespace Ap.Business.ViewModels
{
    public class PeViewModel
    {
        public IList<V3_List_PO> PoGetListResults { get; set; }

        public int TotalRecords { get; set; }

        public int TotalPages { get; set; }

        public int CurrentPage { get; set; }

        public int PageSize { get; set; }
    }
}
