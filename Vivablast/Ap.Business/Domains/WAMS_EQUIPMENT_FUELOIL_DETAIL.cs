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
    
    public partial class WAMS_EQUIPMENT_FUELOIL_DETAIL
    {
        [Key]
        public long bEFDID { get; set; }
        public long bEquipmentID { get; set; }
        public string bFuelOilID { get; set; }
        public string vProjectID { get; set; }
        public System.DateTime dLastRefilled { get; set; }
        public Nullable<double> bFuelQuantity { get; set; }
        public Nullable<double> bFuelKm { get; set; }
        public Nullable<double> bFuelHourUse { get; set; }
        public Nullable<double> bOillQuantity { get; set; }
        public Nullable<double> bOillKm { get; set; }
        public Nullable<double> bOillHourUse { get; set; }
    }
}
