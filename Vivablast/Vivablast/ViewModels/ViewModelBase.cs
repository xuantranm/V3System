namespace Vivablast.ViewModels
{
    public class ViewModelBase
    {
        public int TotalRecords { get; set; }

        public int TotalPages { get; set; }

        public int CurrentPage { get; set; }

        public int PageSize { get; set; }

        public bool V3 { get; set; }

        public string CheckName { get; set; }

        public string CheckCode { get; set; }

        public int LoginId { get; set; }

        public int Mode { get; set; }
    }
}