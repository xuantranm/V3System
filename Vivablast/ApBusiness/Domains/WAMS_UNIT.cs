//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System.ComponentModel.DataAnnotations;

namespace ApBusiness.Domains
{
    using System;
    using System.Collections.Generic;
    
    public partial class WAMS_UNIT
    {
        [Key]
        public long bUnitID { get; set; }
        public string vUnitName { get; set; }
        public string vUnitType { get; set; }
        public Nullable<double> bSubQuantity { get; set; }
        public string vSubUnitName { get; set; }
        public Nullable<int> iType { get; set; }
        public byte[] Timestamp { get; set; }
    }
}
