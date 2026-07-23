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
    public partial class Courses : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
            }
        }

        private void LoadCourses(string keyword = "", string level = "")
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = @"
SELECT
    l.lessonID,
    c.level,
    c.title,
    l.type,
    l.content
FROM lessonTable l
INNER JOIN courseTable c
ON l.courseID = c.courseID
WHERE
(
    l.lessonID LIKE @keyword OR
    c.title LIKE @keyword OR
    l.type LIKE @keyword OR
    l.content LIKE @keyword
)
AND
(
    @level = '' OR c.level = @level
)
ORDER BY c.level, l.lessonID";

                SqlDataAdapter da = new SqlDataAdapter(query, con);

                da.SelectCommand.Parameters.AddWithValue("@keyword", "%" + keyword + "%");
                da.SelectCommand.Parameters.AddWithValue("@level", level);

                DataTable dt = new DataTable();
                dt.Columns.Add("lessonTitle");

                da.Fill(dt);
                foreach (DataRow row in dt.Rows)
                {
                    switch (row["lessonID"].ToString())
                    {
                        case "L001":
                            row["lessonTitle"] = "Introduction to Hangul";
                            break;

                        case "L002":
                            row["lessonTitle"] = "Reading Syllable Blocks";
                            break;

                        case "L003":
                            row["lessonTitle"] = "Daily Vocabulary";
                            break;

                        case "L004":
                            row["lessonTitle"] = "Basic Grammar Rules";
                            break;

                        case "L005":
                            row["lessonTitle"] = "Daily Routine Vocabulary";
                            break;

                        case "L006":
                            row["lessonTitle"] = "Present Tense";
                            break;

                        case "L007":
                            row["lessonTitle"] = "Honorific Expressions";
                            break;

                        default:
                            row["lessonTitle"] = row["type"] + " Lesson";
                            break;
                    }
                }

                rptCourses.DataSource = dt;
                rptCourses.DataBind();
            }
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Preview")
            {
                string lessonID = e.CommandArgument.ToString();

                using (SqlConnection con = new SqlConnection(conStr))
                {
                    string query = @"
                SELECT
                    l.lessonID,
                    c.level,
                    c.title,
                    l.type,
                    l.content
                FROM lessonTable l
                INNER JOIN courseTable c
                    ON l.courseID = c.courseID
                WHERE l.lessonID = @lessonID";

                    SqlCommand cmd = new SqlCommand(query, con);

                    cmd.Parameters.AddWithValue("@lessonID", lessonID);

                    con.Open();

                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        lblTitle.Text = dr["title"].ToString();
                        lblLevel.Text = dr["level"].ToString();
                        lblType.Text = dr["type"].ToString();
                        lblContent.Text = dr["content"].ToString();

                        pnlPreview.Visible = true;
                    }

                    dr.Close();
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadCourses(txtSearch.Text.Trim());

        }

        protected void btnAll_Click(object sender, EventArgs e)
        {
            LoadCourses(txtSearch.Text.Trim(), "");
        }

        protected void btnBeginner_Click(object sender, EventArgs e)
        {

            LoadCourses(txtSearch.Text.Trim(), "Beginner");
        }

        protected void btnIntermediate_Click(object sender, EventArgs e)
        {
            LoadCourses(txtSearch.Text.Trim(), "Intermediate");
        }

        protected void btnAdvanced_Click(object sender, EventArgs e)
        {
            LoadCourses(txtSearch.Text.Trim(), "Advanced");
        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            pnlPreview.Visible = false;
        }
    }
}