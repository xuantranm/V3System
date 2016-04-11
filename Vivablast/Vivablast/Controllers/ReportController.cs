using Ap.Business.ViewModels;
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

        public ActionResult LoadDynamic(int page, int size, int poType, string po, int stockType, int category, string stockCode, string stockName)
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var model = _systemService.GetDynamicReport(page,size,poType,po,stockType,category,stockCode,stockName);
           return PartialView("Partials/_DynamicReport", model);
        }
    }
}
