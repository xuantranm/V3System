using Ap.Data.Entities;
using Ap.Data.Seedworks;
using System;
using System.Data;
using System.Data.Common;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Data.Entity.Infrastructure;
using System.Linq;

namespace Ap.Data.Repositories
{
    public sealed class UnitOfWork : IUnitOfWork
    {
        private readonly DbContext _context;

        private ObjectContext _objectContext;

        private DbTransaction _transaction;

        private bool _disposed;

        public UnitOfWork(IDbContext dbContext)
        {
            _context = dbContext as DbContext;
        }

        public bool IsInTransaction
        {
            get { return _transaction != null; }
        }

        public DbContext DbContext { get { return _context; } }

        public void BeginTransaction(IsolationLevel isolationLevel = IsolationLevel.Unspecified)
        {
            if (_transaction != null)
            {
                throw new ApplicationException("Cannot begin a new transaction while an existing transaction is still running. " +
                                                "Please commit or rollback the existing transaction before starting a new one.");
            }

            _objectContext = ((IObjectContextAdapter)_context).ObjectContext;
            if (_objectContext.Connection.State != ConnectionState.Open)
            {
                _objectContext.Connection.Open();
            }

            _transaction = _objectContext.Connection.BeginTransaction(isolationLevel);
        }

        public void Commit()
        {
            if (_transaction == null)
            {
                throw new ApplicationException("Cannot roll back a transaction while there is no transaction running.");
            }

            try
            {
                _transaction.Commit();
            }
            catch
            {
                Rollback();
                throw;
            }
        }

        public void CommitChanges()
        {
            var modifiedEntries = _context.ChangeTracker.Entries()
                .Where(x => x.Entity is ILastUpdateEntity
                            && (x.State == EntityState.Added || x.State == EntityState.Modified));

            foreach (var entry in modifiedEntries)
            {
                var entity = entry.Entity as ILastUpdateEntity;
                if (entity != null)
                {
                    entity.LastUpdate = DateTime.Now;
                }
            }

            ((IObjectContextAdapter)_context).ObjectContext.SaveChanges();
        }

        public void Rollback()
        {
            if (_transaction == null)
            {
                throw new ApplicationException("Cannot roll back a transaction while there is no transaction running.");
            }

            if (!IsInTransaction) return;

            _transaction.Rollback();
            ReleaseCurrentTransaction();
        }

        public IRepository<TEntity> Repository<TEntity>() where TEntity : BaseEntity
        {
            return new Repository<TEntity>(_context as IDbContext);
        }

        /// <summary>
        /// Releases the current transaction
        /// </summary>
        private void ReleaseCurrentTransaction()
        {
            if (_transaction == null) return;

            _transaction.Dispose();
            _transaction = null;
        }

        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Disposes off the managed and unmanaged resources used.
        /// </summary>
        /// <param name="disposing"></param>
        private void Dispose(bool disposing)
        {
            if (!disposing)
                return;

            if (_disposed)
                return;

            _disposed = true;
        }
    }
}
