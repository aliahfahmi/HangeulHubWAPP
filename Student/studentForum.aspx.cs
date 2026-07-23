using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace HangeulHubWAPP.Student
{
    public partial class StudentForum : System.Web.UI.Page
    {
        // Reads the same connection string used in DBconnection.aspx
        string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLecturers();
                LoadForumPosts();
            }
        }

        // Fills the "Select Instructor" dropdown from userTable
        // ASSUMPTION: userTable has a Role column marking lecturers (e.g. Role = 'Lecturer')
        // and a Name column. Adjust column names below if yours differ.
        private void LoadLecturers()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT UserID, Name FROM userTable WHERE Role = 'Lecturer'";
                SqlCommand cmd = new SqlCommand(sql, conn);

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlLecturer.DataSource = dt;
                ddlLecturer.DataBind();
            }
        }

        // Loads only the logged-in student's own forum posts, newest first
        private void LoadForumPosts()
        {
            string studentID = Session["UserID"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT ForumID, questionText, questionDate, responseText, responseDate, stat 
                               FROM forumTable 
                               WHERE studentID = @studentID 
                               ORDER BY questionDate DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@studentID", studentID);

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptForumPosts.DataSource = dt;
                rptForumPosts.DataBind();
            }
        }

        // Runs when the student clicks "Post Question"
        protected void btnPostQuestion_Click(object sender, EventArgs e)
        {
            string questionText = txtQuestion.Text.Trim();

            if (string.IsNullOrEmpty(questionText))
            {
                return;
            }

            string studentID = Session["UserID"].ToString();
            string lecturerID = ddlLecturer.SelectedValue;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // create a simple new ForumID, e.g. F0001
                string newForumID = "F" + DateTime.Now.Ticks.ToString().Substring(10);

                string sqlInsert = @"INSERT INTO forumTable 
                                      (ForumID, studentID, lecturerID, questionText, questionDate, stat) 
                                      VALUES (@ForumID, @studentID, @lecturerID, @questionText, @questionDate, @stat)";

                SqlCommand cmd = new SqlCommand(sqlInsert, conn);
                cmd.Parameters.AddWithValue("@ForumID", newForumID);
                cmd.Parameters.AddWithValue("@studentID", studentID);
                cmd.Parameters.AddWithValue("@lecturerID", lecturerID);
                cmd.Parameters.AddWithValue("@questionText", questionText);
                cmd.Parameters.AddWithValue("@questionDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@stat", "Pending");

                cmd.ExecuteNonQuery();
            }

            // clear the textbox and refresh the list to show the new question
            txtQuestion.Text = "";
            LoadForumPosts();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("StudentDashboard.aspx");
        }
    }
}