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
    
    public partial class WAMS_ASSIGNING_WORKER
    {
        public long bAssignWorkerID { get; set; }
        public string vWorkerID { get; set; }
        public string vProjectID { get; set; }
        public long bDuration { get; set; }
        public System.DateTime dAssigningDate { get; set; }
    
        public virtual WAMS_WORKER WAMS_WORKER { get; set; }
    }
}
