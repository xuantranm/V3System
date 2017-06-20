using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ap.Business.Domains;

namespace Vivablast.Models
{
    public class StockModel
    {
        public WAMS_STOCK Entity { get; set; }
        public SelectList Stores;

        public SelectList Types;

        public SelectList Categories;

        public SelectList Units;

        public SelectList Positions;

        public SelectList Labels;
    }
}