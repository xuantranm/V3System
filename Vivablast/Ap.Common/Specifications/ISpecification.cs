using System.Linq;

namespace Ap.Common.Specifications
{
    /// <summary>
    /// Specification contract
    /// </summary>
    /// <typeparam name="TEntity"></typeparam>
    public interface ISpecification<TEntity>
    {
        /// <summary>
        /// Satisfy entity
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        TEntity SatisfyingEntityFrom(IQueryable<TEntity> query);

        /// <summary>
        /// Satisfy entities
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        IQueryable<TEntity> SatisfyingEntitiesFrom(IQueryable<TEntity> query);
    }
}