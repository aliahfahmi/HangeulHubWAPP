using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Student
{
    public partial class Quiz : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    // Verify Session
                    if (Session["UserID"] == null)
                    {
                        Response.Redirect("~/Login.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                        return;
                    }

                    string level = Request.QueryString["level"] ?? "Beginner";
                    string instructorID = Request.QueryString["instructorID"];

                    ViewState["CurrentLevel"] = level;

                    LoadQuizHeader(level);
                    LoadQuestionsByDifficulty(level, instructorID);
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error loading quiz page: " + ex.Message;
                }
            }
        }

        private void LoadQuizHeader(string level)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT TOP 1 title, timelimit, passingScore 
                                 FROM quizTable 
                                 WHERE diffLevel = @level";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@level", level);
                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblQuizTitle.Text = $"{level} Assessment";
                            lblTimeLimit.Text = dr["timelimit"] != DBNull.Value ? dr["timelimit"].ToString() : "N/A";
                            lblPassingScore.Text = dr["passingScore"] != DBNull.Value ? dr["passingScore"].ToString() : "70";
                        }
                        else
                        {
                            lblQuizTitle.Text = $"{level} Assessment";
                            lblTimeLimit.Text = "N/A";
                            lblPassingScore.Text = "70";
                        }
                    }
                }
            }
        }

        private void LoadQuestionsByDifficulty(string level, string instructorID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Joins questionTable with quizTable to retrieve all questions matching the difficulty level
                string query = @"SELECT qn.questionID, qn.questionText, qn.quizID 
                                 FROM questionTable qn
                                 INNER JOIN quizTable q ON qn.quizID = q.quizID
                                 WHERE q.diffLevel = @level";

                if (!string.IsNullOrEmpty(instructorID))
                {
                    query += " AND q.instructorID = @instructorID";
                }

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@level", level);
                    if (!string.IsNullOrEmpty(instructorID))
                    {
                        cmd.Parameters.AddWithValue("@instructorID", instructorID);
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptQuestions.DataSource = dt;
                            rptQuestions.DataBind();
                        }
                        else
                        {
                            lblMessage.Text = $"No questions found for difficulty level: {level}";
                            btnSubmitQuiz.Visible = false;
                        }
                    }
                }
            }
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            try
            {
                string studentID = Session["UserID"] != null ? Session["UserID"].ToString() : "";
                string level = ViewState["CurrentLevel"] != null ? ViewState["CurrentLevel"].ToString() : "Beginner";

                if (string.IsNullOrEmpty(studentID))
                {
                    lblMessage.Text = "Session expired. Please log in again to save your score.";
                    return;
                }

                int totalQuestions = 0;
                int correctAnswersCount = 0;
                string primaryQuizID = "";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // 1. Grade each submitted question
                    foreach (RepeaterItem item in rptQuestions.Items)
                    {
                        if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                        {
                            HiddenField hfQuestionID = (HiddenField)item.FindControl("hfQuestionID");
                            TextBox txtAnswer = (TextBox)item.FindControl("txtAnswer");

                            if (hfQuestionID != null && txtAnswer != null)
                            {
                                totalQuestions++;
                                string questionID = hfQuestionID.Value;
                                string userAns = txtAnswer.Text.Trim();

                                string query = "SELECT correctAns, quizID FROM questionTable WHERE questionID = @questionID";
                                using (SqlCommand cmd = new SqlCommand(query, conn))
                                {
                                    cmd.Parameters.AddWithValue("@questionID", questionID);
                                    using (SqlDataReader dr = cmd.ExecuteReader())
                                    {
                                        if (dr.Read())
                                        {
                                            if (string.IsNullOrEmpty(primaryQuizID))
                                            {
                                                primaryQuizID = dr["quizID"].ToString(); // Assign target quizID for history tracking
                                            }

                                            string correctAns = dr["correctAns"].ToString().Trim();
                                            if (string.Equals(userAns, correctAns, StringComparison.OrdinalIgnoreCase))
                                            {
                                                correctAnswersCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    int scorePercentage = totalQuestions > 0 ? (int)Math.Round((double)correctAnswersCount / totalQuestions * 100) : 0;

                    if (string.IsNullOrEmpty(primaryQuizID))
                    {
                        primaryQuizID = "Q001";
                    }

                    // 2. Fetch Next Attempt Number
                    int nextAttemptNumber = 1;
                    string attemptQuery = "SELECT ISNULL(MAX(attemptNumber), 0) + 1 FROM quizAttemptTable WHERE studentID = @studentID AND quizID = @quizID";
                    using (SqlCommand cmdAttempt = new SqlCommand(attemptQuery, conn))
                    {
                        cmdAttempt.Parameters.AddWithValue("@studentID", studentID);
                        cmdAttempt.Parameters.AddWithValue("@quizID", primaryQuizID);
                        nextAttemptNumber = Convert.ToInt32(cmdAttempt.ExecuteScalar());
                    }

                    // 3. Read Time Taken from Hidden Field
                    int timeTakenInMinutes = 1;
                    int.TryParse(hfTimeTaken.Value, out timeTakenInMinutes);
                    if (timeTakenInMinutes < 1) timeTakenInMinutes = 1;

                    // 4. Save Attempt Details to quizAttemptTable
                    string newAttemptID = "ATT" + Guid.NewGuid().ToString("N").Substring(0, 6).ToUpper();
                    string insertAttempt = @"INSERT INTO quizAttemptTable (attemptID, studentID, quizID, attemptNumber, score, dateTaken, timeTaken)
                                             VALUES (@attemptID, @studentID, @quizID, @attemptNumber, @score, GETDATE(), @timeTaken)";

                    using (SqlCommand cmdInsert = new SqlCommand(insertAttempt, conn))
                    {
                        cmdInsert.Parameters.AddWithValue("@attemptID", newAttemptID);
                        cmdInsert.Parameters.AddWithValue("@studentID", studentID);
                        cmdInsert.Parameters.AddWithValue("@quizID", primaryQuizID);
                        cmdInsert.Parameters.AddWithValue("@attemptNumber", nextAttemptNumber);
                        cmdInsert.Parameters.AddWithValue("@score", scorePercentage);
                        cmdInsert.Parameters.AddWithValue("@timeTaken", timeTakenInMinutes);

                        cmdInsert.ExecuteNonQuery();
                    }

                    // 5. Display Result
                    int passingScore = 70;
                    int.TryParse(lblPassingScore.Text, out passingScore);

                    pnlQuiz.Visible = false;
                    pnlResult.Visible = true;

                    lblScore.Text = $"{scorePercentage}% ({correctAnswersCount}/{totalQuestions})";

                    if (scorePercentage >= passingScore)
                    {
                        lblResultMessage.Text = $"Congratulations! You passed the {level} quiz on Attempt #{nextAttemptNumber} in {timeTakenInMinutes} min!";
                    }
                    else
                    {
                        lblResultMessage.Text = $"Attempt #{nextAttemptNumber} ({timeTakenInMinutes} min taken): You did not reach the passing score. Keep practicing!";
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error submitting quiz: " + ex.Message;
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Student/StudentDashboard.aspx");
        }
    }
}