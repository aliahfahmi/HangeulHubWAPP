using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }
    }
}