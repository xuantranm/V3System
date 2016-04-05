using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ap.Service.Seedworks;
using log4net;

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
    }
}
