using Ap.Common.Constants;
using Ap.Service.Seedworks;
using Vivablast.ViewModels;

namespace Vivablast.Controllers
{
    using System;
    using System.Drawing;
    using System.IO;
    using System.Web.Mvc;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using log4net;

    [Authorize]
    public class AccountingController : Controller
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(AccountingController).FullName);

        private readonly ISystemService _systemService;
        private readonly IAccountingService _service;

        public AccountingController(ISystemService systemService, IAccountingService service)
        {
            _systemService = systemService;
            _service = service;
        }

        public ActionResult Index()
        {
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            var user = this._systemService.GetUserAndRole(0, userName);
            if (user == null) return RedirectToAction("Index", "Login");
            if (user.AccountingR == 0) return RedirectToAction("Index", "Home");
            var model = new AccountingViewModel
            {
                UserLogin = user,
                FromStores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                ToStores = new SelectList(_systemService.StoreList(), "Id", "Name"),
                Projects = new SelectList(_systemService.ProjectList(), "Id", "vProjectID"),
                Suppliers = new SelectList(this._systemService.SupplierList(), "Id", "Name"),
            };
            return View(model);
        }

        //public ActionResult LoadAccountingList(int page, int size, int typeAcc, int statusAcc, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td)
        //{
        //    var viewModel = this.repository.GetViewModelList(
        //        page, size, typeAcc, statusAcc, sirv, stock, beginStore, endStore, project, supplier, po, fd, td);
        //    var userName = System.Web.HttpContext.Current.User.Identity.Name;
        //    viewModel.UserLogin = this.repositoryUser.GetUserAndRole(userName);
        //    return PartialView("_AccountingPartial", viewModel);
        //}

        //public void ExportToExcel(int page, int size, int typeAcc, int statusAcc, string sirv, string stock, int beginStore, int endStore, int project, int supplier, string po, string fd, string td)
        //{
        //    try
        //    {
        //        var grid = new GridView
        //        {
        //            DataSource = repository.ExportData(page, size, typeAcc, statusAcc, sirv, stock, beginStore, endStore, project, supplier, po, fd, td)
        //        };

        //        grid.DataBind();

        //        Response.ClearContent();
        //        var fileName = "Accounting_" + DateTime.Now.ToString("ddMMyyyyHHmmss");
        //        Response.AddHeader("content-disposition", "attachment; filename=" + fileName + ".xls");
        //        Response.ContentType = "application/excel";
        //        var sw = new StringWriter();
        //        var htw = new HtmlTextWriter(sw);

        //        //Change the Header Row back to white color
        //        grid.HeaderRow.BackColor = Color.Red;
        //        grid.HeaderRow.ForeColor = Color.White;

        //        //Applying styles to Individual Cells of a row
        //        //gridViewExcel.HeaderRow.Cells[0].Style.Add("background-color", "black");
        //        //gridViewExcel.HeaderRow.Cells[1].Style.Add("background-color", "black");

        //        for (int i = 0; i < grid.Rows.Count; i++)
        //        {
        //            GridViewRow row = grid.Rows[i];

        //            //Change Color back to white and fore color to black
        //            row.BackColor = Color.White;
        //            row.ForeColor = Color.Black;

        //            //Apply text style to each row using styles class
        //            row.Attributes.Add("class", "classname");

        //            //Applying style to Alternating Row back to magenta and fore color to white
        //            if (i % 2 != 0)
        //            {
        //                row.BackColor = Color.PowderBlue;
        //                row.ForeColor = Color.Black;
        //            }
        //        }

        //        grid.RenderControl(htw);

        //        Response.Write(sw.ToString());

        //        Response.End();
        //    }
        //    catch (Exception ex)
        //    {
        //    }
        //}
        
        //[HttpPost]
        //public ActionResult Save(AccountingViewModelBuilder viewModel)
        //{
        //    foreach (var detail in viewModel.ListAccountingUpdate)
        //    {
        //         switch (detail.Status)
        //         {
        //             case "OUT":
        //                 this.repository.UpdateOut(detail);
        //                 break;
        //             case "IN":
        //                 this.repository.UpdateIn(detail);
        //                 break;
        //             default:
        //                 this.repository.UpdateReturn(detail);
        //                 break;
        //         }
        //    }

        //    return Json(new { result = Constants.Success });
        //}
    }
}