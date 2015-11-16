using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using Vivablast.RepositorySeedworks;

namespace Vivablast.Repositories
{
    public abstract class BaseRepository
    {
        protected IDatabaseFactory DatabaseFactory { get; private set; }
        protected readonly DbContext DbContext;

        protected BaseRepository(IDatabaseFactory databaseFactory, IDbContext dbContext)
        {
            DatabaseFactory = databaseFactory;
            DbContext = dbContext as DbContext;
        }

        /// <summary>
        /// Gets SqlConnection and open a connection
        /// </summary>
        /// <returns></returns>
        protected SqlConnection GetSqlConnection()
        {
            var sql = DatabaseFactory.GetSqlConnection();
            if (sql.State != ConnectionState.Open) sql.Open();

            return sql;
        }
    }
}
