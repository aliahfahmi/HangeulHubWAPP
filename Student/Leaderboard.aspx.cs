using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace HangeulHubWAPP.Student
{
    public partial class Leaderboard : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLeaderboard(ddlLevelFilter.SelectedValue);
            }
        }

        // Loads ranked students who have attempted at least one quiz of the chosen level
        private void LoadLeaderboard(string level)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT l.rank, u.name, l.totalScore
                                  FROM leaderboardTable l
                                  JOIN userTable u ON l.studentID = u.UserID
                                  WHERE l.studentID IN (
                                      SELECT DISTINCT qa.studentID
                                      FROM quizAttemptTable qa
                                      JOIN quizTable q ON qa.quizID = q.quizID
                                      WHERE q.diffLevel = @level
                                  )
                                  ORDER BY l.rank ASC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@level", level);

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridViewLeaderboard.DataSource = dt;
                GridViewLeaderboard.DataBind();
            }
        }

        protected void ddlLevelFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLeaderboard(ddlLevelFilter.SelectedValue);
        }

        protected void GridViewLeaderboard_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Student/StudentDashboard.aspx");
        }
    }
}