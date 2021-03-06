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
    
    public partial class WAMS_PURCHASE_ORDER
    {
        [Key]
        public int Id { get; set; }
        public string vPOID { get; set; }
        public Nullable<int> vProjectID { get; set; }
        public int bSupplierID { get; set; }
        public Nullable<int> bPOTypeID { get; set; }
        public Nullable<int> bCurrencyTypeID { get; set; }
        public System.DateTime dPODate { get; set; }
        public Nullable<decimal> fPOTotal { get; set; }
        public string vRemark { get; set; }
        public string vPriceEval { get; set; }
        public string vQuanlityEval { get; set; }
        public string vDeliveryEval { get; set; }
        public string vConformancyToV3Eval { get; set; }
        public string vFromCC { get; set; }
        public string vFromContact { get; set; }
        public string vFromTel { get; set; }
        public string vFromFax { get; set; }
        public string vTermOfPayment { get; set; }
        public Nullable<bool> iEnable { get; set; }
        public Nullable<int> iExample { get; set; }
        public string vPOStatus { get; set; }
        public string vLocation { get; set; }
        public Nullable<System.DateTime> dDeliverDate { get; set; }
        public Nullable<int> iStore { get; set; }
        public Nullable<int> iPayment { get; set; }
        public Nullable<System.DateTime> dCreated { get; set; }
        public Nullable<System.DateTime> dModified { get; set; }
        public Nullable<int> iCreated { get; set; }
        public Nullable<int> iModified { get; set; }
        public byte[] Timestamp { get; set; }
    
        public virtual WAMS_CURRENCY_TYPE WAMS_CURRENCY_TYPE { get; set; }
        public virtual WAMS_PO_TYPE WAMS_PO_TYPE { get; set; }
        public virtual WAMS_SUPPLIER WAMS_SUPPLIER { get; set; }
    }
}
