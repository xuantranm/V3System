using Ap.Common.Specifications.Extensions;
using System;
using System.Linq;
using System.Linq.Expressions;

namespace Ap.Common.Specifications
{
    /// <summary>
    /// Specification class which encapsulates piece(s) of logic
    /// </summary>
    /// <typeparam name="TEntity"></typeparam>
    public class Specification<TEntity> : ISpecification<TEntity>
    {
        public Specification(Expression<Func<TEntity, bool>> predicate)
        {
            Predicate = predicate;
        }

        /// <summary>
        /// And specifications
        /// </summary>
        /// <param name="specification"></param>
        /// <returns></returns>
        public Specification<TEntity> And(Specification<TEntity> specification)
        {
            return new Specification<TEntity>(this.Predicate.And(specification.Predicate));
        }

        /// <summary>
        /// And specifications
        /// </summary>
        /// <param name="predicate"></param>
        /// <returns></returns>
        public Specification<TEntity> And(Expression<Func<TEntity, bool>> predicate)
        {
            return new Specification<TEntity>(this.Predicate.And(predicate));
        }

        /// <summary>
        /// Or specifications
        /// </summary>
        /// <param name="specification"></param>
        /// <returns></returns>
        public Specification<TEntity> Or(Specification<TEntity> specification)
        {
            return new Specification<TEntity>(this.Predicate.Or(specification.Predicate));
        }

        /// <summary>
        /// Or specifications
        /// </summary>
        /// <param name="predicate"></param>
        /// <returns></returns>
        public Specification<TEntity> Or(Expression<Func<TEntity, bool>> predicate)
        {
            return new Specification<TEntity>(this.Predicate.Or(predicate));
        }

        /// <summary>
        /// Satisfy entity
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        public TEntity SatisfyingEntityFrom(IQueryable<TEntity> query)
        {
            return query.Where(Predicate).SingleOrDefault();
        }

        /// <summary>
        /// Satisfy entities
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        public IQueryable<TEntity> SatisfyingEntitiesFrom(IQueryable<TEntity> query)
        {
            return query.Where(Predicate);
        }

        public Expression<Func<TEntity, bool>> Predicate;
    }
}
