using Ap.Common.Specifications.Extensions;
using System.Linq;

namespace Ap.Common.Specifications
{
    /// <summary>
    /// And specification
    /// </summary>
    /// <typeparam name="TEntity"></typeparam>
    public class AndSpecification<TEntity> : CompositeSpecification<TEntity>
    {
        public AndSpecification(Specification<TEntity> leftSide, Specification<TEntity> rightSide)
            : base(leftSide, rightSide)
        {
        }

        /// <summary>
        /// Satisfy entity
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        public override TEntity SatisfyingEntityFrom(IQueryable<TEntity> query)
        {
            return SatisfyingEntitiesFrom(query).FirstOrDefault();
        }

        /// <summary>
        /// Satisfy entities
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        public override IQueryable<TEntity> SatisfyingEntitiesFrom(IQueryable<TEntity> query)
        {
            return query.Where(LeftSide.Predicate.And(RightSide.Predicate));
        }
    }
}