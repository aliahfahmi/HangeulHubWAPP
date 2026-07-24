using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Admin
{
    public partial class Announcements : System.Web.UI.Page
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
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"SELECT a.announcementID AS AnnouncementID,
                                             u.name AS AuthorName,
                                             a.title AS Title,
                                             a.content AS Content,
                                             a.datePosted AS DatePosted
                                      FROM announcementTable a
                                      JOIN userTable u ON a.instructorID = u.UserID
                                      ORDER BY a.datePosted DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    GridViewAnnouncements.DataSource = dt;
                    GridViewAnnouncements.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not load announcements. Please try again later.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("BindGrid error: " + ex.Message);
            }
        }

        // Generates the next announcement ID, e.g. A003 -> A004
        // (same pattern as Instructor/ManageAnnouncements.aspx.cs, so IDs stay
        // consistent regardless of whether an admin or instructor posts)
        private string GenerateNextAnnouncementID(SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand("SELECT MAX(announcementID) FROM announcementTable", conn);
            object result = cmd.ExecuteScalar();

            int nextNumber = 1;
            if (result != null && result != DBNull.Value)
            {
                string lastID = result.ToString();
                nextNumber = int.Parse(lastID.Substring(1)) + 1;
            }
            return "A" + nextNumber.ToString("D3");
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            string title = txtNewTitle.Text.Trim();
            string content = txtNewContent.Text.Trim();

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(content))
            {
                lblMessage.Text = "Please fill in both the title and content.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string newId = GenerateNextAnnouncementID(conn);

                    string insert = @"INSERT INTO announcementTable (announcementID, instructorID, title, content, datePosted)
                                       VALUES (@id, @instructorID, @title, @content, GETDATE())";
                    SqlCommand cmd = new SqlCommand(insert, conn);
                    cmd.Parameters.AddWithValue("@id", newId);
                    cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@content", content);
                    cmd.ExecuteNonQuery();
                }

                txtNewTitle.Text = "";
                txtNewContent.Text = "";
                lblMessage.Text = "Announcement posted successfully.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                BindGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not post announcement. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("PostAnnouncement error: " + ex.Message);
            }
        }

        protected void GridViewAnnouncements_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewAnnouncements.EditIndex = e.NewEditIndex;
            BindGrid();
        }

        protected void GridViewAnnouncements_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewAnnouncements.EditIndex = -1;
            BindGrid();
        }

        protected void GridViewAnnouncements_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowIndex == GridViewAnnouncements.EditIndex)
            {
                DataRowView drv = e.Row.DataItem as DataRowView;
                if (drv != null)
                {
                    TextBox txtContent = (TextBox)e.Row.FindControl("txtEditContent");
                    if (txtContent != null) txtContent.Text = drv["Content"].ToString();
                }
            }
        }

        protected void GridViewAnnouncements_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GridViewAnnouncements.Rows[e.RowIndex];
                string announcementId = GridViewAnnouncements.DataKeys[e.RowIndex].Value.ToString();

                TextBox txtTitle = (TextBox)row.Cells[2].Controls[0];
                TextBox txtContent = (TextBox)row.FindControl("txtEditContent");

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"UPDATE announcementTable
                                      SET title = @title, content = @content
                                      WHERE announcementID = @id";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@title", txtTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@content", txtContent.Text.Trim());
                    cmd.Parameters.AddWithValue("@id", announcementId);
                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "Announcement updated successfully.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                GridViewAnnouncements.EditIndex = -1;
                BindGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not save changes. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("RowUpdating error: " + ex.Message);
            }
        }

        protected void GridViewAnnouncements_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                string announcementId = GridViewAnnouncements.DataKeys[e.RowIndex].Value.ToString();

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "DELETE FROM announcementTable WHERE announcementID = @id";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@id", announcementId);
                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "Announcement deleted.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                BindGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not delete announcement. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("RowDeleting error: " + ex.Message);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }
    }
}