using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

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

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    // Save user session
                    Session["UserID"] = dr["UserID"].ToString();
                    Session["Name"] = dr["name"].ToString();
                    Session["Email"] = dr["email"].ToString();
                    Session["Role"] = dr["role"].ToString();

                    string role = dr["role"].ToString();

                    switch (role)
                    {
                        case "Student":
                            Response.Redirect("StudentDashboard.aspx");
                            break;

                        case "Instructor":
                            Response.Redirect("InstructorDashboard.aspx");
                            break;

                        case "Admin":
                            Response.Redirect("AdminDashboard.aspx");
                            break;

                        default:
                            lblMessage.Text = "Unknown user role.";
                            break;
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