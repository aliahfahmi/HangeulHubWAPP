using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using WebGrease.Activities;

namespace HangeulHubWAPP
{
    public partial class Login : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = @"SELECT UserID, name, email, role
                         FROM userTable
                         WHERE email=@email
                         AND pwd=@pwd
                         AND stat='ACTIVE'";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@pwd", txtPassword.Text.Trim());

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    Session["UserID"] = reader["UserID"].ToString();
                    Session["Name"] = reader["name"].ToString();
                    Session["Email"] = reader["email"].ToString();
                    Session["Role"] = reader["role"].ToString();

                    string role = reader["role"].ToString().Trim();

                    if (role.Equals("Student", StringComparison.OrdinalIgnoreCase))
                    {
                        Response.Redirect("~/Student/StudentDashboard.aspx");
                    }
                    else if (role.Equals("Language Instructor", StringComparison.OrdinalIgnoreCase))
                    {
                        Response.Redirect("~/Instructor/InstructorDashboard.aspx");
                    }
                    else if (role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                    {
                        Response.Redirect("~/Admin/AdminDashboard.aspx");
                    }
                    else
                    {
                        lblMessage.Text = "Unknown user role: " + role;
                    }
                }

                else
                {
                    lblMessage.Text = "Invalid email or password.";
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Login.aspx");
        }
    }
}