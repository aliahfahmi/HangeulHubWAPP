using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(
    ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

            con.Open();

            SqlCommand checkEmail = new SqlCommand(
    "SELECT COUNT(*) FROM userTable WHERE email=@email", con);

            checkEmail.Parameters.AddWithValue("@email", txtEmail.Text.Trim());

            int emailExists = (int)checkEmail.ExecuteScalar();

            if (emailExists > 0)
            {
                lblMessage.Text = "Email already exists.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string role = rblRole.SelectedValue;
            string email = txtEmail.Text.Trim().ToLower();

            if ((role == "Student" && !email.EndsWith("@student.edu")) ||
                (role == "Language Instructor" && !email.EndsWith("@instructor.edu")) ||
                (role == "Admin" && !email.EndsWith("@admin.edu")))
            {
                lblMessage.Text = "Email domain does not match the selected role.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            SqlCommand getLastID = new SqlCommand(
    "SELECT TOP 1 UserID FROM userTable ORDER BY UserID DESC", con);

            string lastID = Convert.ToString(getLastID.ExecuteScalar());

            string userID;

            if (string.IsNullOrEmpty(lastID))
            {
                userID = "U001";
            }
            else
            {
                int number = int.Parse(lastID.Substring(1));
                userID = "U" + (number + 1).ToString("D3");
            }

            string fileName = "default.png";

            if (fuProfile.HasFile)
            {
                fileName = Path.GetFileName(fuProfile.FileName);

                fuProfile.SaveAs(
                    Server.MapPath("~/assets/profilepic/") + fileName);
            }

            SqlCommand cmd = new SqlCommand(@"
                INSERT INTO userTable
                (UserID, email, name, pwd, role, profilepic, stat, regdate)
                VALUES
                (@UserID, @Email, @Name, @Password, @Role, @ProfilePic, @Status, @RegDate)", con);

            cmd.Parameters.AddWithValue("@UserID", userID);
            cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());   // Username = Email
            cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
            cmd.Parameters.AddWithValue("@Password", txtPassword.Text);
            cmd.Parameters.AddWithValue("@Role", role);
            cmd.Parameters.AddWithValue("@ProfilePic", fileName);
            cmd.Parameters.AddWithValue("@Status", "ACTIVE");
            cmd.Parameters.AddWithValue("@RegDate", DateTime.Now);

            cmd.ExecuteNonQuery();

            lblMessage.Text = "Registration Successful!";
            lblMessage.ForeColor = System.Drawing.Color.Green;

            con.Close();
        }
    }
}