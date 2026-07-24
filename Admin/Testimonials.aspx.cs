using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Admin
{
    public partial class Testimonials : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            try
            {
                string status = ddlStatusFilter.SelectedValue;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"SELECT t.testimonialID AS TestimonialID,
                                             u.name AS StudentName,
                                             t.content AS Content,
                                             t.appstat AS Status
                                      FROM testimonialTable t
                                      JOIN userTable u ON t.studentID = u.UserID
                                      WHERE (@status = '' OR t.appstat = @status)
                                      ORDER BY
                                          CASE t.appstat
                                              WHEN 'PENDING' THEN 0
                                              WHEN 'APPROVED' THEN 1
                                              ELSE 2
                                          END,
                                          t.testimonialID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@status", status);

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    GridViewTestimonials.DataSource = dt;
                    GridViewTestimonials.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not load testimonials. Please try again later.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("BindGrid error: " + ex.Message);
            }
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            BindGrid();
        }

        protected void GridViewTestimonials_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string testimonialId = e.CommandArgument.ToString();

            try
            {
                if (e.CommandName == "Approve")
                {
                    SetStatus(testimonialId, "APPROVED");
                    lblMessage.Text = "Testimonial approved.";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }
                else if (e.CommandName == "Reject")
                {
                    SetStatus(testimonialId, "REJECTED");
                    lblMessage.Text = "Testimonial rejected.";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }
                else if (e.CommandName == "DeleteTestimonial")
                {
                    DeleteTestimonial(testimonialId);
                    lblMessage.Text = "Testimonial deleted.";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }

                BindGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not update testimonial. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("RowCommand error: " + ex.Message);
            }
        }

        private void SetStatus(string testimonialId, string newStatus)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE testimonialTable SET appstat = @status WHERE testimonialID = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@status", newStatus);
                cmd.Parameters.AddWithValue("@id", testimonialId);
                cmd.ExecuteNonQuery();
            }
        }

        private void DeleteTestimonial(string testimonialId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "DELETE FROM testimonialTable WHERE testimonialID = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", testimonialId);
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }
    }
}