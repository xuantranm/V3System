using System;

namespace Ap.Business.Models
{
    public partial class XStock
    {
        public int No { get; set; }
        public int Id { get; set; }
        public string Stock_Code { get; set; }
        public string Stock_Name { get; set; }
        public string Brand { get; set; }
        public string Account_Code { get; set; }
        public string Type { get; set; }
        public string Unit { get; set; }
        public string Category { get; set; }
        public int? StockID { get; set; }
        public string Stores { get; set; }
        public string Quantity { get; set; }
        public decimal? Weight { get; set; }
        public string RalNo { get; set; }
        public string Color { get; set; }
        public string PartNo { get; set; }
        public string Remark { get; set; }
        public DateTime? Created_Date { get; set; }
        public string Created_By { get; set; }
        public DateTime? Modified_Date { get; set; }
        public string Modified_By { get; set; }
    }
}
