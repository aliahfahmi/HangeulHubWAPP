using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Instructor
{
    public partial class ManageLessons : System.Web.UI.Page
    {
        string connectionString =
            ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["UserID"] == null || Session["Role"] == null ||
                Session["Role"].ToString() != "Language Instructor")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCourseDropdown();
                LoadLessons();
                LoadStats();
            }
        }

        private void LoadCourseDropdown()
        {
            string query = "SELECT courseID, title FROM courseTable ORDER BY title";
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlCourse.DataSource = dt;
                ddlCourse.DataTextField = "title";
                ddlCourse.DataValueField = "courseID";
                ddlCourse.DataBind();
            }
        }


        private void LoadLessons()
        {

            string query = @"SELECT l.lessonID, l.courseID, l.type, l.content,
                                     c.level AS courseLevel, c.title AS courseTitle
                              FROM lessonTable l
                              JOIN courseTable c ON l.courseID = c.courseID
                              WHERE l.instructorID = @instructorID
                              ORDER BY l.lessonID";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());
                con.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptLessons.DataSource = dt;
                rptLessons.DataBind();
                pnlEmpty.Visible = (dt.Rows.Count == 0);   // #13 empty state
            }
        }


        private void LoadStats()
        {
            string query = @"
                SELECT
                    COUNT(*) AS total,
                    SUM(CASE WHEN c.level = 'Beginner' THEN 1 ELSE 0 END) AS beginner,
                    SUM(CASE WHEN c.level = 'Intermediate' THEN 1 ELSE 0 END) AS intermediate,
                    SUM(CASE WHEN c.level = 'Advanced' THEN 1 ELSE 0 END) AS advanced
                FROM lessonTable l
                JOIN courseTable c ON l.courseID = c.courseID
                WHERE l.instructorID = @instructorID";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());
                con.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        litTotal.Text = r["total"].ToString();
                        litBeginner.Text = (r["beginner"] == DBNull.Value ? "0" : r["beginner"].ToString());
                        litIntermediate.Text = (r["intermediate"] == DBNull.Value ? "0" : r["intermediate"].ToString());
                        litAdvanced.Text = (r["advanced"] == DBNull.Value ? "0" : r["advanced"].ToString());
                    }
                }
            }
        }

        protected void btnSaveLesson_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtContent.Text))
            {
                lblModalMessage.Text = "Please enter lesson content.";
                lblModalMessage.ForeColor = System.Drawing.Color.Red;
                // Reopen the modal so the user sees the error
                ScriptManager.RegisterStartupScript(this, GetType(), "reopen",
                    "openLessonModalAs('" + (string.IsNullOrEmpty(hfLessonID.Value) ? "New Lesson" : "Edit Lesson") + "');", true);
                return;
            }

            bool isEdit = !string.IsNullOrEmpty(hfLessonID.Value);
            string instructorID = Session["UserID"].ToString();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                if (isEdit)
                {
                    string update = @"UPDATE lessonTable
                                      SET courseID = @courseID, type = @type, content = @content
                                      WHERE lessonID = @lessonID AND instructorID = @instructorID";
                    using (SqlCommand cmd = new SqlCommand(update, con))
                    {
                        cmd.Parameters.AddWithValue("@courseID", ddlCourse.SelectedValue);
                        cmd.Parameters.AddWithValue("@type", ddlType.SelectedValue);
                        cmd.Parameters.AddWithValue("@content", txtContent.Text.Trim());
                        cmd.Parameters.AddWithValue("@lessonID", hfLessonID.Value);
                        cmd.Parameters.AddWithValue("@instructorID", instructorID);
                        cmd.ExecuteNonQuery();
                    }
                    lblMessage.Text = "Lesson " + hfLessonID.Value + " updated successfully!";
                }
                else
                {
                    string getIdQuery = @"SELECT ISNULL(MAX(
                        CAST(SUBSTRING(lessonID, 2, 10) AS INT)), 0) + 1
                        FROM lessonTable";
                    SqlCommand getIdCmd = new SqlCommand(getIdQuery, con);
                    int nextNumber = Convert.ToInt32(getIdCmd.ExecuteScalar());
                    string newLessonID = "L" + nextNumber.ToString("000");

                    string insert = @"INSERT INTO lessonTable
                        (lessonID, courseID, instructorID, type, content)
                        VALUES (@lessonID, @courseID, @instructorID, @type, @content)";
                    using (SqlCommand cmd = new SqlCommand(insert, con))
                    {
                        cmd.Parameters.AddWithValue("@lessonID", newLessonID);
                        cmd.Parameters.AddWithValue("@courseID", ddlCourse.SelectedValue);
                        cmd.Parameters.AddWithValue("@instructorID", instructorID);
                        cmd.Parameters.AddWithValue("@type", ddlType.SelectedValue);
                        cmd.Parameters.AddWithValue("@content", txtContent.Text.Trim());
                        cmd.ExecuteNonQuery();
                    }
                    lblMessage.Text = "Lesson added successfully!";
                }
            }

            txtContent.Text = "";
            hfLessonID.Value = "";
            lblModalMessage.Text = "";
            lblMessage.ForeColor = System.Drawing.Color.Green;
            LoadLessons();
            LoadStats();
        }

        protected void rptLessons_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "EditLesson")
            {
                string lessonID = e.CommandArgument.ToString();

                string query = @"SELECT courseID, type, content FROM lessonTable
                                  WHERE lessonID = @lessonID AND instructorID = @instructorID";
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@lessonID", lessonID);
                    cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());
                    con.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            hfLessonID.Value = lessonID;
                            ddlCourse.SelectedValue = r["courseID"].ToString();
                            ddlType.SelectedValue = r["type"].ToString();
                            txtContent.Text = r["content"].ToString();
                        }
                    }
                }
                LoadLessons();
                LoadStats();
                lblModalMessage.Text = "";
                ScriptManager.RegisterStartupScript(this, GetType(), "editOpen",
                    "openLessonModalAs('Edit Lesson');", true);
            }
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            string lessonID = hfDeleteID.Value;
            if (string.IsNullOrEmpty(lessonID)) return;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // FIX: only delete if it belongs to the logged-in instructor
                string query = "DELETE FROM lessonTable WHERE lessonID = @lessonID AND instructorID = @instructorID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@lessonID", lessonID);
                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());
                con.Open();
                cmd.ExecuteNonQuery();
            }

            hfDeleteID.Value = "";
            lblMessage.Text = "Lesson " + lessonID + " deleted.";
            lblMessage.ForeColor = System.Drawing.Color.Green;
            LoadLessons();
            LoadStats();
        }

        protected string GetLessonTitle(object type)
        {
            switch (Convert.ToString(type))
            {
                case "Hangul": return "Hangul Alphabet Lesson";
                case "Vocabulary": return "Vocabulary Lesson";
                case "Grammar": return "Grammar Lesson";
                default: return "Korean Lesson";
            }
        }

        protected string GetLevelKey(object courseLevel)
        {
            return Convert.ToString(courseLevel).ToLowerInvariant();
        }

        protected string GetLevelDot(object courseLevel)
        {
            switch (Convert.ToString(courseLevel))
            {
                case "Beginner": return "&#128995;";     // purple circle
                case "Intermediate": return "&#128309;"; // blue circle
                case "Advanced": return "&#128994;";     // green circle
                default: return "";
            }
        }

        protected string GetTypeGlyph(object type)
        {
            switch (Convert.ToString(type))
            {
                case "Hangul": return "&#54620;";     
                case "Vocabulary": return "&#45800;"; 
                case "Grammar": return "&#47928;";    
                default: return "&#44397;";           
            }
        }

        protected string GetPreview(object content)
        {
            string text = Convert.ToString(content) ?? "";
            if (text.Length <= 100) return text;
            return text.Substring(0, 100).TrimEnd() + "...";
        }
    }
}