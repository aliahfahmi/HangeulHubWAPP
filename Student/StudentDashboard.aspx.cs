using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP.Student
{
    public partial class StudentDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["UserID"] == null)
            {
                Session["UserID"] = "1";
            }

            // 2. Fetch the name from the DB on first load
            if (!IsPostBack)
            {
                string userId = Session["UserID"].ToString();
                string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

                // Updated query to look for your 'name' column
                string query = "SELECT name FROM userTable WHERE id = @Id";

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", userId);

                        try
                        {
                            conn.Open();
                            object result = cmd.ExecuteScalar();

                            if (result != null)
                            {
                                // 3. Update the dashboard label with the database value
                                name.Text = result.ToString();
                            }
                        }
                        catch (Exception ex)
                        {
                            // Helpful error tracking if a column name or connection misbehaves
                            name.Text = "Error: " + ex.Message;
                        }
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Request.Cookies.Clear();
            Response.Redirect("../Home.aspx");
        }
    }
}