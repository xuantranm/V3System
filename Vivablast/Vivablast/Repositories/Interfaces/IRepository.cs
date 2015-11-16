namespace Vivablast.Repositories.Interfaces
{
    using System;
    using System.Collections.Generic;

    using Vivablast.Models;

    public interface IRepository<TEntity> : IDisposable 
    {
        IEnumerable<TEntity> GetAll();

        TEntity GetById(object id);

        void Insert(TEntity entity);

        void Delete(object id);

        void Update(TEntity entity);

        void Save();

        int Count();

        List<GetLookUp_Result> GetLookUp(string type);
    }
}
