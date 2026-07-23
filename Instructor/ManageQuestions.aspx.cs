using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Instructor
{
    public partial class ManageQuestions : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        // Which quiz we're managing questions for - comes from the URL, e.g.
        // ManageQuestions.aspx?quizID=Q001
        private string QuizID => Request.QueryString["quizID"];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"] == null ||
                Session["Role"].ToString() != "Language Instructor")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // This page always needs a quizID to know which quiz it's editing
            if (string.IsNullOrEmpty(QuizID))
            {
                Response.Redirect("~/Instructor/ManageQuizzes.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadQuizInfo();
                LoadQuestions();
            }
        }

        // Shows the quiz title + level/time limit at the top of the page for context
        private void LoadQuizInfo()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT q.title, q.diffLevel, q.timelimit, c.title AS courseTitle
                                  FROM quizTable q
                                  JOIN courseTable c ON q.courseID = c.courseID
                                  WHERE q.quizID = @quizID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@quizID", QuizID);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    litQuizTitle.Text = dr["title"].ToString();
                    litQuizMeta.Text = $"{dr["courseTitle"]} &middot; {dr["diffLevel"]} &middot; {dr["timelimit"]} minutes";
                }
            }
        }

        // Loads all questions that belong to this quiz
        private void LoadQuestions()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT questionID, questionText, correctAns FROM questionTable WHERE quizID = @quizID ORDER BY questionID", conn);
                cmd.Parameters.AddWithValue("@quizID", QuizID);

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptQuestions.DataSource = dt;
                rptQuestions.DataBind();

                pnlEmpty.Visible = dt.Rows.Count == 0;
            }
        }

        // Generates the next question ID, e.g. E034 -> E035
        private string GenerateNextQuestionID(SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand("SELECT MAX(questionID) FROM questionTable", conn);
            object result = cmd.ExecuteScalar();

            int nextNumber = 1;
            if (result != null && result != DBNull.Value)
            {
                string lastID = result.ToString();               // e.g. "E034"
                nextNumber = int.Parse(lastID.Substring(1)) + 1;
            }
            return "E" + nextNumber.ToString("D3");                // "E035"
        }

        protected void btnSaveQuestion_Click(object sender, EventArgs e)
        {
            if (txtQuestionText.Text.Trim() == "" || txtCorrectAns.Text.Trim() == "")
            {
                lblModalMessage.Text = "Please fill in both fields.";
                ShowModal();
                return;
            }

            bool isEdit = hfQuestionID.Value != "";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd;

                if (isEdit)
                {
                    string query = @"UPDATE questionTable
                                      SET questionText = @questionText, correctAns = @correctAns
                                      WHERE questionID = @questionID";
                    cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@questionID", hfQuestionID.Value);
                }
                else
                {
                    string newID = GenerateNextQuestionID(conn);
                    string query = @"INSERT INTO questionTable (questionID, quizID, questionText, correctAns)
                                      VALUES (@questionID, @quizID, @questionText, @correctAns)";
                    cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@questionID", newID);
                    cmd.Parameters.AddWithValue("@quizID", QuizID);
                }

                cmd.Parameters.AddWithValue("@questionText", txtQuestionText.Text.Trim());
                cmd.Parameters.AddWithValue("@correctAns", txtCorrectAns.Text.Trim());

                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Question saved.";
            ClearForm();
            LoadQuestions();
        }

        // ---------- AI question generation ----------
        //
        // How this works, end to end:
        // 1. Instructor types a topic + picks how many questions.
        // 2. We look up this quiz's difficulty level (Beginner/Intermediate/Advanced)
        //    so the AI matches the right level automatically.
        // 3. AiQuestionHelper.GenerateQuestions() sends that to OpenAI and returns a
        //    plain C# list of {QuestionText, CorrectAnswer} pairs.
        // 4. We insert each one into questionTable using the exact same INSERT
        //    logic as a manually typed question (GenerateNextQuestionID etc.),
        //    so AI questions are indistinguishable from manual ones afterwards.
        // 5. The question list below refreshes, and the instructor can Edit or
        //    Delete any AI question exactly like a normal one - that's how they
        //    "review" the AI's output, instead of a separate approval screen.
        protected void btnGenerateAi_Click(object sender, EventArgs e)
        {
            string topic = txtAiTopic.Text.Trim();
            int count = int.Parse(ddlAiCount.SelectedValue);

            if (topic == "")
            {
                lblAiMessage.Text = "Please enter a topic.";
                ShowAiModal();
                return;
            }

            string difficulty = GetQuizDifficulty();

            List<GeneratedQuestion> generated;
            try
            {
                generated = AiQuestionHelper.GenerateQuestions(topic, difficulty, count);
            }
            catch (Exception ex)
            {
                // Most common cause here: missing/invalid OpenAI_ApiKey in Web.config
                lblAiMessage.Text = "AI generation failed: " + ex.Message;
                ShowAiModal();
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                foreach (GeneratedQuestion q in generated)
                {
                    string newID = GenerateNextQuestionID(conn);
                    string query = @"INSERT INTO questionTable (questionID, quizID, questionText, correctAns)
                                      VALUES (@questionID, @quizID, @questionText, @correctAns)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@questionID", newID);
                    cmd.Parameters.AddWithValue("@quizID", QuizID);
                    cmd.Parameters.AddWithValue("@questionText", q.QuestionText);
                    cmd.Parameters.AddWithValue("@correctAns", q.CorrectAnswer);
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = $"{generated.Count} question(s) added by AI - review them below and edit/delete as needed.";
            txtAiTopic.Text = "";
            LoadQuestions();
        }

        // Looks up this quiz's difficulty level so the AI prompt matches it automatically
        private string GetQuizDifficulty()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT diffLevel FROM quizTable WHERE quizID = @quizID", conn);
                cmd.Parameters.AddWithValue("@quizID", QuizID);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? result.ToString() : "Beginner";
            }
        }

        private void ShowAiModal()
        {
            ClientScript.RegisterStartupScript(this.GetType(), "openAiModal", "openAiModal();", true);
        }

        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string questionID = e.CommandArgument.ToString();

            if (e.CommandName == "EditQuestion")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM questionTable WHERE questionID = @questionID", conn);
                    cmd.Parameters.AddWithValue("@questionID", questionID);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        hfQuestionID.Value = dr["questionID"].ToString();
                        txtQuestionText.Text = dr["questionText"].ToString();
                        txtCorrectAns.Text = dr["correctAns"].ToString();
                    }
                }
                ShowModal();
            }
            else if (e.CommandName == "DeleteQuestion")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM questionTable WHERE questionID = @questionID", conn);
                    cmd.Parameters.AddWithValue("@questionID", questionID);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "Question deleted.";
                LoadQuestions();
            }
        }

        private void ClearForm()
        {
            hfQuestionID.Value = "";
            txtQuestionText.Text = "";
            txtCorrectAns.Text = "";
            lblModalMessage.Text = "";
        }

        private void ShowModal()
        {
            ClientScript.RegisterStartupScript(this.GetType(), "openModal", "openQuestionModal();", true);
        }
    }
}