using System;
using System.Web.Configuration;
using Ap.Business.Domains;
using Ap.Business.Models;
using Vivablast.Models;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;

    public class XRequisitionPdfViewModel
    {
        public int Id { get; set; }

        public string vMRF { get; set; }

        public string vFrom { get; set; }

        public int? vProjectID { get; set; }

        public int? iStore { get; set; }
        public string vDeliverLocation { get; set; }
        public string ProjectCode { get; set; }

        public string ProjectName { get; set; }

        public string Remark { get; set; }

        public XUser UserLogin { get; set; }

        public string DeliverDateTemp { get; set; }

        public IList<V3_RequisitionDetail_Result> GetRequisitionDetailsVResults { get; set; }
        public int TotalRecords { get; set; }

        public string Domain
        {
            get { return WebConfigurationManager.AppSettings["domain"]; }
        }
    }
}