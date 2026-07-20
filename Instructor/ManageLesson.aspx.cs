using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace HangeulHubWAPP.Instructor
{
    public partial class ManageLessons : System.Web.UI.Page
    {
        string connectionString =
            ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLessons();
            }
        }

        private void LoadLessons()
        {
            string query = "SELECT * FROM lessonTable ORDER BY lessonID";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvLessons.DataSource = dt;
                gvLessons.DataBind();
            }
        }

        protected void btnAddLesson_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtContent.Text))
            {
                lblMessage.Text = "Please enter lesson content.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string getIdQuery = @"SELECT ISNULL(MAX(
                    CAST(SUBSTRING(lessonID, 2, 10) AS INT)), 0) + 1
                    FROM lessonTable";

                SqlCommand getIdCmd = new SqlCommand(getIdQuery, con);
                int nextNumber = Convert.ToInt32(getIdCmd.ExecuteScalar());
                string newLessonID = "L" + nextNumber.ToString("000");

                string query = @"INSERT INTO lessonTable
                    (lessonID, courseID, instructorID, type, content)
                    VALUES (@lessonID, @courseID, @instructorID, @type, @content)";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@lessonID", newLessonID);
                cmd.Parameters.AddWithValue("@courseID", ddlCourse.SelectedValue);
                cmd.Parameters.AddWithValue("@instructorID", "U002");
                cmd.Parameters.AddWithValue("@type", ddlType.SelectedValue);
                cmd.Parameters.AddWithValue("@content", txtContent.Text.Trim());

                cmd.ExecuteNonQuery();
            }

            txtContent.Text = "";
            lblMessage.Text = "Lesson added successfully!";
            lblMessage.ForeColor = System.Drawing.Color.Green;

            LoadLessons();
        }

        protected void gvLessons_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteLesson")
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM lessonTable WHERE lessonID = @lessonID";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@lessonID", e.CommandArgument.ToString());

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadLessons();
            }
        }
    }
}