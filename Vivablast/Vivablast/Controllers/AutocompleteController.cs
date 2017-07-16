using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ap.Service.Seedworks;

namespace Vivablast.Controllers
{
    public class AutocompleteController : Controller
    {
        private readonly ISystemService _systemService;
        private readonly IStockService _stockService;

        public AutocompleteController(ISystemService systemService, IStockService stockService)
        {
            _systemService = systemService;
            _stockService = stockService;
        }

        public JsonResult LoadStockCodeByType(int type, int category)
        {
            var data = _stockService.NewStockCode(type, category);
            return Json(data);
        }

        public ActionResult ListStockCode(string term)
        {
            return Json(_stockService.ListCode(term), JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListStockName(string term)
        {
            return Json(_stockService.ListName(term), JsonRequestBehavior.AllowGet);
        }

        public JsonResult LoadCategoryByType(int type)
        {
            var objType = _systemService.CategoryStockList(type);
            var obgType = new SelectList(objType, "Id", "Name", 0);
            return Json(obgType);
        }

        public JsonResult LoadUnitByType(int type)
        {
            var objType = _systemService.UnitStockList(type);
            var obgType = new SelectList(objType, "Id", "Name", 0);
            return Json(obgType);
        }

        public JsonResult LoadLabelByType(int type)
        {
            var objType = _systemService.LabelStockList(type);
            var obgType = new SelectList(objType, "Id", "Name", 0);
            return Json(obgType);
        }
    }
}
