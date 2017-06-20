//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System.ComponentModel.DataAnnotations;
using Ap.Data.Entities;

namespace Ap.Business.Domains
{
    using System;
    using System.Collections.Generic;
    
    public partial class WAMS_USER: BaseEntity
    {
        public WAMS_USER()
        {
            this.WAMS_FUNCTION_MANAGEMENT = new HashSet<WAMS_FUNCTION_MANAGEMENT>();
        }

        [Key]
        public int bUserId { get; set; }
        public string vUsername { get; set; }
        public string vPassword { get; set; }
        public string vFirstName { get; set; }
        public string vLastName { get; set; }
        public string vDepartment { get; set; }
        public string vPhone { get; set; }
        public string vMobile { get; set; }
        public string vEmail { get; set; }
        public Nullable<bool> iEnable { get; set; }
        public string vNewPassword { get; set; }
        public Nullable<int> storeId { get; set; }
        public Nullable<System.DateTime> dCreated { get; set; }
        public Nullable<System.DateTime> dModified { get; set; }
        public Nullable<int> iCreated { get; set; }
        public Nullable<int> iModified { get; set; }
        public byte[] Timestamp { get; set; }
    
        public virtual Store Store { get; set; }
        public virtual ICollection<WAMS_FUNCTION_MANAGEMENT> WAMS_FUNCTION_MANAGEMENT { get; set; }
    }
}
