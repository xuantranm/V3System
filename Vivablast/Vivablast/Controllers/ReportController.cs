using Ap.Service.Seedworks;
using System;
using System.Web.Mvc;
using log4net;
using Vivablast.ViewModels;

namespace Vivablast.Controllers
{
    public class ReportController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(PeController).FullName);

        private readonly ISystemService _systemService;
        public ReportController(ISystemService systemService)
        {
            _systemService = systemService;
        }

        //
        // GET: /Report/

        public ActionResult Dynamic()
        {
            return View();
        }

        public ActionResult LoadDynamic(int page, int size, string stockCode, string stockName, string store, int type, int category, string enable)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var totalRecord = _reportService.ListConditionCount(page, size, stockCode, stockName, store, type, category, enable);
            var totalTemp = Convert.ToDecimal(totalRecord) / Convert.ToDecimal(size);
            int totalPages = size == 1000 ? 1 : Convert.ToInt32(Math.Ceiling(totalTemp));

            var model = new StockViewModel
            {
                UserLogin = _systemService.GetUserAndRole(0, userName),
                StockVs = _reportService.ListCondition(page, size, stockCode, stockName, store, type, category, enable),
                StoreVs = _systemService.StoreList(),
                TotalRecords = Convert.ToInt32(totalRecord),
                TotalPages = totalPages,
                CurrentPage = page,
                PageSize = size
            };

            return PartialView("_StockPartial", model);
        }
    }
}
