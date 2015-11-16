using Ap.Data.Entities;
using System;
using System.Data;
using System.Data.Entity;

namespace Ap.Data.Seedworks
{
    public interface IUnitOfWork : IDisposable
    {
        DbContext DbContext { get; }

        /// <summary>
        /// Begins the transaction. An ApplicationException will be throwed if there is an existing transaction is still running
        /// </summary>
        /// <param name="level">The IsolationLevel level.</param>
        /// <returns></returns>
        void BeginTransaction(IsolationLevel level = IsolationLevel.Unspecified);

        /// <summary>
        /// Commits the changes
        /// </summary>
        void CommitChanges();

        /// <summary>
        /// Commits the transaction. An ApplicationException will be throwed if the current transaction can be committed
        /// </summary>
        void Commit();

        /// <summary>
        /// Rollbacks the transaction. An ApplicationException will be throwed if there is no transaction running
        /// </summary>
        void Rollback();

        /// <summary>
        /// Gets an instance of repository of TEntity
        /// </summary>
        /// <typeparam name="TEntity"></typeparam>
        /// <returns></returns>
        IRepository<TEntity> Repository<TEntity>() where TEntity : BaseEntity;
    }
}