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
    
    public partial class WAMS_SCAFOLDING
    {
        [Key]
        public long bScaffoldingID { get; set; }
        public string vScaffoldingID { get; set; }
        public string vScaffoldingType { get; set; }
        public string vScaffoldingName { get; set; }
    }
}
