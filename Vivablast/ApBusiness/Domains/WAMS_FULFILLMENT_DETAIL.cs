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
    
    public partial class WAMS_FULFILLMENT_DETAIL
    {
        public int ID { get; set; }
        public Nullable<int> vPOID { get; set; }
        public Nullable<int> vStockID { get; set; }
        public Nullable<decimal> dQuantity { get; set; }
        public Nullable<decimal> dReceivedQuantity { get; set; }
        public Nullable<decimal> dPendingQuantity { get; set; }
        public Nullable<System.DateTime> dDateDelivery { get; set; }
        public string iShipID { get; set; }
        public string tDescription { get; set; }
        public string vMRF { get; set; }
        public Nullable<decimal> dCurrenQuantity { get; set; }
        public Nullable<System.DateTime> dInvoiceDate { get; set; }
        public string vInvoiceNo { get; set; }
        public Nullable<decimal> dImportTax { get; set; }
        public Nullable<bool> iEnable { get; set; }
        public Nullable<System.DateTime> dDateAssign { get; set; }
        public string SRV { get; set; }
        public Nullable<int> iStore { get; set; }
        public Nullable<System.DateTime> dCreated { get; set; }
        public Nullable<System.DateTime> dModified { get; set; }
        public Nullable<int> iCreated { get; set; }
        public Nullable<int> iModified { get; set; }
        public Nullable<int> AccCheck { get; set; }
        public string AccDescription { get; set; }
        public Nullable<System.DateTime> AccdCreated { get; set; }
        public Nullable<System.DateTime> AccdModified { get; set; }
        public Nullable<int> AcciCreated { get; set; }
        public Nullable<int> AcciModidied { get; set; }
        public Nullable<bool> FlagFile { get; set; }
        public byte[] Timestamp { get; set; }
    
        public virtual WAMS_STOCK WAMS_STOCK { get; set; }
    }
}
