using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Instructor
{
    public partial class ManageAnnouncements : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

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
                LoadAnnouncements();
            }
        }

        // Loads announcements posted by the logged-in instructor, newest first
        private void LoadAnnouncements()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT announcementID, title, content, datePosted
                                  FROM announcementTable
                                  WHERE instructorID = @instructorID
                                  ORDER BY datePosted DESC";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptAnnouncements.DataSource = dt;
                rptAnnouncements.DataBind();

                pnlEmpty.Visible = dt.Rows.Count == 0;
            }
        }

        // Generates the next announcement ID, e.g. A003 -> A004
        private string GenerateNextAnnouncementID(SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand("SELECT MAX(announcementID) FROM announcementTable", conn);
            object result = cmd.ExecuteScalar();

            int nextNumber = 1;
            if (result != null && result != DBNull.Value)
            {
                string lastID = result.ToString();               // e.g. "A003"
                nextNumber = int.Parse(lastID.Substring(1)) + 1;
            }
            return "A" + nextNumber.ToString("D3");                // "A004"
        }

        protected void btnSaveAnnouncement_Click(object sender, EventArgs e)
        {
            if (txtTitle.Text.Trim() == "" || txtContent.Text.Trim() == "")
            {
                lblModalMessage.Text = "Please fill in both fields.";
                ShowModal();
                return;
            }

            bool isEdit = hfAnnouncementID.Value != "";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd;

                if (isEdit)
                {
                    string query = @"UPDATE announcementTable
                                      SET title = @title, content = @content
                                      WHERE announcementID = @announcementID AND instructorID = @instructorID";
                    cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@announcementID", hfAnnouncementID.Value);
                }
                else
                {
                    string newID = GenerateNextAnnouncementID(conn);
                    string query = @"INSERT INTO announcementTable (announcementID, instructorID, title, content, datePosted)
                                      VALUES (@announcementID, @instructorID, @title, @content, GETDATE())";
                    cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@announcementID", newID);
                }

                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());
                cmd.Parameters.AddWithValue("@title", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@content", txtContent.Text.Trim());

                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Announcement saved.";
            ClearForm();
            LoadAnnouncements();
        }

        protected void rptAnnouncements_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string announcementID = e.CommandArgument.ToString();

            if (e.CommandName == "EditAnnouncement")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM announcementTable WHERE announcementID = @id", conn);
                    cmd.Parameters.AddWithValue("@id", announcementID);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        hfAnnouncementID.Value = dr["announcementID"].ToString();
                        txtTitle.Text = dr["title"].ToString();
                        txtContent.Text = dr["content"].ToString();
                    }
                }
                ShowModal();
            }
            else if (e.CommandName == "DeleteAnnouncement")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM announcementTable WHERE announcementID = @id", conn);
                    cmd.Parameters.AddWithValue("@id", announcementID);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "Announcement deleted.";
                LoadAnnouncements();
            }
        }

        private void ClearForm()
        {
            hfAnnouncementID.Value = "";
            txtTitle.Text = "";
            txtContent.Text = "";
            lblModalMessage.Text = "";
        }

        private void ShowModal()
        {
            ClientScript.RegisterStartupScript(this.GetType(), "openModal", "openAnnouncementModal();", true);
        }
    }
}