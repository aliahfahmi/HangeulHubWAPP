using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Admin
{
    public partial class ManageCourses : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        private string SortExpression
        {
            get { return ViewState["SortExpression"] as string ?? "c.courseID ASC"; }
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

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"SELECT c.courseID AS CourseID, c.level AS Level, c.title AS Title,
                                            (SELECT COUNT(*) FROM lessonTable l WHERE l.courseID = c.courseID) AS LessonCount,
                                            (SELECT COUNT(*) FROM quizTable q WHERE q.courseID = c.courseID) AS QuizCount
                                     FROM courseTable c
                                     WHERE (@search = '' OR c.title LIKE '%' + @search + '%')
                                     ORDER BY " + SortExpression;

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@search", search);

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    GridViewCourses.DataSource = dt;
                    GridViewCourses.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not load courses. Please try again later.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("BindGrid error: " + ex.Message);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            GridViewCourses.PageIndex = 0;
            GridViewCourses.EditIndex = -1;
            BindGrid();
        }

        protected void GridViewCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewCourses.EditIndex = -1;
            GridViewCourses.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void GridViewCourses_Sorting(object sender, GridViewSortEventArgs e)
        {
            string column;
            switch (e.SortExpression)
            {
                case "Level": column = "c.level"; break;
                case "Title": column = "c.title"; break;
                case "LessonCount": column = "LessonCount"; break;
                case "QuizCount": column = "QuizCount"; break;
                default: column = "c.courseID"; break;
            }

            bool currentlyAsc = SortExpression == column + " ASC";
            SortExpression = column + (currentlyAsc ? " DESC" : " ASC");

            GridViewCourses.PageIndex = 0;
            GridViewCourses.EditIndex = -1;
            BindGrid();
        }

        protected void btnAddCourse_Click(object sender, EventArgs e)
        {
            string title = txtNewTitle.Text.Trim();

            if (string.IsNullOrEmpty(title))
            {
                lblMessage.Text = "Please enter a course title.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string getIdQuery = @"SELECT ISNULL(MAX(
                        CAST(SUBSTRING(courseID, 2, 10) AS INT)), 0) + 1
                        FROM courseTable";
                    SqlCommand getIdCmd = new SqlCommand(getIdQuery, conn);
                    int nextNumber = Convert.ToInt32(getIdCmd.ExecuteScalar());
                    string newCourseId = "C" + nextNumber.ToString("000");

                    string insert = @"INSERT INTO courseTable (courseID, level, title)
                                       VALUES (@courseID, @level, @title)";
                    SqlCommand cmd = new SqlCommand(insert, conn);
                    cmd.Parameters.AddWithValue("@courseID", newCourseId);
                    cmd.Parameters.AddWithValue("@level", ddlNewLevel.SelectedValue);
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.ExecuteNonQuery();
                }

                txtNewTitle.Text = "";
                lblMessage.Text = "Course added successfully.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                BindGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not add course. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("AddCourse error: " + ex.Message);
            }
        }

        protected void GridViewCourses_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewCourses.EditIndex = e.NewEditIndex;
            BindGrid();
        }

        protected void GridViewCourses_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewCourses.EditIndex = -1;
            BindGrid();
        }

        protected void GridViewCourses_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowIndex == GridViewCourses.EditIndex)
            {
                DataRowView drv = e.Row.DataItem as DataRowView;
                if (drv != null)
                {
                    DropDownList ddlLevel = (DropDownList)e.Row.FindControl("ddlEditLevel");
                    if (ddlLevel != null) ddlLevel.SelectedValue = drv["Level"].ToString();
                }
            }
        }

        protected void GridViewCourses_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GridViewCourses.Rows[e.RowIndex];
                string courseId = GridViewCourses.DataKeys[e.RowIndex].Value.ToString();

                DropDownList ddlLevel = (DropDownList)row.FindControl("ddlEditLevel");
                TextBox txtTitle = (TextBox)row.Cells[2].Controls[0];
                string title = txtTitle.Text.Trim();

                if (string.IsNullOrEmpty(title))
                {
                    lblMessage.Text = "Title cannot be empty.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"UPDATE courseTable
                                      SET level = @level, title = @title
                                      WHERE courseID = @courseId";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@level", ddlLevel.SelectedValue);
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@courseId", courseId);
                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "Course updated successfully.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                GridViewCourses.EditIndex = -1;
                BindGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not save changes. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("RowUpdating error: " + ex.Message);
            }
        }

        protected void GridViewCourses_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                string courseId = GridViewCourses.DataKeys[e.RowIndex].Value.ToString();

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "DELETE FROM courseTable WHERE courseID = @courseId";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@courseId", courseId);
                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "Course deleted.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                BindGrid();
            }
            catch (SqlException)
            {
                lblMessage.Text = "Cannot delete this course - it still has lessons or quizzes linked to it.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not delete course. Please try again.";
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