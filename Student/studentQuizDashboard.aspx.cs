using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace HangeulHubWAPP.Student
{
    public partial class StudentQuizDashboard : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        private const int MAX_ATTEMPTS = 3;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadQuizzes();
            }
        }

        // Finds EVERY level the student is enrolled in via progressTable -> courseTable
        // (a student can be enrolled in more than one course/level at once)
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

        private void LoadQuizzes()
        {
            string studentID = Session["UserID"].ToString();
            List<string> levels = GetStudentLevels(studentID);

            if (levels.Count == 0)
            {
                // Not enrolled in any course - nothing to show
                rptQuizzes.DataSource = null;
                rptQuizzes.DataBind();
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Build a dynamic list of parameters (@level0, @level1, ...) for the IN clause
                List<string> paramNames = new List<string>();
                for (int i = 0; i < levels.Count; i++)
                {
                    paramNames.Add("@level" + i);
                }
                string inClause = string.Join(",", paramNames);

                string query = $@"SELECT q.quizID, q.title, q.diffLevel, q.timelimit, q.passingScore,
                                          ISNULL(a.attemptsUsed, 0) AS attemptsUsed,
                                          a.bestScore AS bestScore
                                   FROM quizTable q
                                   LEFT JOIN (
                                       SELECT quizID, COUNT(*) AS attemptsUsed, MAX(score) AS bestScore
                                       FROM quizAttemptTable
                                       WHERE studentID = @studentID
                                       GROUP BY quizID
                                   ) a ON q.quizID = a.quizID
                                   WHERE q.diffLevel IN ({inClause})
                                   ORDER BY q.diffLevel, q.title";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@studentID", studentID);

                for (int i = 0; i < levels.Count; i++)
                {
                    cmd.Parameters.AddWithValue("@level" + i, levels[i]);
                }

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptQuizzes.DataSource = dt;
                rptQuizzes.DataBind();
            }
        }

        protected void rptQuizzes_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            DataRowView row = (DataRowView)e.Item.DataItem;

            string quizID = row["quizID"].ToString();
            int attemptsUsed = Convert.ToInt32(row["attemptsUsed"]);
            object bestScoreObj = row["bestScore"];

            HyperLink lnkStart = (HyperLink)e.Item.FindControl("lnkStart");
            HtmlGenericControl divBestScore = (HtmlGenericControl)e.Item.FindControl("divBestScore");

            if (bestScoreObj != DBNull.Value)
            {
                divBestScore.InnerHtml = $"Attempts: {attemptsUsed}/{MAX_ATTEMPTS} &nbsp;|&nbsp; Best: <strong>{bestScoreObj}%</strong>";
            }
            else
            {
                divBestScore.InnerHtml = $"Attempts: {attemptsUsed}/{MAX_ATTEMPTS}";
            }

            if (attemptsUsed >= MAX_ATTEMPTS)
            {
                lnkStart.Text = "No Attempts Left";
                lnkStart.CssClass = "start-btn disabled";
                lnkStart.NavigateUrl = "#";
            }
            else
            {
                lnkStart.Text = "Start Quiz";
                lnkStart.NavigateUrl = "Quiz.aspx?quizID=" + quizID;
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("StudentDashboard.aspx");
        }
    }
}