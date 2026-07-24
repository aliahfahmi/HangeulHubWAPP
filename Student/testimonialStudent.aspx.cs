using System;
using System.Configuration;
using System.Data.SqlClient;

namespace HangeulHubWAPP.Student
{
    public partial class TestimonialStudent : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("../Login.aspx");
                return;
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string content = txtTestimonial.Text.Trim();

            // Field empty check
            if (string.IsNullOrEmpty(content))
            {
                lblError.Text = "Please fill in your testimonial before submitting.";
                lblError.Visible = true;
                return;
            }

            // Field has text now - hide any previous error message
            lblError.Visible = false;

            string studentID = Session["UserID"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string newTestimonialID = "T" + DateTime.Now.Ticks.ToString().Substring(10);

                string sqlInsert = @"INSERT INTO testimonialTable (testimonialID, studentID, content, appstat)
                                      VALUES (@testimonialID, @studentID, @content, @appstat)";

                SqlCommand cmd = new SqlCommand(sqlInsert, conn);
                cmd.Parameters.AddWithValue("@testimonialID", newTestimonialID);
                cmd.Parameters.AddWithValue("@studentID", studentID);
                cmd.Parameters.AddWithValue("@content", content);
                cmd.Parameters.AddWithValue("@appstat", "Pending");

                cmd.ExecuteNonQuery();
            }

            // Show the "Done" confirmation, hide the form
            pnlForm.Visible = false;
            pnlDone.Visible = true;
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Student/StudentDashboard.aspx");
        }
    }
}