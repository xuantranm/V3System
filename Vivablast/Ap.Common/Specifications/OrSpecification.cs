using System.Linq;
using Ap.Common.Specifications.Extensions;

namespace Ap.Common.Specifications
{
    /// <summary>
    /// Or specification
    /// </summary>
    /// <typeparam name="TEntity"></typeparam>
    public class OrSpecification<TEntity> : CompositeSpecification<TEntity>
    {
        public OrSpecification(Specification<TEntity> leftSide, Specification<TEntity> rightSide)
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
            return query.Where(LeftSide.Predicate.Or(RightSide.Predicate));
        }
    }
}