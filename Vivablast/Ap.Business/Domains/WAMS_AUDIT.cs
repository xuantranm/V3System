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
    
    public partial class WAMS_AUDIT
    {
        [Key]
        public long iAuditID { get; set; }
        public long iUserID { get; set; }
        public System.DateTime dDate { get; set; }
        public string vName { get; set; }
        public string vAction { get; set; }
        public string vTypeName { get; set; }
        public Nullable<long> iEnable { get; set; }
    }
}
