namespace Vivablast.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Entity;
    using System.Linq;

    using Vivablast.Models;
    using Vivablast.Repositories.Interfaces;

    public class Repository<TEntity> : IRepository<TEntity> where TEntity : class
    {
        private readonly V3Entities context;

        private readonly DbSet<TEntity> dbset;

        private bool disposed;

        public Repository()
        {
            this.context = new V3Entities();
            this.dbset = this.context.Set<TEntity>();
        }

        public IEnumerable<TEntity> GetAll()
        {
            return this.dbset.ToList();
        }

        public int Count()
        {
            return this.dbset.Count();
        }

        public virtual TEntity GetById(object id)
        {
            return this.dbset.Find(id);
        }

        public virtual void Insert(TEntity entity)
        {
            this.dbset.Add(entity);
        }

        public virtual void Delete(object id)
        {
            TEntity entityToDelete = this.dbset.Find(id);
            this.Delete(entityToDelete);
        }

        public virtual void Delete(TEntity entityToDelete)
        {
            if (this.context.Entry(entityToDelete).State == EntityState.Detached)
            {
                this.dbset.Attach(entityToDelete);
            }

            this.dbset.Remove(entityToDelete);
        }

        public virtual void Update(TEntity entityToUpdate)
        {
            this.dbset.Attach(entityToUpdate);
            this.context.Entry(entityToUpdate).State = EntityState.Modified;
        }

        public void Save()
        {
            this.context.SaveChanges();
        }

        public List<GetLookUp_Result> GetLookUp(string type)
        {
            var deparments = this.context.GetLookUp(type).ToList();

            return deparments;
        }

        public void Dispose()
        {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    this.context.Dispose();
                }
            }

            this.disposed = true;
        }
    }
}
