//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ApBusiness.Domains
{
    using System;
    using System.Collections.Generic;
    
    public partial class WAMS_EQUIPMENT
    {
        public long bEquipmentID { get; set; }
        public string vEquipmentID { get; set; }
        public string vWeight { get; set; }
        public string vPowerSource { get; set; }
        public string vPlugType { get; set; }
        public System.DateTime dWarrantyDate { get; set; }
        public System.DateTime dDateOfReceive { get; set; }
        public string vSystematicMaintenance { get; set; }
        public Nullable<long> bPositionID { get; set; }
        public string vDescription { get; set; }
        public string vCondition { get; set; }
    
        public virtual WAMS_POSITION WAMS_POSITION { get; set; }
    }
}
