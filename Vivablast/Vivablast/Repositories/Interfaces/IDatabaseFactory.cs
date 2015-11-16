using System;
using System.Data.SqlClient;

namespace Vivablast.Repositories.Interfaces
{
    public interface IDatabaseFactory : IDisposable
    {
        /// <summary>
        /// Get sql connection instance
        /// </summary>
        /// <returns></returns>
        SqlConnection GetSqlConnection();
    }
}
