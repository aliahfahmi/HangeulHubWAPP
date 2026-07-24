using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        private string SortExpression
        {
            get { return ViewState["SortExpression"] as string ?? "regdate DESC"; }
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
                string role = ddlRoleFilter.SelectedValue;
                string status = ddlStatusFilter.SelectedValue;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"SELECT UserID, name AS Name, email AS Email, role AS Role,
                                             stat AS Status, regdate AS RegisteredDate
                                      FROM userTable
                                      WHERE (@search = '' OR name LIKE '%' + @search + '%' OR email LIKE '%' + @search + '%')
                                        AND (@role = '' OR role = @role)
                                        AND (@status = '' OR stat = @status)
                                      ORDER BY " + SortExpression;

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@search", search);
                    cmd.Parameters.AddWithValue("@role", role);
                    cmd.Parameters.AddWithValue("@status", status);

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    GridViewUsers.DataSource = dt;
                    GridViewUsers.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not load users. Please try again later.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("BindGrid error: " + ex.Message);
            }
        }

        private bool IsValidEmail(string email)
        {
            return Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$");
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            GridViewUsers.PageIndex = 0;
            GridViewUsers.EditIndex = -1;
            BindGrid();
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            GridViewUsers.PageIndex = 0;
            GridViewUsers.EditIndex = -1;
            BindGrid();
        }

        protected void GridViewUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewUsers.EditIndex = -1;
            GridViewUsers.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void GridViewUsers_Sorting(object sender, GridViewSortEventArgs e)
        {
            string column;
            switch (e.SortExpression)
            {
                case "Name": column = "name"; break;
                case "Email": column = "email"; break;
                case "Role": column = "role"; break;
                case "Status": column = "stat"; break;
                case "RegisteredDate": column = "regdate"; break;
                default: column = "regdate"; break;
            }

            bool currentlyAsc = SortExpression == column + " ASC";
            SortExpression = column + (currentlyAsc ? " DESC" : " ASC");

            GridViewUsers.PageIndex = 0;
            GridViewUsers.EditIndex = -1;
            BindGrid();
        }

        protected void GridViewUsers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewUsers.EditIndex = e.NewEditIndex;
            BindGrid();
        }

        protected void GridViewUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewUsers.EditIndex = -1;
            BindGrid();
        }

        protected void GridViewUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowIndex == GridViewUsers.EditIndex)
            {
                DataRowView drv = e.Row.DataItem as DataRowView;
                if (drv != null)
                {
                    DropDownList ddlRole = (DropDownList)e.Row.FindControl("ddlEditRole");
                    DropDownList ddlStatus = (DropDownList)e.Row.FindControl("ddlEditStatus");

                    if (ddlRole != null) ddlRole.SelectedValue = drv["Role"].ToString();
                    if (ddlStatus != null) ddlStatus.SelectedValue = drv["Status"].ToString();
                }
            }
        }

        protected void GridViewUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GridViewUsers.Rows[e.RowIndex];
                string userId = GridViewUsers.DataKeys[e.RowIndex].Value.ToString();

                TextBox txtName = (TextBox)row.Cells[1].Controls[0];
                TextBox txtEmail = (TextBox)row.Cells[2].Controls[0];
                DropDownList ddlRole = (DropDownList)row.FindControl("ddlEditRole");
                DropDownList ddlStatus = (DropDownList)row.FindControl("ddlEditStatus");

                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();

                if (string.IsNullOrEmpty(name))
                {
                    lblMessage.Text = "Name cannot be empty.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                if (!IsValidEmail(email))
                {
                    lblMessage.Text = "Please enter a valid email address.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"UPDATE userTable
                                      SET name = @name, email = @email, role = @role, stat = @status
                                      WHERE UserID = @userId";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@name", name);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@role", ddlRole.SelectedValue);
                    cmd.Parameters.AddWithValue("@status", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@userId", userId);
                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "User updated successfully.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                GridViewUsers.EditIndex = -1;
                BindGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not save changes. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("RowUpdating error: " + ex.Message);
            }
        }

        private string GenerateNextUserID(SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand("SELECT MAX(UserID) FROM userTable", conn);
            object result = cmd.ExecuteScalar();

            int nextNumber = 1;
            if (result != null && result != DBNull.Value)
            {
                string lastID = result.ToString();
                nextNumber = int.Parse(lastID.Substring(1)) + 1;
            }
            return "U" + nextNumber.ToString("D3");
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            string name = txtNewName.Text.Trim();
            string email = txtNewEmail.Text.Trim();
            string password = txtNewPassword.Text.Trim();

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please fill in name, email, and password.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (!IsValidEmail(email))
            {
                lblMessage.Text = "Please enter a valid email address.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string checkQuery = "SELECT COUNT(*) FROM userTable WHERE email = @email";
                    SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                    checkCmd.Parameters.AddWithValue("@email", email);
                    int existing = (int)checkCmd.ExecuteScalar();

                    if (existing > 0)
                    {
                        lblMessage.Text = "A user with that email already exists.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        return;
                    }

                    string newUserId = GenerateNextUserID(conn);

                    // NOTE: password is stored as plaintext here to stay consistent with
                    // how Login.aspx.cs currently checks passwords (pwd = @pwd, no hashing).
                    // If you add hashing later, Login.aspx.cs must be updated to match,
                    // or existing users (also stored in plaintext) won't be able to log in.
                    string insert = @"INSERT INTO userTable (UserID, name, email, pwd, role, stat, regdate)
                                       VALUES (@id, @name, @email, @pwd, @role, 'ACTIVE', GETDATE())";
                    SqlCommand cmd = new SqlCommand(insert, conn);
                    cmd.Parameters.AddWithValue("@id", newUserId);
                    cmd.Parameters.AddWithValue("@name", name);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@pwd", password);
                    cmd.Parameters.AddWithValue("@role", ddlNewRole.SelectedValue);
                    cmd.ExecuteNonQuery();
                }

                txtNewName.Text = "";
                txtNewEmail.Text = "";
                txtNewPassword.Text = "";
                lblMessage.Text = "User added successfully.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                BindGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not add user. Please try again.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("AddUser error: " + ex.Message);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }
    }
}