namespace Vivablast.Repositories.Interfaces
{
    using System.Collections.Generic;

    using Vivablast.Models;

    public interface IStock_PictureRepository : IRepository<Stock_Picture>
    {
        List<V3_StockFile_Result> StockPictures(int id);
    }
}
