using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Student
{
    public partial class LearningModules : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        // Tracks which lesson type is currently selected, so the type card can show as "active"
        public string SelectedTypeValue
        {
            get { return ViewState["SelectedType"] != null ? ViewState["SelectedType"].ToString() : ""; }
            set { ViewState["SelectedType"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string studentID = Session["UserID"].ToString();
                List<string> levels = GetStudentLevels(studentID);

                if (levels.Count == 0)
                {
                    lblLevel.Text = "Not enrolled in a course yet";
                    lblLevel.Visible = true;
                    return;
                }

                if (levels.Count == 1)
                {
                    // Only one level - show it directly, no dropdown needed
                    divLevelSelect.Visible = false;
                    lblLevel.Text = levels[0];
                    lblLevel.Visible = true;

                    LoadCourseAndTypes(studentID, levels[0]);
                }
                else
                {
                    // More than one level - let the student pick which one to view
                    lblLevel.Visible = false;
                    divLevelSelect.Visible = true;

                    ddlLevelSelect.DataSource = levels;
                    ddlLevelSelect.DataBind();

                    LoadCourseAndTypes(studentID, ddlLevelSelect.SelectedValue);
                }
            }
        }

        // Finds EVERY level the student is enrolled in via progressTable -> courseTable
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

        // Finds the course the student is enrolled in AT this level, then loads
        // the distinct lesson types available for that course
        private void LoadCourseAndTypes(string studentID, string level)
        {
            string courseID = null;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string courseQuery = @"SELECT TOP 1 c.courseID, c.title
                                        FROM progressTable p
                                        JOIN courseTable c ON p.courseID = c.courseID
                                        WHERE p.studentID = @studentID AND c.level = @level";

                using (SqlCommand cmd = new SqlCommand(courseQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@studentID", studentID);
                    cmd.Parameters.AddWithValue("@level", level);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            courseID = reader["courseID"].ToString();
                            lblCourseTitle.Text = reader["title"].ToString();
                        }
                    }
                }
            }

            if (courseID == null)
            {
                lblCourseTitle.Text = "No course found for this level.";
                rptTypes.DataSource = null;
                rptTypes.DataBind();
                return;
            }

            ViewState["CurrentCourseID"] = courseID;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string typeQuery = "SELECT DISTINCT type FROM lessonTable WHERE courseID = @courseID";

                using (SqlCommand cmd = new SqlCommand(typeQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@courseID", courseID);
                    conn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptTypes.DataSource = dt;
                    rptTypes.DataBind();
                }
            }

            // Clear any previously selected type's content since the course just changed
            SelectedTypeValue = "";
            rptLessonContent.DataSource = null;
            rptLessonContent.DataBind();
        }

        // Runs when the student clicks a lesson type card
        protected void rptTypes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectType")
            {
                string selectedType = e.CommandArgument.ToString();
                SelectedTypeValue = selectedType;

                string courseID = ViewState["CurrentCourseID"] != null ? ViewState["CurrentCourseID"].ToString() : "";

                LoadLessonContent(courseID, selectedType);
            }
        }

        // Loads every lesson of the selected type for the current course
        private void LoadLessonContent(string courseID, string type)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT type, content FROM lessonTable WHERE courseID = @courseID AND type = @type";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@courseID", courseID);
                    cmd.Parameters.AddWithValue("@type", type);
                    conn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptLessonContent.DataSource = dt;
                    rptLessonContent.DataBind();
                }
            }
        }

        // Runs when the student switches level in the dropdown
        protected void ddlLevelSelect_SelectedIndexChanged(object sender, EventArgs e)
        {
            string studentID = Session["UserID"].ToString();
            LoadCourseAndTypes(studentID, ddlLevelSelect.SelectedValue);
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("StudentDashboard.aspx");
        }
    }
}