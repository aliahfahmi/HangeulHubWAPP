using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
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
                                      ORDER BY regdate DESC";

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

                lblMessage.Text = "";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not load users. Please try again later.";
                System.Diagnostics.Debug.WriteLine("BindGrid error: " + ex.Message);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            GridViewUsers.EditIndex = -1;
            BindGrid();
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
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

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"UPDATE userTable
                                      SET name = @name, email = @email, role = @role, stat = @status
                                      WHERE UserID = @userId";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@role", ddlRole.SelectedValue);
                    cmd.Parameters.AddWithValue("@status", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@userId", userId);
                    cmd.ExecuteNonQuery();
                }

                GridViewUsers.EditIndex = -1;
                BindGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Could not save changes. Please try again.";
                System.Diagnostics.Debug.WriteLine("RowUpdating error: " + ex.Message);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }
    }
}
