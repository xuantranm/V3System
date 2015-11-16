using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExportScriptSQL
{
    class Program
    {
        static void Main(string[] args)
        {
            var addressList = new List<Address>();
            List<string> dataList = null;
            for (var i = 1; i <= 18; i++)
            {
                var sr = new StreamReader(@"D:/PROJECT/LongLat/result_" + i + ".csv");
                var content = sr.ReadToEnd();
                dataList = new List<string>(
                    content.Split(
                        new string[] { "\r\n" },
                        StringSplitOptions.RemoveEmptyEntries
                    )
                );
                foreach (var dataItem in dataList)
                {
                    var dataSplit = dataItem.Split('\t');
                    var addressItem = new Address
                    {
                        AddressId = Convert.ToInt32(dataSplit[0]),
                        Latitude = Convert.ToDecimal(dataSplit[1].Replace(',','.')),
                        Longitude = Convert.ToDecimal(dataSplit[2].Replace(',', '.'))
                    };
                    addressList.Add(addressItem);
                }
            }

            ExportFile(addressList);
            Console.WriteLine("DONE");
            Console.ReadLine();
        }

        static void ExportFile(List<Address> listResult)
        {
            var pathDesktop = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            var filePath = pathDesktop + "\\updatelonglat.csv";
            //string filePath = @"D:/02_DEV/Project/LongLat/result_" + code + ".csv";
            if (!File.Exists(filePath))
            {
                File.Create(filePath).Close();
            }

            int length = listResult.Count;

            using (TextWriter writer = File.CreateText(filePath))
            {
                for (int index = 0; index < length; index++)
                {
                    writer.WriteLine("UPDATE dbo.XBAddress SET latitude=" + listResult[index].Latitude + ", longitude=" + listResult[index].Longitude + " WHERE address_id=" + listResult[index].AddressId);
                }
            }
        }
    }
}
