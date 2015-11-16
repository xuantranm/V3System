using Ap.Common.Specifications;
using Ap.Data.Entities;
using Ap.Data.Seedworks;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core;
using System.Data.Entity.Core.Metadata.Edm;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using ApData.Entities;
using ApData.Seedworks;

namespace ApData.Repositories
{
    public class Repository<TEntity> : IRepository<TEntity> where TEntity : BaseEntity
    {
        private readonly DbContext _dbContext;

        private readonly IUnitOfWork _unitOfWork;

        private readonly DbSet<TEntity> _dbSet;

        public Repository(IDbContext dbContext)
        {
            _dbContext = dbContext as DbContext;
            _unitOfWork = new UnitOfWork(dbContext);

            if (_dbContext != null)
            {
                _dbSet = _dbContext.Set<TEntity>();
            }
        }

        public TEntity GetByKey(object keyValue)
        {
            //key = 0 then return default Entity, we don't query it from database
            if ((keyValue is int || keyValue is long) && Convert.ToInt64(keyValue) == 0) return default(TEntity);

            object entity;
            if (((IObjectContextAdapter)_dbContext).ObjectContext.TryGetObjectByKey(GetEntityKey(keyValue), out entity))
            {
                return (TEntity)entity;
            }

            return default(TEntity);
        }

        public TEntity GetByKey(Dictionary<string, object> keyValues)
        {
            return _dbSet.Find(keyValues);
        }

        public IQueryable<TEntity> GetQuery(Expression<Func<TEntity, bool>> criteria)
        {
            return _dbSet.Where(criteria);
        }

        public IQueryable<TEntity> GetQuery(ISpecification<TEntity> criteria)
        {
            return criteria.SatisfyingEntitiesFrom(_dbSet);
        }

        public TEntity Single(Expression<Func<TEntity, bool>> criteria)
        {
            return _dbSet.SingleOrDefault(criteria);
        }

        public TEntity Single(ISpecification<TEntity> criteria)
        {
            return criteria.SatisfyingEntityFrom(_dbSet);
        }

        public TEntity First(Expression<Func<TEntity, bool>> criteria)
        {
            return _dbSet.First(criteria);
        }

        public TEntity First(ISpecification<TEntity> criteria)
        {
            return criteria.SatisfyingEntityFrom(_dbSet);
        }

        public void Add(TEntity entity)
        {
            _dbSet.Add(entity);
        }

        public void AddRange(IEnumerable<TEntity> entities)
        {
            _dbSet.AddRange(entities);
        }

        public void Delete(object id)
        {
            var entity = _dbSet.Find(id);
            _dbSet.Remove(entity);
        }

        public void Delete(TEntity entity)
        {
            _dbSet.Remove(entity);
        }

        public void Delete(Expression<Func<TEntity, bool>> criteria)
        {
            var entities = Find(criteria);

            foreach (var entity in entities)
            {
                Delete(entity);
            }
        }

        public void Delete(ISpecification<TEntity> criteria)
        {
            var entities = Find(criteria);

            foreach (var entity in entities)
            {
                Delete(entity);
            }
        }

        public void Update(TEntity entity)
        {
            _dbContext.Entry(entity).CurrentValues.SetValues(entity);
        }

        public void Update(TEntity entity, Expression<Func<TEntity, bool>> criteria)
        {
            var original = FindOne(criteria);
            _dbContext.Entry(original).CurrentValues.SetValues(entity);
        }

        public IQueryable<TEntity> Find(Expression<Func<TEntity, bool>> criteria)
        {
            return _dbSet.Where(criteria);
        }

        public IQueryable<TEntity> Find(ISpecification<TEntity> criteria)
        {
            return criteria.SatisfyingEntitiesFrom(_dbSet);
        }

        public TEntity FindOne(Expression<Func<TEntity, bool>> criteria)
        {
            return _dbSet.FirstOrDefault(criteria);
        }

        public TEntity FindOne(ISpecification<TEntity> criteria)
        {
            return criteria.SatisfyingEntityFrom(_dbSet);
        }

        public IQueryable<TEntity> GetAll()
        {
            return _dbSet;
        }

        public IQueryable<TEntity> Get<TOrderBy>(Expression<Func<TEntity, TOrderBy>> orderBy, int pageIndex, int pageSize, SortOrder sortOrder = SortOrder.Ascending)
        {
            return sortOrder == SortOrder.Ascending
                       ? _dbSet.OrderBy(orderBy).Skip((pageIndex - 1) * pageSize).Take(pageSize)
                       : _dbSet.OrderByDescending(orderBy).Skip((pageIndex - 1) * pageSize).Take(pageSize);
        }

        public IQueryable<TEntity> Get<TOrderBy>(Expression<Func<TEntity, bool>> criteria, Expression<Func<TEntity, TOrderBy>> orderBy, int pageIndex, int pageSize, SortOrder sortOrder = SortOrder.Ascending)
        {
            return sortOrder == SortOrder.Ascending
                       ? _dbSet.Where(criteria).OrderBy(orderBy).Skip((pageIndex - 1) * pageSize).Take(pageSize)
                       : _dbSet.Where(criteria).OrderByDescending(orderBy).Skip((pageIndex - 1) * pageSize).Take(pageSize);
        }

        public IQueryable<TEntity> Get<TOrderBy>(ISpecification<TEntity> criteria, Expression<Func<TEntity, TOrderBy>> orderBy, int pageIndex, int pageSize, SortOrder sortOrder = SortOrder.Ascending)
        {
            return sortOrder == SortOrder.Ascending
                       ? criteria.SatisfyingEntitiesFrom(_dbSet).OrderBy(orderBy).Skip((pageIndex - 1) * pageSize).Take(pageSize)
                       : criteria.SatisfyingEntitiesFrom(_dbSet).OrderByDescending(orderBy).Skip((pageIndex - 1) * pageSize).Take(pageSize);
        }

        public int Count()
        {
            return _dbSet.Count();
        }

        public int Count(Expression<Func<TEntity, bool>> criteria)
        {
            return _dbSet.Count(criteria);
        }

        public int Count(ISpecification<TEntity> criteria)
        {
            return criteria.SatisfyingEntitiesFrom(_dbSet).Count();
        }

        public IRepository<T> GetRepository<T>() where T : BaseEntity
        {
            return _unitOfWork.Repository<T>();
        }

        private EntityKey GetEntityKey(object keyValue)
        {

            var entitySetName = GetEntityName(_dbContext);
            var objectSet = ((IObjectContextAdapter)_dbContext).ObjectContext.CreateObjectSet<TEntity>();
            var keyMember = objectSet.EntitySet.ElementType.KeyMembers[0].ToString();

            var keys = new Dictionary<string, object> { { keyMember, keyValue } };

            return new EntityKey(entitySetName, keys);
        }

        private string GetEntityName(IObjectContextAdapter context)
        {
            var entitySetName = context.ObjectContext
                .MetadataWorkspace
                .GetEntityContainer(context.ObjectContext.DefaultContainerName, DataSpace.CSpace)
                .BaseEntitySets.First(bes => bes.ElementType.Name == typeof(TEntity).Name).Name;
            return string.Format("{0}.{1}", context.ObjectContext.DefaultContainerName, entitySetName);
        }
    }
}