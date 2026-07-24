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
                LoadInstructorActivity();
                LoadUserGrowth();
                LoadForumEngagement();
                LoadTestimonialBreakdown();
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

                string labelsJson, valuesJson;
                BuildJsonArrays(dt, "Title", "Attempts", out labelsJson, out valuesJson);
                hfChartLabels.Value = labelsJson;
                hfChartAttempts.Value = valuesJson;
            }
        }

        // Hand-rolled JSON array builder (no external JSON library referenced
        // in this project) - turns a DataTable column into a JS array string.
        // Used for every chart on this page.
        private void BuildJsonArrays(DataTable dt, string labelColumn, string valueColumn, out string labelsJson, out string valuesJson)
        {
            var labels = new System.Text.StringBuilder();
            var values = new System.Text.StringBuilder();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string label = dt.Rows[i][labelColumn].ToString().Replace("\"", "\\\"");
                string value = dt.Rows[i][valueColumn].ToString();

                if (i > 0)
                {
                    labels.Append(",");
                    values.Append(",");
                }

                labels.Append("\"").Append(label).Append("\"");
                values.Append(value);
            }

            labelsJson = "[" + labels.ToString() + "]";
            valuesJson = "[" + values.ToString() + "]";
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

        // Shows how much content each instructor (and any admin who has
        // posted announcements) has actually contributed to the platform.
        private void LoadInstructorActivity()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT u.name AS AuthorName, u.role AS Role,
                                         ISNULL(l.LessonCount, 0) AS LessonsPosted,
                                         ISNULL(q.QuizCount, 0) AS QuizzesPosted,
                                         ISNULL(a.AnnCount, 0) AS AnnouncementsPosted
                                  FROM userTable u
                                  LEFT JOIN (SELECT instructorID, COUNT(*) AS LessonCount FROM lessonTable GROUP BY instructorID) l
                                         ON l.instructorID = u.UserID
                                  LEFT JOIN (SELECT instructorID, COUNT(*) AS QuizCount FROM quizTable GROUP BY instructorID) q
                                         ON q.instructorID = u.UserID
                                  LEFT JOIN (SELECT instructorID, COUNT(*) AS AnnCount FROM announcementTable GROUP BY instructorID) a
                                         ON a.instructorID = u.UserID
                                  WHERE u.role = 'Language Instructor' OR ISNULL(a.AnnCount, 0) > 0
                                  ORDER BY (ISNULL(l.LessonCount, 0) + ISNULL(q.QuizCount, 0) + ISNULL(a.AnnCount, 0)) DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                GridViewInstructorActivity.DataSource = dt;
                GridViewInstructorActivity.DataBind();
            }
        }

        // Line chart data: how many users registered per month.
        private void LoadUserGrowth()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT FORMAT(regdate, 'yyyy-MM') AS RegMonth, COUNT(*) AS UserCount
                                  FROM userTable
                                  GROUP BY FORMAT(regdate, 'yyyy-MM')
                                  ORDER BY RegMonth";

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                string labelsJson, valuesJson;
                BuildJsonArrays(dt, "RegMonth", "UserCount", out labelsJson, out valuesJson);
                hfGrowthLabels.Value = labelsJson;
                hfGrowthCounts.Value = valuesJson;
            }
        }

        // Total forum questions, how many are answered vs still pending,
        // and the average time (in hours) it takes to get a response.
        private void LoadForumEngagement()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT
                    COUNT(*) AS TotalQuestions,
                    SUM(CASE WHEN responseText IS NOT NULL THEN 1 ELSE 0 END) AS AnsweredCount,
                    SUM(CASE WHEN responseText IS NULL THEN 1 ELSE 0 END) AS PendingCount,
                    (SELECT ISNULL(AVG(CAST(DATEDIFF(HOUR, questionDate, responseDate) AS FLOAT)), 0)
                     FROM forumTable WHERE responseDate IS NOT NULL) AS AvgResponseHours
                    FROM forumTable";

                conn.Open();
                SqlCommand cmd = new SqlCommand(query, conn);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        litForumTotal.Text = reader["TotalQuestions"].ToString();
                        litForumAnswered.Text = reader["AnsweredCount"] == DBNull.Value ? "0" : reader["AnsweredCount"].ToString();
                        litForumPending.Text = reader["PendingCount"] == DBNull.Value ? "0" : reader["PendingCount"].ToString();
                        litForumAvgResponse.Text = Convert.ToDouble(reader["AvgResponseHours"]).ToString("0.0") + "h";
                    }
                }
            }
        }

        // Doughnut chart data: how many testimonials are Pending/Approved/Rejected.
        private void LoadTestimonialBreakdown()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT appstat AS Status, COUNT(*) AS Cnt
                                  FROM testimonialTable
                                  GROUP BY appstat";

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                string labelsJson, valuesJson;
                BuildJsonArrays(dt, "Status", "Cnt", out labelsJson, out valuesJson);
                hfTestimonialLabels.Value = labelsJson;
                hfTestimonialCounts.Value = valuesJson;
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }
    }
}