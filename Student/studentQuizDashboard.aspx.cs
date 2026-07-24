using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

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

        private void LoadQuizzes()
        {
            string studentID = Session["UserID"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Lists every quiz, plus how many attempts THIS student has used
                // and their best score so far for each one.
                string query = @"SELECT q.quizID, q.title, q.diffLevel, q.timelimit, q.passingScore,
                                         ISNULL(a.attemptsUsed, 0) AS attemptsUsed,
                                         a.bestScore AS bestScore
                                  FROM quizTable q
                                  LEFT JOIN (
                                      SELECT quizID, COUNT(*) AS attemptsUsed, MAX(score) AS bestScore
                                      FROM quizAttemptTable
                                      WHERE studentID = @studentID
                                      GROUP BY quizID
                                  ) a ON q.quizID = a.quizID
                                  ORDER BY q.diffLevel, q.title";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@studentID", studentID);

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptQuizzes.DataSource = dt;
                rptQuizzes.DataBind();
            }
        }

        // Runs once per quiz card - sets up the "Start Quiz" button based on attempts left
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
                // No attempts left - disable the button
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