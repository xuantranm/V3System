namespace Ap.Common.Constants
{
    using System;
    using System.Globalization;
    using System.Text;

    public static class Constants
    {
        public static readonly string MyCultureInfo = "en-CA";
        public static readonly string Success = "Successful";
        public static readonly string UnSuccess = "Save unsuccessful. Contact IT Support.";
        public static readonly string NoData = "No data. Please search again or add more data.";
        public static readonly string NoDataHistory = "No data history for this item.";
        public static readonly string EmptyData = "No data.";
        public static readonly string DisplayResult = " result(s) found.";
        public static readonly string Rows = "Rows";
        public static readonly string Duplicate = "Data duplicated";
        public static readonly string DuplicateCode = "Code duplicated";
        public static readonly string DuplicateEmail = "Email duplicated";
        public static readonly string UnDelete = "UnDelete";
        public static readonly string Empty = " can't empty.";
        public static readonly string DataJustChanged = "DataJustChanged";
        
        public static string Truncate(this string value, int maxChars)
        {
            if (!string.IsNullOrEmpty(value))
            {
                return value.Length <= maxChars ? value : value.Substring(0, maxChars) + " ..";
            }

            return string.Empty;
        }

        //public static readonly string FromDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1).ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
        //public static readonly string ToDate = DateTime.Now.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
        public static readonly string FromDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1).ToString("dd/MM/yyyy");
        public static readonly string ToDate = DateTime.Now.ToString("dd/MM/yyy");
        public static readonly string FormatDateSQL = "dd.MM.yyyy";
        public static string Action(int? right)
        {
            switch (right)
            {
                case 1:
                    return "Read";
                case 2:
                    return "Add";
                case 3:
                    return "Edit";
                case 4:
                    return "Delete";
                default:
                    return "None";
            }
        }

        public static string Accounting(int? right)
        {
            switch (right)
            {
                case 1:
                    return "Read";
                case 2:
                    return "Check";
                default:
                    return "None";
            }
        }

        public static string Checked(int? check)
        {
            return check == 1 ? "checked" : string.Empty;
        }

        public static string AccChecked(int? check)
        {
            switch (check)
            {
                case 1:
                    return string.Empty;
                case 2:
                    return "checked";
                case 3:
                    return "checked";
            }

            return string.Empty;
        }

        public static bool CheckFor(int check)
        {
            return check != 0;
        }

        public static readonly string SelectDDL = "Select";
        public static readonly string AllDLL = "All";
        public static readonly string LineDLL = "---";
        public static string ConvertDate(string date)
        {
            if (!string.IsNullOrEmpty(date))
            {
                DateTime postingDate = Convert.ToDateTime(date);
                return string.Format("{0:dd/MM/yyyy}", postingDate);
            }

            return string.Empty;
        }

        // public static string FormatDecimal(string condition)
        // {
        //    return !string.IsNullOrEmpty(condition) ? condition.Replace(".00", string.Empty) : null;
        // }

        public static string ToStringNoTruncation(this Decimal n, IFormatProvider format)
        {
            NumberFormatInfo nfi = NumberFormatInfo.GetInstance(format);
            string[] numberNegativePatterns = {
                    "(#,0.############################)", //0:  (n)
                    "-#,0.############################",  //1:  -n
                    "- #,0.############################", //2:  - n
                    "#,0.############################-",  //3:  n-
                    "#,0.############################ -"};//4:  n -
            var pattern = "#,0.############################;" + numberNegativePatterns[nfi.NumberNegativePattern];
            return n.ToString(pattern, format);
        }

        public static string ToStringNoTruncation(this Decimal n)
        {
            return n.ToStringNoTruncation(CultureInfo.CurrentCulture);
        }

        public static string RemoveSpecialCharacters(string str)
        {
            var sb = new StringBuilder();
            foreach (char c in str)
            {
                if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '.' || c == '_')
                {
                    sb.Append(c);
                }
            }

            return sb.ToString();
        }

        public static string GetMonthName(int month)
        {
            switch (month)
            {
                case 1:
                    return "JAN";
                case 2:
                    return "FEB";
                case 3:
                    return "MAR";
                case 4:
                    return "APR";
                case 5:
                    return "MAY";
                case 6:
                    return "JUN";
                case 7:
                    return "JUL";
                case 8:
                    return "AUG";
                case 9:
                    return "SEP";
                case 10:
                    return "OCT";
                case 11:
                    return "NOV";
                default:
                    return "DEC";
            }
        }

        public static long BigFileSize = 20971520; // 20 MB

        public static string ErrorFileTooBig = "The file is too big.";

        public static string ErrorFileSize_Less = "Less than 0.5mb";

        public static string NA = "N/A";

        public static string None = "None";
        public static string Read = "Read";
        public static string Add = "Add";
        public static string Edit = "Edit";
        public static string Delete = "Delete";
        public static string StatusOpen = "Open";
        public static string StatusComplete = "Complete";

        #region LookUp
        public static string LuVat = "vat";
        public static string LuRight = "right";
        public static string LuDepartment = "department";
        public static string LuPriceStatus = "pricestatus";
        public static string LuProjectStatus = "projectstatus";


        public static string LookUpType = "LookUpType";
        public static string LookUpKey = "LookUpKey";
        public static string LookUpValue = "LookUpValue";

        #endregion
    }
}
