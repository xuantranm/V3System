using System.IO;
using System.Net.Mail;
using System.Web.Configuration;
using Ap.Common.Constants;
using Ap.Common.Security;
using Vivablast.ViewModels;

namespace Vivablast.Controllers
{
    using System;
    using System.Web;
    using System.Web.Mvc;
    using System.Web.Security;
    using Ap.Service.Seedworks;
    using log4net;

    public class LoginController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(LoginController).FullName);

        private readonly ISystemService _systemService;
        private readonly IUserService _service;

        public LoginController(ISystemService systemService, IUserService service)
        {
            _systemService = systemService;
            _service = service;
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult CheckUser(string test1, string test2, bool test3)
        {
            try
            {
                var checkUser = _systemService.CheckUser(test1, test2);
                if (!checkUser)
                {
                    return Json(new { success = false });
                }

                FormsAuthentication.SetAuthCookie(test1, false);
                return Json(new { success = true });
            }
            catch (Exception e)
            {
                Log.Error("Check User!", e);
                return Json(new { success = false });
            }
        }

        public ActionResult SignOut()
        {
            Session.Clear();
            Session.Abandon();
            Response.Cache.SetExpires(DateTime.Now);
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetAllowResponseInBrowserHistory(false);
            Response.Cache.SetNoStore();
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", "Login");
        }

        public ActionResult ChangePassword()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = _systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            var model = new UserViewModel
            {
                UserLogin = user
            };
            return View(model);
        }

        [HttpPost]
        public ActionResult ChangePassword(int userCode, string newPassword, string currentPassword)
        {
            var user = _service.GetByKey(userCode);

            if (user.Password != UserCommon.CreateHash(currentPassword))
            {
                return Json(new { result = Constants.UnSuccess });
            }

            user.Password = UserCommon.CreateHash(newPassword);
            user.ModifiedBy = user.Id;
            user.Modified = DateTime.Now;
            _service.Update(user);
            return Json(new { result = Constants.Success });
        }

        public ActionResult CheckOldPassword(string user, string password)
        {
            return Json(new { result = _systemService.CheckUser(user, password) });
        }

        public ActionResult ForgotPassword()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ForgotPassword(string user, string email)
        {
            var userItem = _service.GetByName(user);

            if (userItem.Email != email.Trim())
            {
                return Json(new { result = Constants.UnSuccess });
            }

            var newPassword = userItem.Password + DateTime.Now.ToString("ddMMyyyyHHmmss");
            // 1. Add new password to this user
            userItem.Password = UserCommon.CreateHash(newPassword);
            userItem.ModifiedBy = userItem.Id;
            userItem.Modified = DateTime.Now;
            _service.Update(userItem);
            // 2. Send mail with new password.
            try
            {
                var mMess = new MailMessage
                {
                    From = new MailAddress(WebConfigurationManager.AppSettings["Email"])
                };
                mMess.To.Add(new MailAddress(email));
                mMess.Subject = "[IT] New Password On Vivablast WareHouse System.";
                mMess.IsBodyHtml = true;
                mMess.Body = GetHtmlContent(ControllerContext,
                    new ViewDataDictionary { { "Name", userItem.UserName }, { "Password", newPassword } },
                    "EmailTemplate");

                var smClt = new SmtpClient { EnableSsl = true };
                smClt.Send(mMess);

                return Json(new { result = Constants.Success });
            }
            catch (Exception ex)
            {
                return Json(new { result = ex });
            }
        }

        public ActionResult EmailTemplate()
        {
            return View();
        }

        // get HTML view as a content string
        public static string GetHtmlContent(ControllerContext controllerContext, ViewDataDictionary viewData, string viewName)
        {
            string content;
            var view = ViewEngines.Engines.FindView(controllerContext, viewName, null);
            using (var writer = new StringWriter())
            {
                var context = new ViewContext(controllerContext, view.View, viewData, controllerContext.Controller.TempData, writer);
                view.View.Render(context, writer);
                writer.Flush();
                content = writer.ToString();
            }
            return content;
        }
    }
}
