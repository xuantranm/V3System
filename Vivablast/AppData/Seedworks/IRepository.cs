using Ap.Common.Specifications;
using Ap.Data.Entities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;

namespace ApData.Seedworks
{
    public interface IRepository<TEntity> where TEntity : IBaseEntity
    {
        /// <summary>
        /// Gets entity by key
        /// </summary>
        /// <param name="keyValue"></param>
        /// <returns></returns>
        TEntity GetByKey(object keyValue);

        /// <summary>
        /// Gets entity by a set of keys
        /// </summary>
        /// <param name="keyValues"></param>
        /// <returns></returns>
        TEntity GetByKey(Dictionary<string, object> keyValues);

        /// <summary>
        /// Queries entities by expression
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        IQueryable<TEntity> GetQuery(Expression<Func<TEntity, bool>> criteria);

        /// <summary>
        /// Queries entities by specification
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        IQueryable<TEntity> GetQuery(ISpecification<TEntity> criteria);

        /// <summary>
        /// Returns the only entity of a sequence, or a default value if the sequence is empty; this method throws an exception if there is more than one entity in the sequence.
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        TEntity Single(Expression<Func<TEntity, bool>> criteria);

        /// <summary>
        /// Returns the only entity of a sequence, or a default value if the sequence is empty; this method throws an exception if there is more than one entity in the sequence.
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        TEntity Single(ISpecification<TEntity> criteria);

        /// <summary>
        /// Gets the first entity by expression
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        TEntity First(Expression<Func<TEntity, bool>> criteria);

        /// <summary>
        /// Gets the first entity using specification
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        TEntity First(ISpecification<TEntity> criteria);

        /// <summary>
        /// Adds entity
        /// </summary>
        /// <param name="entity"></param>
        void Add(TEntity entity);

        /// <summary>
        /// Adds entities
        /// </summary>
        /// <param name="entities"></param>
        void AddRange(IEnumerable<TEntity> entities);

        /// <summary>
        /// Deletes entity by key
        /// </summary>
        /// <param name="id"></param>
        void Delete(object id);

        /// <summary>
        /// Deletes entity
        /// </summary>
        /// <param name="entity"></param>
        void Delete(TEntity entity);

        /// <summary>
        /// Deletes entities by expression
        /// </summary>
        /// <param name="criteria"></param>
        void Delete(Expression<Func<TEntity, bool>> criteria);

        /// <summary>
        /// Deletes entities by specification
        /// </summary>
        /// <param name="criteria"></param>
        void Delete(ISpecification<TEntity> criteria);

        /// <summary>
        /// Updates entity
        /// </summary>
        /// <param name="entity"></param>
        void Update(TEntity entity);

        /// <summary>
        /// Updates entity by expression
        /// </summary>
        /// <param name="entity"></param>
        /// <param name="criteria"></param>
        void Update(TEntity entity, Expression<Func<TEntity, bool>> criteria);

        /// <summary>
        /// Finds entities by expression
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        IQueryable<TEntity> Find(Expression<Func<TEntity, bool>> criteria);

        /// <summary>
        /// Finds entities by specification
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        IQueryable<TEntity> Find(ISpecification<TEntity> criteria);

        /// <summary>
        /// Finds the first entity of a sequence that satisfies a specified condition or a default value if no such entity is found using expression
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        TEntity FindOne(Expression<Func<TEntity, bool>> criteria);

        /// <summary>
        /// Finds the first entity of a sequence that satisfies a specified condition or a default value if no such entity is found using specification
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        TEntity FindOne(ISpecification<TEntity> criteria);

        /// <summary>
        /// Gets all entities
        /// </summary>
        /// <returns></returns>
        IQueryable<TEntity> GetAll();

        /// <summary>
        /// Queries with paging using expression
        /// </summary>
        /// <typeparam name="TOrderBy"></typeparam>
        /// <param name="orderBy"></param>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="sortOrder"></param>
        /// <returns></returns>
        IQueryable<TEntity> Get<TOrderBy>(Expression<Func<TEntity, TOrderBy>> orderBy, int pageIndex, int pageSize, SortOrder sortOrder = SortOrder.Ascending);

        /// <summary>
        /// Queries with paging using expression
        /// </summary>
        /// <typeparam name="TOrderBy"></typeparam>
        /// <param name="criteria"></param>
        /// <param name="orderBy"></param>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="sortOrder"></param>
        /// <returns></returns>
        IQueryable<TEntity> Get<TOrderBy>(Expression<Func<TEntity, bool>> criteria, Expression<Func<TEntity, TOrderBy>> orderBy, int pageIndex, int pageSize, SortOrder sortOrder = SortOrder.Ascending);

        /// <summary>
        /// Queries with paging using specification
        /// </summary>
        /// <typeparam name="TOrderBy"></typeparam>
        /// <param name="criteria"></param>
        /// <param name="orderBy"></param>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="sortOrder"></param>
        /// <returns></returns>
        IQueryable<TEntity> Get<TOrderBy>(ISpecification<TEntity> criteria, Expression<Func<TEntity, TOrderBy>> orderBy, int pageIndex, int pageSize, SortOrder sortOrder = SortOrder.Ascending);

        /// <summary>
        /// Counts entities
        /// </summary>
        /// <returns></returns>
        int Count();

        /// <summary>
        /// Counts entities by expression
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        int Count(Expression<Func<TEntity, bool>> criteria);

        /// <summary>
        /// Counts entities by specification
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        int Count(ISpecification<TEntity> criteria);

        /// <summary>
        /// Gets an instance of repository of TEntity
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        IRepository<T> GetRepository<T>() where T : BaseEntity;
    }
}