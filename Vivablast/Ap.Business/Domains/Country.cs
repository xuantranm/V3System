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
    
    public partial class Country
    {
        public Country()
        {
            //this.WAMS_PROJECT = new HashSet<WAMS_PROJECT>();
        }

        [Key]
        public int Id { get; set; }
        public string Iso { get; set; }
        public string NameBasic { get; set; }
        public string NameNice { get; set; }
        public string Iso3 { get; set; }
        public Nullable<int> NumCode { get; set; }
        public Nullable<int> PhoneCode { get; set; }
        public Nullable<bool> iEnable { get; set; }
        public byte[] Timestamp { get; set; }
    
        //public virtual ICollection<WAMS_PROJECT> WAMS_PROJECT { get; set; }
    }
}
