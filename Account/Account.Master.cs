using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Account
{
    public partial class AccountMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Role"] != null)
                {
                    string role = Session["Role"].ToString();

                    switch (role)
                    {
                        case "Student":
                            lnkDashboard.NavigateUrl = "../Student/StudentDashboard.aspx";
                            break;

                        case "Language Instructor":
                            lnkDashboard.NavigateUrl = "../Instructor/InstructorDashboard.aspx";
                            break;

                        case "Admin":
                            lnkDashboard.NavigateUrl = "../Admin/AdminDashboard.aspx";
                            break;

                        default:
                            lnkDashboard.NavigateUrl = "../Home.aspx";
                            break;
                    }
                }
                else
                {
                    lnkDashboard.NavigateUrl = "../Home.aspx";
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("../Home.aspx");
        }
    }
}