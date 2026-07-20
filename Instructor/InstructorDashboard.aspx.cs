using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace HangeulHubWAPP.Instructor
{
    public partial class InstructorDashboard : System.Web.UI.Page
    {
        string connectionString =
            ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblInstructorName.Text = Session["Name"] != null
                    ? Session["Name"].ToString()
                    : "Instructor";

                LoadDashboardData();
                LoadRecentQuestions();
            }
        }

        private void LoadDashboardData()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                lblTotalLessons.Text = GetCount(
                    "SELECT COUNT(*) FROM lessonTable", con).ToString();

                lblOpenQuestions.Text = GetCount(
                    "SELECT COUNT(*) FROM forumTable WHERE stat = 'Open'", con).ToString();

                lblBeginner.Text = GetCount(
                    "SELECT COUNT(*) FROM lessonTable WHERE courseID = 'C001'", con).ToString();

                lblIntermediateAdvanced.Text = GetCount(
                    "SELECT COUNT(*) FROM lessonTable WHERE courseID IN ('C002', 'C003')", con).ToString();
            }
        }

        private int GetCount(string query, SqlConnection con)
        {
            SqlCommand cmd = new SqlCommand(query, con);
            return Convert.ToInt32(cmd.ExecuteScalar());
        }

        private void LoadRecentQuestions()
        {
            string query = @"SELECT TOP 5
                            questionText AS Question,
                            questionDate AS Date,
                            stat AS Status
                            FROM forumTable
                            ORDER BY questionDate DESC";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvRecentQuestions.DataSource = dt;
                gvRecentQuestions.DataBind();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}