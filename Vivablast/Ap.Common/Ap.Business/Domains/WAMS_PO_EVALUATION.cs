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
    
    public partial class WAMS_PO_EVALUATION
    {
        [Key]
        public long bPOEvalID { get; set; }
        public long bPrice { get; set; }
        public long bQuantity { get; set; }
        public long bDelivery { get; set; }
        public long bConformecyToV3 { get; set; }
        public long bGoodFrom { get; set; }
        public long bGoodTo { get; set; }
        public long bAcceptFrom { get; set; }
        public long bAcceptTo { get; set; }
        public long bPoorFrom { get; set; }
        public long bPoorTo { get; set; }
        public long bUnacceptFrom { get; set; }
        public long bUnacceptTo { get; set; }
        public System.DateTime dDateChange { get; set; }
        public byte[] Timestamp { get; set; }
    }
}
