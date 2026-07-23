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
                LoadForumPosts("Latest");
            }
        }

        // Loads forum posts based on the selected filter
        private void LoadForumPosts(string filter)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT ForumID, studentID, questionText, questionDate, responseText, responseDate, stat 
                       FROM forumTable ";

                // Answered filter only shows posts that have a response
                if (filter == "Answered")
                {
                    sql += " WHERE stat = 'Answered' ";
                }

                // Sort order changes based on filter
                if (filter == "Oldest")
                {
                    sql += " ORDER BY questionDate ASC";
                }
                else
                {
                    // Latest and Answered both show newest first
                    sql += " ORDER BY questionDate DESC";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptForumPosts.DataSource = dt;
                rptForumPosts.DataBind();
            }
        }

        // Runs when the student changes the filter dropdown
        protected void ddlFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadForumPosts(ddlFilter.SelectedValue);
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

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // create a simple new ForumID, e.g. F0001
                string newForumID = "F" + DateTime.Now.Ticks.ToString().Substring(10);

                string sqlInsert = @"INSERT INTO forumTable 
                                      (ForumID, studentID, questionText, questionDate, stat) 
                                      VALUES (@ForumID, @studentID, @questionText, @questionDate, @stat)";

                SqlCommand cmd = new SqlCommand(sqlInsert, conn);
                cmd.Parameters.AddWithValue("@ForumID", newForumID);
                cmd.Parameters.AddWithValue("@studentID", studentID);
                cmd.Parameters.AddWithValue("@questionText", questionText);
                cmd.Parameters.AddWithValue("@questionDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@stat", "Pending");

                cmd.ExecuteNonQuery();
            }

            // clear the textbox and refresh the list to show the new question
            txtQuestion.Text = "";
            LoadForumPosts();
        }

        private void LoadForumPosts()
        {
            throw new NotImplementedException();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("StudentDashboard.aspx");
        }
    }
}