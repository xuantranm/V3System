using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ap.Service.Seedworks;

namespace Vivablast.Controllers
{
    [Authorize]
    public class SettingController : Controller
    {
        //
        // GET: /Setting/

        private readonly ISystemService _systemService;

        public SettingController(ISystemService systemService)
        {
            _systemService = systemService;
        }

        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult UpdateHashPassword()
        {
            _systemService.UpdateHashPassword();
            return Json(new {result = true});
        }
    }
}
