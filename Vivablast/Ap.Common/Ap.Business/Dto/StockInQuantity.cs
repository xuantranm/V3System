//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Vivablast.Models
{
    using System;

    public partial class StockInQuantity
    {
        public int Id { get; set; }
        public int PeId { get; set; }
        public decimal PeQuantity { get; set; }
        public decimal PendingQuantity { get; set; }
        public decimal ReceivedQuantity { get; set; }
        public string Mrf { get; set; }
    }
}