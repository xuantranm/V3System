using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace ReadFolder
{
    class Program
    {
        public static string PathFile = @"D:/02_DEV/Project/Vivablast/Web/DBWebChange/FilePicture.csv";
        static void Main()
        {
            var d = new DirectoryInfo(@"D:/02_DEV/Project/Vivablast/Web/Vivablast/Vivablast/Pictures");//Assuming Test is your Folder
            var files = d.GetFiles("*.jpg"); //Getting Text files

            #region Get more type file
            //var files = Directory.EnumerateFiles("C:\\path", "*.*", SearchOption.AllDirectories)
            //.Where(s => s.EndsWith(".mp3") || s.EndsWith(".jpg"));
            #endregion

            var listDocument = files.Select(file => new Document
            {
                Code = file.Name.Split('.')[0], FileName = file.Name
            }).ToList();

            WriteCsv(listDocument);
            Console.WriteLine("Please find the result: " + PathFile);
            Console.WriteLine("DONE");
            Console.ReadLine();
        }

        static void WriteCsv(List<Document> listDocument)
        {
            //before your loop
            var csv = new StringBuilder();

            //in your loop
            foreach (var document in listDocument)
            {
                var first = document.Code;
                var second = document.FileName;
                var newLine = string.Format("{0}\t{1}{2}", first, second, Environment.NewLine);
                csv.Append(newLine);
            }
           
            //after your loop
            File.WriteAllText(PathFile, csv.ToString());
        }
    }
}
