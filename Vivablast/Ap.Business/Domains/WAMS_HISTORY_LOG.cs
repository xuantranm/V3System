//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System.ComponentModel.DataAnnotations;

namespace Ap.Business.Domains
{
    using System;
    using System.Collections.Generic;
    
    public partial class WAMS_HISTORY_LOG
    {
        [Key]
        public long bHistoryLogID { get; set; }
        public string vUserName { get; set; }
        public string vFormName { get; set; }
        public string vObject { get; set; }
        public string vActionName { get; set; }
        public Nullable<double> bQuantity { get; set; }
        public System.DateTime dDate { get; set; }
        public Nullable<System.DateTime> dActionDate { get; set; }
        public string vDescription { get; set; }
        public Nullable<long> bObjectID { get; set; }
        public Nullable<long> bFormID { get; set; }
        public Nullable<long> bActionID { get; set; }
    }
}
