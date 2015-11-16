using System;

namespace Ap.Business.Dto
{
    public class ProjectCustom
    {
        public int Id { get; set; }
        public string Project_Code { get; set; }
        public string Project_Name { get; set; }
        public string Status { get; set; }
        public string Location { get; set; }
        public string Main_Contact { get; set; }
        public string Company { get; set; }
        public string Client { get; set; }
        public string Suppervisor { get; set; }
        public string Store { get; set; }
        public string Country { get; set; }
        public System.DateTime Begin_Date { get; set; }
        public Nullable<System.DateTime> End_Date { get; set; }
        public string Remark { get; set; }
        public Nullable<System.DateTime> Created_Date { get; set; }
        public string Created_By { get; set; }
        public Nullable<System.DateTime> Modified_Date { get; set; }
        public string Modified_By { get; set; }
    }
}
