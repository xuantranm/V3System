using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ap.Business.ViewModels
{
    public partial class XStockModel
    {
        public int Id { get; set; }
        public string vStockID { get; set; }
        public string vStockName { get; set; }
        public string vRemark { get; set; }
        // Current use this.
        public string vPhotoPath { get; set; }
        public decimal bQuantity { get; set; }
        public int? bUnitID { get; set; }
        public long? bMeasurementID { get; set; }
        public string vBrand { get; set; }
        public bool? iEnable { get; set; }
        public int? bCategoryID { get; set; }
        public int? bPositionID { get; set; }
        public int? bLabelID { get; set; }
        public double? bWeight { get; set; }
        public string vAccountCode { get; set; }
        public int StoreId { get; set; }
        public string Store { get; set; }
        public string Unit { get; set; }
        public string Category { get; set; }
        public string Position { get; set; }
        public string Label { get; set; }
        public int? iType { get; set; }
        public string Type { get; set; }
        public string PartNo { get; set; }
        public string PartNoFor { get; set; }
        public int? PartNoMiniQty { get; set; }
        public string RalNo { get; set; }
        public string ColorName { get; set; }
        public int? SubCategory { get; set; }
        public int? UserForPaint { get; set; }
        // In future, add more title img,... No use now.
        public string Files { get; set; }
        public string OrginalFile { get; set; }
        public string FilePath { get; set; }
        public DateTime? dCreated { get; set; }
        public DateTime? dModified { get; set; }
        public int? iCreated { get; set; }
        public int? iModified { get; set; }
        public byte[] Timestamp { get; set; }
        public string Created_By { get; set; }
        public string Modified_By { get; set; }
    }
}
