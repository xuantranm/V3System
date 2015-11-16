using System;
using System.Data.SqlClient;

namespace ApData.Seedworks
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
