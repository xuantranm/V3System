using System;
using System.ComponentModel.DataAnnotations;
using Ap.Business.Domains;
using Ap.Business.Dto;

namespace Vivablast.ViewModels
{
    using System.Collections.Generic;
    using System.Web.Mvc;

    using Models;

    public class ProjectViewModel: ViewModelBase
    {
        public IList<V3_List_Project> ProjectGetListResults { get; set; }

        public ProjectCustom ProjectCustom { get; set; }

        public IList<V3_Stock_Quantity_Management_Result> StockQuantityManagementResults { get; set; }

        public WAMS_PROJECT Project { get; set; }

        public SelectList Countries { get; set; }

        public SelectList Projects { get; set; }

        public SelectList Client { get; set; }

        public SelectList Suppervisor { get; set; } 

        public SelectList StatusProject { get; set; }

        public XUser UserLogin { get; set; }

        #region Project
        public int Id { get; set; }

        [Required]
        [StringLength(16, MinimumLength = 9)]
        public string vProjectID { get; set; }

        [Required]
        [StringLength(64, MinimumLength = 4)]
        public string vProjectName { get; set; }

        [Required]
        [StringLength(300, MinimumLength = 4)]
        public string vLocation { get; set; }

        [Required]
        public string vMainContact { get; set; }

        [Required]
        public string vCompanyName { get; set; }

        public string dBeginDate { get; set; }

        public string dEnd { get; set; }

        public int? StatusId { get; set; }

        public int? ClientId { get; set; }

        public int? CountryId { get; set; }

        public int? StoreId { get; set; }

        public string vDescription { get; set; }

        public bool iEnable { get; set; }

        public DateTime? dCreated { get; set; }

        public DateTime? dModified { get; set; }

        public int? iCreated { get; set; }

        public int? iModified { get; set; }

        public byte[] Timestamp { get; set; }
        #endregion
    }
}