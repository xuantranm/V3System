namespace Vivablast.Repositories
{
    using System.Collections.Generic;
    using System.Linq;

    using Vivablast.Models;
    using Vivablast.Repositories.Interfaces;

    public class Stock_PictureRepository : Repository<Stock_Picture>, IStock_PictureRepository
    {
        private readonly V3Entities contextSub;

        public Stock_PictureRepository()
        {
            contextSub = new V3Entities();
        }

        public List<V3_StockFile_Result> StockPictures(int id)
        {
            return contextSub.V3_StockFile(id).ToList();
        }
    }
}
