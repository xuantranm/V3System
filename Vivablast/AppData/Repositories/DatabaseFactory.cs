using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using ApData.Seedworks;

namespace ApData.Repositories
{
    public class DatabaseFactory : IDatabaseFactory
    {
        private SqlConnection _sqlConnection;
        private const string ConnectionString = "ap";

        public SqlConnection GetSqlConnection()
        {
            if (_sqlConnection != null && !string.IsNullOrWhiteSpace(_sqlConnection.ConnectionString)) return _sqlConnection;

            _sqlConnection = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString);
            return _sqlConnection;
        }

        /// <summary>
        /// Disposes sql connection
        /// </summary>
        public void Dispose()
        {
            if (_sqlConnection != null && _sqlConnection.State != ConnectionState.Closed)
            {
                _sqlConnection.Close();
                _sqlConnection.Dispose();
            }
        }
    }
}
