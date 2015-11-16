using System.Collections.Generic;

namespace Vivablast.ViewModels
{
    public class DocumentViewModel
    {
        public int KeyId { get; set; }
        public int DocumentCategoryId { get; set; }
        public string RemoveFiles { get; set; }
        
        public List<FileViewModel> FileList { get; set; }

        public int Count
        {
            get { return FileList.Count; }
        }
    }

    public class FileViewModel
    {
        public int FileId { get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public string FileSize { get; set; }
        public string FileSource { get; set; }
        public string ActionDate { get; set; }
        public string FileGuid { get; set; }
        public string Description { get; set; }
    }
}