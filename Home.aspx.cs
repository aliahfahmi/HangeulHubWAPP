using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HangeulHubWAPP
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTestimonials();
            }
        }

        private void LoadTestimonials()
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
        SELECT
            t.testimonialID,
            t.content,
            u.name AS studentName
        FROM testimonialTable t
        INNER JOIN userTable u
            ON t.studentID = u.userID
        WHERE t.appstat='APPROVED'
        ORDER BY t.testimonialID DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);

                DataTable dt = new DataTable();

                da.Fill(dt);

                rptTestimonials.DataSource = dt;
                rptTestimonials.DataBind();
            }
        }
    }
}