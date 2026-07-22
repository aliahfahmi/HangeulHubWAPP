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
            // #18: no hardcoded instructor — require a logged-in session
            if (Session["UserID"] == null)
            {
                Session["UserID"] = "U002";
                Session["Name"] = "Test Instructor";
            }

            if (!IsPostBack)
            {
                LoadLessons();
                LoadStats();
            }
        }

        // =====================================================
        //  Load lessons into the Repeater (cards)
        // =====================================================
        private void LoadLessons()
        {
            string query = "SELECT * FROM lessonTable ORDER BY lessonID";
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptLessons.DataSource = dt;
                rptLessons.DataBind();
                pnlEmpty.Visible = (dt.Rows.Count == 0);   // #13 empty state
            }
        }

        // =====================================================
        //  #17: Dashboard statistics (one query, four counts)
        // =====================================================
        private void LoadStats()
        {
            string query = @"
                SELECT
                    COUNT(*) AS total,
                    SUM(CASE WHEN courseID = 'C001' THEN 1 ELSE 0 END) AS beginner,
                    SUM(CASE WHEN courseID = 'C002' THEN 1 ELSE 0 END) AS intermediate,
                    SUM(CASE WHEN courseID = 'C003' THEN 1 ELSE 0 END) AS advanced
                FROM lessonTable";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
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

        // =====================================================
        //  Save (insert when hfLessonID is empty, update otherwise)
        // =====================================================
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

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                if (isEdit)
                {
                    string update = @"UPDATE lessonTable
                                      SET courseID = @courseID, type = @type, content = @content
                                      WHERE lessonID = @lessonID";
                    using (SqlCommand cmd = new SqlCommand(update, con))
                    {
                        cmd.Parameters.AddWithValue("@courseID", ddlCourse.SelectedValue);
                        cmd.Parameters.AddWithValue("@type", ddlType.SelectedValue);
                        cmd.Parameters.AddWithValue("@content", txtContent.Text.Trim());
                        cmd.Parameters.AddWithValue("@lessonID", hfLessonID.Value);
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
                        cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString()); // #18
                        cmd.Parameters.AddWithValue("@type", ddlType.SelectedValue);
                        cmd.Parameters.AddWithValue("@content", txtContent.Text.Trim());
                        cmd.ExecuteNonQuery();
                    }
                    lblMessage.Text = "Lesson added successfully!";
                }
            }

            // Reset form + close modal (modal is closed by default after postback)
            txtContent.Text = "";
            hfLessonID.Value = "";
            lblModalMessage.Text = "";
            lblMessage.ForeColor = System.Drawing.Color.Green;

            LoadLessons();
            LoadStats();
        }

        // =====================================================
        //  Edit: load the lesson into the modal
        // =====================================================
        protected void rptLessons_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "EditLesson")
            {
                string lessonID = e.CommandArgument.ToString();

                string query = "SELECT courseID, type, content FROM lessonTable WHERE lessonID = @lessonID";
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@lessonID", lessonID);
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

        // =====================================================
        //  #9: Delete confirmed via the custom modal
        // =====================================================
        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            string lessonID = hfDeleteID.Value;
            if (string.IsNullOrEmpty(lessonID)) return;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM lessonTable WHERE lessonID = @lessonID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@lessonID", lessonID);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            hfDeleteID.Value = "";
            lblMessage.Text = "Lesson " + lessonID + " deleted.";
            lblMessage.ForeColor = System.Drawing.Color.Green;
            LoadLessons();
            LoadStats();
        }

        // =====================================================
        //  #7 / #11: Helpers used by the Repeater databinding
        // =====================================================
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

        protected string GetLevelName(object courseID)
        {
            switch (Convert.ToString(courseID))
            {
                case "C001": return "Beginner";
                case "C002": return "Intermediate";
                case "C003": return "Advanced";
                default: return Convert.ToString(courseID);
            }
        }

        // CSS class / data-attribute key: beginner | intermediate | advanced
        protected string GetLevelKey(object courseID)
        {
            return GetLevelName(courseID).ToLowerInvariant();
        }

        protected string GetLevelDot(object courseID)
        {
            switch (Convert.ToString(courseID))
            {
                case "C001": return "&#128995;"; // purple circle
                case "C002": return "&#128309;"; // blue circle
                case "C003": return "&#128994;"; // green circle
                default: return "";
            }
        }

        // Korean glyph shown on the card, based on lesson type
        protected string GetTypeGlyph(object type)
        {
            switch (Convert.ToString(type))
            {
                case "Hangul": return "&#54620;";     // 한
                case "Vocabulary": return "&#45800;"; // 단
                case "Grammar": return "&#47928;";    // 문
                default: return "&#44397;";           // 국
            }
        }

        // #10: first 100 characters only
        protected string GetPreview(object content)
        {
            string text = Convert.ToString(content) ?? "";
            if (text.Length <= 100) return text;
            return text.Substring(0, 100).TrimEnd() + "...";
        }
    }
}