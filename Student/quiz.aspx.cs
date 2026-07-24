using System;
using System.Collections.Generic;
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
        private const int MAX_ATTEMPTS = 3;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    if (Session["UserID"] == null)
                    {
                        Response.Redirect("~/Login.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                        return;
                    }

                    string quizID = Request.QueryString["quizID"];

                    if (string.IsNullOrEmpty(quizID))
                    {
                        // No quiz selected - send them back to pick one
                        Response.Redirect("StudentQuizDashboard.aspx");
                        return;
                    }

                    ViewState["CurrentQuizID"] = quizID;

                    string studentID = Session["UserID"].ToString();

                    LoadQuizHeader(quizID);

                    int attemptsUsed = GetUserAttemptsCount(studentID, quizID);
                    lblAttemptCount.Text = $"{attemptsUsed}/{MAX_ATTEMPTS}";

                    if (attemptsUsed >= MAX_ATTEMPTS)
                    {
                        // Show their best score instead of letting them retry
                        pnlQuiz.Visible = false;
                        int bestScore = GetBestScoreForQuiz(studentID, quizID);
                        lblMessage.Text = $"You have used all {MAX_ATTEMPTS} attempts for this quiz. Your best score was {bestScore}%.";
                        return;
                    }

                    LoadQuestions(quizID);
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error loading quiz page: " + ex.Message;
                }
            }
        }

        private void LoadQuizHeader(string quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT title, timelimit, passingScore FROM quizTable WHERE quizID = @quizID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@quizID", quizID);
                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblQuizTitle.Text = dr["title"].ToString();
                            lblTimeLimit.Text = dr["timelimit"] != DBNull.Value ? dr["timelimit"].ToString() : "N/A";
                            lblPassingScore.Text = dr["passingScore"] != DBNull.Value ? dr["passingScore"].ToString() : "70";
                        }
                    }
                }
            }
        }

        private int GetUserAttemptsCount(string studentID, string quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM quizAttemptTable WHERE studentID = @studentID AND quizID = @quizID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@studentID", studentID);
                    cmd.Parameters.AddWithValue("@quizID", quizID);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        private int GetBestScoreForQuiz(string studentID, string quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT ISNULL(MAX(score), 0) FROM quizAttemptTable WHERE studentID = @studentID AND quizID = @quizID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@studentID", studentID);
                    cmd.Parameters.AddWithValue("@quizID", quizID);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        private void LoadQuestions(string quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT questionID, questionText FROM questionTable WHERE quizID = @quizID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@quizID", quizID);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            // Convert both real newlines and literal "\n" text into <br/> tags
                            // so line breaks always show correctly regardless of how they were typed in
                            foreach (DataRow row in dt.Rows)
                            {
                                string text = row["questionText"].ToString();
                                text = text.Replace("\r\n", "<br/>")
                                            .Replace("\n", "<br/>")
                                            .Replace("\\n", "<br/>");
                                row["questionText"] = text;
                            }

                            rptQuestions.DataSource = dt;
                            rptQuestions.DataBind();
                        }
                        else
                        {
                            lblMessage.Text = "No questions found for this quiz.";
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
                string quizID = ViewState["CurrentQuizID"] != null ? ViewState["CurrentQuizID"].ToString() : "";

                if (string.IsNullOrEmpty(studentID) || string.IsNullOrEmpty(quizID))
                {
                    lblMessage.Text = "Session expired or quiz not found. Please try again.";
                    return;
                }

                int currentAttempts = GetUserAttemptsCount(studentID, quizID);
                if (currentAttempts >= MAX_ATTEMPTS)
                {
                    lblMessage.Text = $"You have already reached the maximum limit of {MAX_ATTEMPTS} attempts.";
                    pnlQuiz.Visible = false;
                    return;
                }

                int totalQuestions = 0;
                int correctAnswersCount = 0;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

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

                                string query = "SELECT correctAns FROM questionTable WHERE questionID = @questionID";
                                using (SqlCommand cmd = new SqlCommand(query, conn))
                                {
                                    cmd.Parameters.AddWithValue("@questionID", questionID);
                                    object res = cmd.ExecuteScalar();

                                    if (res != null)
                                    {
                                        string correctAns = res.ToString().Trim();
                                        if (string.Equals(userAns, correctAns, StringComparison.OrdinalIgnoreCase))
                                        {
                                            correctAnswersCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Raw accuracy - used for pass/fail decision, unaffected by time
                    int accuracyPercentage = totalQuestions > 0 ? (int)Math.Round((double)correctAnswersCount / totalQuestions * 100) : 0;
                    int nextAttemptNumber = currentAttempts + 1;

                    int timeTakenInMinutes = 1;
                    int.TryParse(hfTimeTaken.Value, out timeTakenInMinutes);
                    if (timeTakenInMinutes < 1) timeTakenInMinutes = 1;

                    int timeLimit;
                    int.TryParse(lblTimeLimit.Text, out timeLimit);
                    if (timeLimit <= 0) timeLimit = timeTakenInMinutes; // fallback so we never divide by zero

                    // ============================================
                    // TIME-WEIGHTED SCORE FORMULA
                    // Faster completion (relative to time limit) earns a bonus, up to +50%
                    // speedRatio: how much time was saved, from 0 (used it all) to 1 (instant)
                    // ============================================
                    double speedRatio = (double)(timeLimit - timeTakenInMinutes) / timeLimit;
                    if (speedRatio < 0) speedRatio = 0;   // took longer than the limit - no penalty, just no bonus
                    if (speedRatio > 1) speedRatio = 1;

                    double speedBonus = speedRatio * 0.5;  // up to +50% bonus

                    int finalScore = (int)Math.Round(accuracyPercentage * (1 + speedBonus));
                    // ============================================

                    string newAttemptID = "ATT" + Guid.NewGuid().ToString("N").Substring(0, 6).ToUpper();
                    string insertAttempt = @"INSERT INTO quizAttemptTable (attemptID, studentID, quizID, attemptNumber, score, dateTaken, timeTaken)
                                     VALUES (@attemptID, @studentID, @quizID, @attemptNumber, @score, GETDATE(), @timeTaken)";

                    using (SqlCommand cmdInsert = new SqlCommand(insertAttempt, conn))
                    {
                        cmdInsert.Parameters.AddWithValue("@attemptID", newAttemptID);
                        cmdInsert.Parameters.AddWithValue("@studentID", studentID);
                        cmdInsert.Parameters.AddWithValue("@quizID", quizID);
                        cmdInsert.Parameters.AddWithValue("@attemptNumber", nextAttemptNumber);
                        cmdInsert.Parameters.AddWithValue("@score", finalScore);
                        cmdInsert.Parameters.AddWithValue("@timeTaken", timeTakenInMinutes);

                        cmdInsert.ExecuteNonQuery();
                    }

                    lblAttemptCount.Text = $"{nextAttemptNumber}/{MAX_ATTEMPTS}";

                    int passingScore = 70;
                    int.TryParse(lblPassingScore.Text, out passingScore);

                    pnlQuiz.Visible = false;
                    pnlResult.Visible = true;

                    // Show both the raw accuracy and the time-boosted score to the student
                    lblScore.Text = $"{finalScore} pts ({accuracyPercentage}% correct, {correctAnswersCount}/{totalQuestions})";

                    // Pass/fail is decided by ACCURACY, not the time-boosted score
                    if (accuracyPercentage >= passingScore)
                    {
                        lblResultMessage.Text = $"Congratulations! You passed on Attempt #{nextAttemptNumber} in {timeTakenInMinutes} min!";
                    }
                    else
                    {
                        lblResultMessage.Text = $"Attempt #{nextAttemptNumber} ({timeTakenInMinutes} min taken): You did not reach the passing score.";
                        if (nextAttemptNumber < MAX_ATTEMPTS)
                            lblResultMessage.Text += $" You have {MAX_ATTEMPTS - nextAttemptNumber} attempt(s) remaining.";
                        else
                            lblResultMessage.Text += " You have reached the maximum attempt limit.";
                    }
                }

                // Recalculate this student's overall leaderboard total + everyone's rank
                UpdateLeaderboardTotal(studentID);
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error submitting quiz: " + ex.Message;
            }
        }

        // Sums the student's BEST score from every quiz they've attempted,
        // then saves it as their leaderboard totalScore.
        private void UpdateLeaderboardTotal(string studentID)
        {
            int newTotalScore;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sumQuery = @"SELECT ISNULL(SUM(BestScores.bestScore), 0)
                                     FROM (
                                         SELECT quizID, MAX(score) AS bestScore
                                         FROM quizAttemptTable
                                         WHERE studentID = @studentID
                                         GROUP BY quizID
                                     ) AS BestScores";

                using (SqlCommand cmdSum = new SqlCommand(sumQuery, conn))
                {
                    cmdSum.Parameters.AddWithValue("@studentID", studentID);
                    newTotalScore = Convert.ToInt32(cmdSum.ExecuteScalar());
                }

                string checkQuery = "SELECT COUNT(*) FROM leaderboardTable WHERE studentID = @studentID";
                bool exists;
                using (SqlCommand cmdCheck = new SqlCommand(checkQuery, conn))
                {
                    cmdCheck.Parameters.AddWithValue("@studentID", studentID);
                    exists = Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0;
                }

                if (exists)
                {
                    string updateQuery = "UPDATE leaderboardTable SET totalScore = @totalScore WHERE studentID = @studentID";
                    using (SqlCommand cmdUpdate = new SqlCommand(updateQuery, conn))
                    {
                        cmdUpdate.Parameters.AddWithValue("@totalScore", newTotalScore);
                        cmdUpdate.Parameters.AddWithValue("@studentID", studentID);
                        cmdUpdate.ExecuteNonQuery();
                    }
                }
                else
                {
                    string newLeaderboardID = "LB" + DateTime.Now.Ticks.ToString().Substring(10);
                    string insertQuery = @"INSERT INTO leaderboardTable (leaderboardID, studentID, totalScore, rank)
                                            VALUES (@leaderboardID, @studentID, @totalScore, 0)";
                    using (SqlCommand cmdInsert = new SqlCommand(insertQuery, conn))
                    {
                        cmdInsert.Parameters.AddWithValue("@leaderboardID", newLeaderboardID);
                        cmdInsert.Parameters.AddWithValue("@studentID", studentID);
                        cmdInsert.Parameters.AddWithValue("@totalScore", newTotalScore);
                        cmdInsert.ExecuteNonQuery();
                    }
                }
            }

            RecalculateRanks();
        }

        // Re-ranks EVERY student in leaderboardTable, highest totalScore = rank 1
        private void RecalculateRanks()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                List<string> orderedIDs = new List<string>();

                string selectQuery = "SELECT leaderboardID FROM leaderboardTable ORDER BY totalScore DESC";
                using (SqlCommand cmdSelect = new SqlCommand(selectQuery, conn))
                using (SqlDataReader reader = cmdSelect.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        orderedIDs.Add(reader["leaderboardID"].ToString());
                    }
                }

                int currentRank = 1;
                foreach (string id in orderedIDs)
                {
                    string updateRankQuery = "UPDATE leaderboardTable SET rank = @rank WHERE leaderboardID = @id";
                    using (SqlCommand cmdUpdateRank = new SqlCommand(updateRankQuery, conn))
                    {
                        cmdUpdateRank.Parameters.AddWithValue("@rank", currentRank);
                        cmdUpdateRank.Parameters.AddWithValue("@id", id);
                        cmdUpdateRank.ExecuteNonQuery();
                    }
                    currentRank++;
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("StudentQuizDashboard.aspx");
        }
    }
}