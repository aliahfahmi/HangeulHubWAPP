using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Instructor
{
    public partial class ManageForum : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        // Remembers which filter button is active across postbacks (Visible/CssClass
        // aren't automatically remembered by ASP.NET, so we track it ourselves)
        private string CurrentFilter
        {
            get { return ViewState["ForumFilter"] as string ?? "All"; }
            set { ViewState["ForumFilter"] = value; }
        }

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
                LoadForumPosts();
            }
        }

        // Loads every forum question addressed to this instructor (lecturerID),
        // joined with userTable so we can show the student's name instead of a
        // raw ID. Open questions are shown first so nothing gets missed.
        private void LoadForumPosts()
        {
            string query = @"SELECT f.ForumID, u.name AS studentName, f.questionText,
                                     f.questionDate, f.responseText, f.responseDate, f.stat
                              FROM forumTable f
                              JOIN userTable u ON f.studentID = u.UserID
                              WHERE f.lecturerID = @instructorID";

            if (CurrentFilter == "Open")
                query += " AND f.stat = 'Open'";
            else if (CurrentFilter == "Answered")
                query += " AND f.stat = 'Answered'";

            query += " ORDER BY CASE WHEN f.stat = 'Open' THEN 0 ELSE 1 END, f.questionDate DESC";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptForum.DataSource = dt;
                rptForum.DataBind();

                pnlEmpty.Visible = dt.Rows.Count == 0;
            }

            UpdateFilterButtonStyles();
        }

        // Highlights whichever filter button is currently selected
        private void UpdateFilterButtonStyles()
        {
            btnFilterAll.CssClass = "filter-btn" + (CurrentFilter == "All" ? " active" : "");
            btnFilterOpen.CssClass = "filter-btn" + (CurrentFilter == "Open" ? " active" : "");
            btnFilterAnswered.CssClass = "filter-btn" + (CurrentFilter == "Answered" ? " active" : "");
        }

        protected void Filter_Click(object sender, EventArgs e)
        {
            LinkButton clicked = (LinkButton)sender;
            CurrentFilter = clicked.CommandArgument;
            LoadForumPosts();
        }

        // Fired when "Reply" or "Edit Reply" is clicked on a question card
        protected void rptForum_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "Reply") return;

            string forumID = e.CommandArgument.ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT questionText, responseText FROM forumTable WHERE ForumID = @id AND lecturerID = @instructorID", conn);
                cmd.Parameters.AddWithValue("@id", forumID);
                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    hfForumID.Value = forumID;
                    modalQuestionText.InnerText = "Q: " + dr["questionText"].ToString();
                    // Pre-fill the textbox with the existing response if we're editing one
                    txtReply.Text = dr["responseText"] == DBNull.Value ? "" : dr["responseText"].ToString();
                }
            }

            ShowReplyModal();
        }

        // Saves the instructor's reply - sets responseText, responseDate, and
        // flips stat to 'Answered' so the badge and filter update automatically.
        protected void btnSubmitReply_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtReply.Text))
            {
                lblModalMessage.Text = "Please write a response before sending.";
                ShowReplyModal();
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"UPDATE forumTable
                                  SET responseText = @responseText, responseDate = GETDATE(), stat = 'Answered'
                                  WHERE ForumID = @id AND lecturerID = @instructorID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@responseText", txtReply.Text.Trim());
                cmd.Parameters.AddWithValue("@id", hfForumID.Value);
                cmd.Parameters.AddWithValue("@instructorID", Session["UserID"].ToString());

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Reply sent! Your student has been notified.";
            hfForumID.Value = "";
            txtReply.Text = "";
            lblModalMessage.Text = "";
            LoadForumPosts();
        }

        private void ShowReplyModal()
        {
            ClientScript.RegisterStartupScript(this.GetType(), "openReplyModal", "openReplyModal();", true);
        }
    }
}