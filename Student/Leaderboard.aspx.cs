using System;
using System.Collections.Generic;
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
                string studentID = Session["UserID"].ToString();
                List<string> levels = GetStudentLevels(studentID);

                if (levels.Count == 0)
                {
                    lblLevel.Text = "Not enrolled in a course yet";
                    lblLevel.Visible = true;
                    return;
                }

                if (levels.Count == 1)
                {
                    // Only one level - show it directly, no dropdown needed
                    divLevelSelect.Visible = false;

                    lblLevel.Text = levels[0];
                    lblLevel.Visible = true;

                    LoadLeaderboard(levels[0]);
                }
                else
                {
                    // More than one level - let the student pick which one to view
                    lblLevel.Visible = false;
                    divLevelSelect.Visible = true;

                    ddlLevelSelect.DataSource = levels;
                    ddlLevelSelect.DataBind();

                    LoadLeaderboard(ddlLevelSelect.SelectedValue);
                }
            }
        }

        // Finds EVERY level the student is enrolled in via progressTable -> courseTable
        private List<string> GetStudentLevels(string studentID)
        {
            List<string> levels = new List<string>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT DISTINCT c.level
                                  FROM progressTable p
                                  JOIN courseTable c ON p.courseID = c.courseID
                                  WHERE p.studentID = @studentID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@studentID", studentID);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            levels.Add(reader["level"].ToString());
                        }
                    }
                }
            }

            return levels;
        }

        // Loads ranked students who are enrolled in courses at this ONE selected level
        private void LoadLeaderboard(string level)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT l.rank, u.name, l.totalScore
                                  FROM leaderboardTable l
                                  JOIN userTable u ON l.studentID = u.UserID
                                  WHERE l.studentID IN (
                                      SELECT DISTINCT p.studentID
                                      FROM progressTable p
                                      JOIN courseTable c ON p.courseID = c.courseID
                                      WHERE c.level = @level
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

        // Runs when the student switches level in the dropdown
        protected void ddlLevelSelect_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLeaderboard(ddlLevelSelect.SelectedValue);
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