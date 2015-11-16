using System.Linq;

namespace Ap.Common.Specifications
{
    /// <summary>
    /// Composite specifications
    /// </summary>
    /// <typeparam name="TEntity"></typeparam>
    public abstract class CompositeSpecification<TEntity> : ISpecification<TEntity>
    {
        protected readonly Specification<TEntity> LeftSide;
        protected readonly Specification<TEntity> RightSide;

        protected CompositeSpecification(Specification<TEntity> leftSide, Specification<TEntity> rightSide)
        {
            LeftSide = leftSide;
            RightSide = rightSide;
        }

        /// <summary>
        /// Satisfy entity
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        public abstract TEntity SatisfyingEntityFrom(IQueryable<TEntity> query);

        /// <summary>
        /// Satisfy entities
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        public abstract IQueryable<TEntity> SatisfyingEntitiesFrom(IQueryable<TEntity> query);
    }
}
