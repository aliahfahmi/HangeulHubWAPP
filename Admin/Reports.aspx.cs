using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace HangeulHubWAPP.Admin
{
    public partial class Reports : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

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

            if (!IsPostBack)
            {
                LoadStats();
                LoadQuizPerformance();
                LoadTopStudents();
            }
        }

        private void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT
                    (SELECT COUNT(*) FROM userTable) AS TotalUsers,
                    (SELECT COUNT(*) FROM userTable WHERE stat = 'ACTIVE') AS ActiveUsers,
                    (SELECT COUNT(*) FROM userTable WHERE role = 'Student') AS TotalStudents,
                    (SELECT COUNT(*) FROM userTable WHERE role = 'Language Instructor') AS TotalInstructors,
                    (SELECT COUNT(*) FROM courseTable) AS TotalCourses,
                    (SELECT COUNT(*) FROM quizTable) AS TotalQuizzes,
                    (SELECT COUNT(*) FROM quizAttemptTable) AS TotalAttempts,
                    (SELECT ISNULL(AVG(CAST(score AS FLOAT)), 0) FROM quizAttemptTable) AS AvgScore,
                    (SELECT COUNT(*) FROM testimonialTable WHERE appstat = 'PENDING') AS PendingTestimonials,
                    (SELECT COUNT(*) FROM forumTable WHERE responseText IS NULL) AS PendingForum";

                conn.Open();
                SqlCommand cmd = new SqlCommand(query, conn);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        litTotalUsers.Text = reader["TotalUsers"].ToString();
                        litActiveUsers.Text = reader["ActiveUsers"].ToString();
                        litStudents.Text = reader["TotalStudents"].ToString();
                        litInstructors.Text = reader["TotalInstructors"].ToString();
                        litTotalCourses.Text = reader["TotalCourses"].ToString();
                        litTotalQuizzes.Text = reader["TotalQuizzes"].ToString();
                        litTotalAttempts.Text = reader["TotalAttempts"].ToString();
                        litAvgScore.Text = Convert.ToDouble(reader["AvgScore"]).ToString("0.0");
                        litPendingTestimonials.Text = reader["PendingTestimonials"].ToString();
                        litPendingForum.Text = reader["PendingForum"].ToString();
                    }
                }
            }
        }

        private void LoadQuizPerformance()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT q.quizID AS QuizID, q.title AS Title, c.title AS CourseTitle,
                                         COUNT(qa.attemptID) AS Attempts,
                                         ISNULL(AVG(CAST(qa.score AS FLOAT)), 0) AS AvgScore,
                                         q.passingScore AS PassingScore,
                                         CASE WHEN COUNT(qa.attemptID) = 0 THEN 0
                                              ELSE CAST(SUM(CASE WHEN qa.score >= q.passingScore THEN 1 ELSE 0 END) AS FLOAT)
                                                   / COUNT(qa.attemptID) * 100
                                         END AS PassRate
                                  FROM quizTable q
                                  JOIN courseTable c ON q.courseID = c.courseID
                                  LEFT JOIN quizAttemptTable qa ON qa.quizID = q.quizID
                                  GROUP BY q.quizID, q.title, c.title, q.passingScore
                                  ORDER BY Attempts DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                GridViewQuizPerformance.DataSource = dt;
                GridViewQuizPerformance.DataBind();

                BuildChartData(dt);
            }
        }

        // Builds a small hand-rolled JSON payload (no external JSON library
        // referenced in this project) for the quiz attempts bar chart.
        private void BuildChartData(DataTable dt)
        {
            var labels = new System.Text.StringBuilder();
            var attempts = new System.Text.StringBuilder();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string title = dt.Rows[i]["Title"].ToString().Replace("\"", "\\\"");
                string attemptCount = dt.Rows[i]["Attempts"].ToString();

                if (i > 0)
                {
                    labels.Append(",");
                    attempts.Append(",");
                }

                labels.Append("\"").Append(title).Append("\"");
                attempts.Append(attemptCount);
            }

            hfChartLabels.Value = "[" + labels.ToString() + "]";
            hfChartAttempts.Value = "[" + attempts.ToString() + "]";
        }

        private void LoadTopStudents()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT TOP 10 l.[rank] AS Rank, u.name AS StudentName, l.totalScore AS TotalScore
                                  FROM leaderboardTable l
                                  JOIN userTable u ON l.studentID = u.UserID
                                  ORDER BY l.[rank] ASC";

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                GridViewTopStudents.DataSource = dt;
                GridViewTopStudents.DataBind();
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }
    }
}