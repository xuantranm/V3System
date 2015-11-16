namespace Ap.Common.Security
{
    using System.Security.Cryptography;
    using System.Text;

    public static class UserCommon
    {
        public static string CreateHash(string value)
        {
            // Add for more security
            var valueS = value + "xuan.tm1988@gmail-0938.156368";
            var algorithm = SHA1.Create();

            // var algorithm = MD5.Create();
            var data = algorithm.ComputeHash(Encoding.UTF8.GetBytes(valueS));
            var sh1 = string.Empty;
            for (var i = 0; i < data.Length; i++)
            {
                sh1 += data[i].ToString("x2").ToUpperInvariant();
            }

            return sh1;
        }
    }
}
