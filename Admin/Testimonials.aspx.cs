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

        // Empty means "use the default pending-first order"; once the admin
        // clicks a column header, that takes over instead.
        private string SortExpression
        {
            get { return ViewState["SortExpression"] as string ?? ""; }
            set { ViewState["SortExpression"] = value; }
        }

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
                string search = txtSearch.Text.Trim();
                string status = ddlStatusFilter.SelectedValue;

                string orderBy = string.IsNullOrEmpty(SortExpression)
                    ? @"CASE t.appstat WHEN 'PENDING' THEN 0 WHEN 'APPROVED' THEN 1 ELSE 2 END, t.testimonialID"
                    : SortExpression;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"SELECT t.testimonialID AS TestimonialID,
                                             u.name AS StudentName,
                                             t.content AS Content,
                                             t.appstat AS Status
                                      FROM testimonialTable t
                                      JOIN userTable u ON t.studentID = u.UserID
                                      WHERE (@status = '' OR t.appstat = @status)
                                        AND (@search = '' OR u.name LIKE '%' + @search + '%' OR t.content LIKE '%' + @search + '%')
                                      ORDER BY " + orderBy;

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@status", status);
                    cmd.Parameters.AddWithValue("@search", search);

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

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            GridViewTestimonials.PageIndex = 0;
            BindGrid();
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            GridViewTestimonials.PageIndex = 0;
            BindGrid();
        }

        protected void GridViewTestimonials_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewTestimonials.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void GridViewTestimonials_Sorting(object sender, GridViewSortEventArgs e)
        {
            string column;
            switch (e.SortExpression)
            {
                case "StudentName": column = "u.name"; break;
                case "Status": column = "t.appstat"; break;
                default: column = "t.testimonialID"; break;
            }

            bool currentlyAsc = SortExpression == column + " ASC";
            SortExpression = column + (currentlyAsc ? " DESC" : " ASC");

            GridViewTestimonials.PageIndex = 0;
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