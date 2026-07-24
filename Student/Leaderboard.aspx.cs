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

        // Computes total score AND rank live, scoped to ONE level, purely via JOIN across
        // quizAttemptTable -> quizTable -> userTable. Does not read from leaderboardTable at all,
        // so a student's score in one level can never leak into another level's ranking.
        private void LoadLeaderboard(string level)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT 
                                      RANK() OVER (ORDER BY SUM(BestScores.bestScore) DESC) AS rank,
                                      u.name,
                                      SUM(BestScores.bestScore) AS totalScore
                                  FROM userTable u
                                  JOIN (
                                      SELECT qa.studentID, qa.quizID, MAX(qa.score) AS bestScore
                                      FROM quizAttemptTable qa
                                      JOIN quizTable q ON qa.quizID = q.quizID
                                      WHERE q.diffLevel = @level
                                      GROUP BY qa.studentID, qa.quizID
                                  ) AS BestScores ON u.UserID = BestScores.studentID
                                  GROUP BY u.UserID, u.name
                                  ORDER BY totalScore DESC";

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