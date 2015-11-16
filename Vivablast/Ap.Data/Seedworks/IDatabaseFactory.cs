using System;
using System.Data.SqlClient;

namespace Ap.Data.Seedworks
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
