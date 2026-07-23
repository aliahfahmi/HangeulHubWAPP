using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Account
{
    public partial class EditProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadProfile();
            }

        }
        private void LoadProfile()
        {
            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(
                @"SELECT UserID,
                 name,
                 email,
                 pwd,
                 role,
                 profilepic,
                 stat
          FROM userTable
          WHERE UserID=@UserID", con);

                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    lblProfileName.Text = reader["name"].ToString();

                    txtUserID.Text = reader["UserID"].ToString();
                    txtName.Text = reader["name"].ToString();
                    txtEmail.Text = reader["email"].ToString();
                    txtPassword.Attributes["value"] = reader["pwd"].ToString();
                    txtRole.Text = reader["role"].ToString();
                    txtStatus.Text = reader["stat"].ToString();

                    imgProfile.ImageUrl = "~/assets/profilepic/" + reader["profilepic"].ToString();
                }

                reader.Close();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string picture = imgProfile.ImageUrl.Replace("~/assets/profilepic/", "");

            if (fuProfile.HasFile)
            {
                picture = fuProfile.FileName;

                fuProfile.SaveAs(Server.MapPath("~/assets/profilepic/") + picture);
            }

            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(
                @"UPDATE userTable
          SET
            name=@name,
            email=@email,
            pwd=@pwd,
            profilepic=@profilepic
          WHERE UserID=@UserID", con);

                cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@pwd", txtPassword.Text.Trim());
                cmd.Parameters.AddWithValue("@profilepic", picture);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                cmd.ExecuteNonQuery();

                Session["Name"] = txtName.Text.Trim();
                Session["Email"] = txtEmail.Text.Trim();

                lblMessage.Text = "Profile updated successfully.";

                LoadProfile();
            }
        }


    }
}

    
