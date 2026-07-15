using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Student
{
    public partial class StudentDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["name"] != null)
            {
                name.Text = Session["name"].ToString() + "!";
            }
            else
            {
                Response.Redirect("../Home.aspx");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Request.Cookies.Clear();
            Response.Redirect("../Home.aspx");
        }
    }
}