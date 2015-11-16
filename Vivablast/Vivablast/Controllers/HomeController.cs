using Ap.Service.Seedworks;
using Vivablast.ViewModels;

namespace Vivablast.Controllers
{
    using System.Web.Mvc;

    using log4net;

    [Authorize]
    public class HomeController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(HomeController).FullName);

        private readonly ISystemService _systemService;

        public HomeController(ISystemService systemService)
        {
            _systemService = systemService;
        }
        
        public ActionResult LoadMenu()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            var model = new HomeViewModel { UserLogin = user };
            return PartialView("MenuPartial", model);
        }

        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            var model = new HomeViewModel { UserLogin = user };
            return View(model);
        }
    }
}
