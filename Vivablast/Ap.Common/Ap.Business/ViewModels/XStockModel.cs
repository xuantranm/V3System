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
        public Nullable<int> bUnitID { get; set; }
        public Nullable<long> bMeasurementID { get; set; }
        public string vBrand { get; set; }
        public Nullable<bool> iEnable { get; set; }
        public Nullable<int> bCategoryID { get; set; }
        public Nullable<int> bPositionID { get; set; }
        public Nullable<int> bLabelID { get; set; }
        public Nullable<double> bWeight { get; set; }
        public string vAccountCode { get; set; }
        public Nullable<int> iType { get; set; }
        public string PartNo { get; set; }
        public string PartNoFor { get; set; }
        public Nullable<int> PartNoMiniQty { get; set; }
        public string RalNo { get; set; }
        public string ColorName { get; set; }
        public string Position { get; set; }
        public int? SubCategory { get; set; }
        public int? UserForPaint { get; set; }
        public DateTime? dCreated { get; set; }
        public DateTime? dModified { get; set; }
        public int? iCreated { get; set; }
        public int? iModified { get; set; }
        public byte[] Timestamp { get; set; }

        public string Unit { get; set; }
        public string Category { get; set; }
        public string Label { get; set; }
        public string Type { get; set; }
        public string Files { get; set; }
        public string OrginalFile { get; set; }
        public string FilePath { get; set; }

        public string Stores { get; set; }
        public string Quantity { get; set; }
        public string Created_By { get; set; }
        public string Modified_By { get; set; }
    }
}
