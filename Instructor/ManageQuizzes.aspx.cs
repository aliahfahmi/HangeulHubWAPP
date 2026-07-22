using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Instructor
{
    public partial class ManageQuizzes : Page
    {
        // Connection string is read from Web.config, same as Login.aspx.cs
        private readonly string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Only logged-in Language Instructors may open this page
            if (Session["UserID"] == null || Session["Role"] == null ||
                Session["Role"].ToString() != "Language Instructor")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCourseDropdown();
                LoadQuizzes();
            }
        }

        // ---------- Data loading ----------

        // Fills the Course dropdown shown inside the Add/Edit modal
        private void LoadCourseDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT courseID, title FROM courseTable ORDER BY title", conn);
                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlCourse.DataSource = dt;
                ddlCourse.DataTextField = "title";
                ddlCourse.DataValueField = "courseID";
                ddlCourse.DataBind();
            }
        }

        // Loads every quiz created by the currently logged-in instructor,
        // plus the course title and how many questions each quiz already has.
        private void LoadQuizzes()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT q.quizID, q.title, q.diffLevel, q.timelimit, q.passingScore, q.courseID,
                                         c.title AS courseTitle,
                                         (SELECT COUNT(*) FROM questionTable qt WHERE qt.quizID = q.quizID) AS questionCount
                                  FROM quizTable q
                                  JOIN courseTable c ON q.courseID = c.courseID
                                  WHERE q.instructorID = @instructorID
                                  ORDER BY q.quizID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptQuizzes.DataSource = dt;
                rptQuizzes.DataBind();

                pnlEmpty.Visible = dt.Rows.Count == 0;
                litTotal.Text = dt.Rows.Count.ToString();
            }
        }

        // Builds the next quiz ID by reading the highest existing one, e.g. Q007 -> Q008
        private string GenerateNextQuizID(SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand("SELECT MAX(quizID) FROM quizTable", conn);
            object result = cmd.ExecuteScalar();

            int nextNumber = 1;
            if (result != null && result != DBNull.Value)
            {
                string lastID = result.ToString();               // e.g. "Q007"
                nextNumber = int.Parse(lastID.Substring(1)) + 1;  // 7 + 1 = 8
            }
            return "Q" + nextNumber.ToString("D3");                // "Q008"
        }

        // ---------- Save (Insert or Update) ----------

        protected void btnSaveQuiz_Click(object sender, EventArgs e)
        {
            // Basic form validation
            if (txtTitle.Text.Trim() == "" || txtTimeLimit.Text.Trim() == "" || txtPassingScore.Text.Trim() == "")
            {
                lblModalMessage.Text = "Please fill in all fields.";
                ScriptManager_ShowModal();
                return;
            }

            bool isEdit = hfQuizID.Value != "";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd;

                if (isEdit)
                {
                    // UPDATE: editing a quiz that already exists
                    string query = @"UPDATE quizTable
                                      SET courseID = @courseID, title = @title, diffLevel = @diffLevel,
                                          timelimit = @timelimit, passingScore = @passingScore
                                      WHERE quizID = @quizID AND instructorID = @instructorID";
                    cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@quizID", hfQuizID.Value);
                }
                else
                {
                    // INSERT: brand new quiz
                    string newID = GenerateNextQuizID(conn);
                    string query = @"INSERT INTO quizTable (quizID, courseID, instructorID, title, diffLevel, timelimit, passingScore)
                                      VALUES (@quizID, @courseID, @instructorID, @title, @diffLevel, @timelimit, @passingScore)";
                    cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@quizID", newID);
                }

                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());
                cmd.Parameters.AddWithValue("@courseID", ddlCourse.SelectedValue);
                cmd.Parameters.AddWithValue("@title", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@diffLevel", ddlDifficulty.SelectedValue);
                cmd.Parameters.AddWithValue("@timelimit", int.Parse(txtTimeLimit.Text.Trim()));
                cmd.Parameters.AddWithValue("@passingScore", int.Parse(txtPassingScore.Text.Trim()));

                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Quiz saved successfully.";
            ClearForm();
            LoadQuizzes();
        }

        // ---------- Edit / Delete triggered from the quiz cards ----------

        protected void rptQuizzes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string quizID = e.CommandArgument.ToString();

            if (e.CommandName == "EditQuiz")
            {
                // Load the selected quiz's values into the modal fields, then reopen it
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM quizTable WHERE quizID = @quizID", conn);
                    cmd.Parameters.AddWithValue("@quizID", quizID);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        hfQuizID.Value = dr["quizID"].ToString();
                        ddlCourse.SelectedValue = dr["courseID"].ToString();
                        txtTitle.Text = dr["title"].ToString();
                        ddlDifficulty.SelectedValue = dr["diffLevel"].ToString();
                        txtTimeLimit.Text = dr["timelimit"].ToString();
                        txtPassingScore.Text = dr["passingScore"].ToString();
                    }
                }
                ScriptManager_ShowModal();
            }
            else if (e.CommandName == "DeleteQuiz")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Questions are children of a quiz (FK), so delete them first
                    SqlCommand cmdQuestions = new SqlCommand("DELETE FROM questionTable WHERE quizID = @quizID", conn);
                    cmdQuestions.Parameters.AddWithValue("@quizID", quizID);
                    cmdQuestions.ExecuteNonQuery();

                    SqlCommand cmdQuiz = new SqlCommand("DELETE FROM quizTable WHERE quizID = @quizID", conn);
                    cmdQuiz.Parameters.AddWithValue("@quizID", quizID);
                    cmdQuiz.ExecuteNonQuery();
                }

                lblMessage.Text = "Quiz deleted.";
                LoadQuizzes();
            }
        }

        // ---------- Small helpers ----------

        private void ClearForm()
        {
            hfQuizID.Value = "";
            txtTitle.Text = "";
            txtTimeLimit.Text = "";
            txtPassingScore.Text = "";
            ddlDifficulty.SelectedIndex = 0;
            lblModalMessage.Text = "";
        }

        // Re-opens the modal after a postback (used on validation error / Edit click)
        private void ScriptManager_ShowModal()
        {
            ClientScript.RegisterStartupScript(this.GetType(), "openModal", "openQuizModal();", true);
        }
    }
}