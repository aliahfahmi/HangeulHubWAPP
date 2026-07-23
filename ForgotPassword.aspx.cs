using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (txtNewPassword.Text != txtConfirmPassword.Text)
            {
                lblMessage.Text = "Passwords do not match.";
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string checkQuery = "SELECT COUNT(*) FROM userTable WHERE email=@email";

                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);

                checkCmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());

                int count = (int)checkCmd.ExecuteScalar();

                if (count == 0)
                {
                    lblMessage.Text = "Email does not exist.";
                    return;
                }

                string updateQuery = @"UPDATE userTable
                                       SET pwd=@pwd
                                       WHERE email=@email";

                SqlCommand updateCmd = new SqlCommand(updateQuery, conn);

                updateCmd.Parameters.AddWithValue("@pwd", txtNewPassword.Text.Trim());
                updateCmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());

                updateCmd.ExecuteNonQuery();

                lblMessage.CssClass = "msg success";
                lblMessage.Text = "Password updated successfully.";

                Response.AddHeader("REFRESH", "2;URL=Login.aspx");
            }
        }
    }
}