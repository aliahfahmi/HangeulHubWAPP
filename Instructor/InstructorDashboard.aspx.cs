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
            if (Session["UserID"] == null || Session["Role"] == null ||
                Session["Role"].ToString() != "Language Instructor")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

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
            string instructorID = Session["UserID"].ToString();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                lblTotalLessons.Text = GetCount(
                    "SELECT COUNT(*) FROM lessonTable WHERE instructorID = @instructorID",
                    con, instructorID).ToString();

                lblOpenQuestions.Text = GetCount(
                    "SELECT COUNT(*) FROM forumTable WHERE stat = 'Open' AND lecturerID = @instructorID",
                    con, instructorID).ToString();

                lblBeginner.Text = GetCount(
                    "SELECT COUNT(*) FROM lessonTable WHERE courseID = 'C001' AND instructorID = @instructorID",
                    con, instructorID).ToString();

                lblIntermediateAdvanced.Text = GetCount(
                    "SELECT COUNT(*) FROM lessonTable WHERE courseID IN ('C002', 'C003') AND instructorID = @instructorID",
                    con, instructorID).ToString();
            }

            // Hani's message reacts to the same open-question count shown in lblOpenQuestions -
            // set after the block above so lblOpenQuestions.Text is already populated.
            int openCount = 0;
            int.TryParse(lblOpenQuestions.Text, out openCount);

            if (openCount == 0)
                litHaniMessage.Text = "🐰 Hani says: “All caught up! Great work!”";
            else if (openCount <= 3)
                litHaniMessage.Text = $"🐰 Hani says: “You have {openCount} student(s) waiting for help.”";
            else
                litHaniMessage.Text = "🐰 Hani says: “Your students need you today!”";
        }

        private int GetCount(string query, SqlConnection con, string instructorID)
        {
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@instructorID", instructorID);
            return Convert.ToInt32(cmd.ExecuteScalar());
        }

        private void LoadRecentQuestions()
        {
  
            string query = @"SELECT TOP 5
                            questionText AS Question,
                            questionDate AS Date,
                            stat AS Status
                            FROM forumTable
                            WHERE lecturerID = @instructorID
                            ORDER BY questionDate DESC";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());

                SqlDataAdapter da = new SqlDataAdapter(cmd);
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