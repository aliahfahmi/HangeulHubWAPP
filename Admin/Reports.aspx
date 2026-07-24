<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="HangeulHubWAPP.Admin.Reports" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reports - HangeulHub</title>

    <!-- Google Font (Poppins) - loaded directly, no custom.css used -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome, for the small icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <style>

        /* ================================
           COLOUR SETTINGS (same palette as ManageUsers.aspx / ManageCourses.aspx)
           ================================ */
        /*
            Background color   : #f4f4fc  (light lavender)
            Purple accent color: #7c5cfc
            Dark text color    : #222222
            Grey text color    : #666666
            White (cards/topbar): #ffffff
        */


        /* ================================
           BASIC PAGE SETTINGS
           ================================ */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', Arial, sans-serif;   /* <-- change font here */
            background-color: #f4f4fc;                   /* <-- page background color */
            color: #222222;                               /* <-- default text color */
        }


        /* ================================
           TOP BAR (title + back button)
           ================================ */
        .dashboard-topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 40px;

            background-color: #ffffff;        /* <-- top bar background color */
        }

        .dashboard-topbar h2 {
            color: #222222;                   /* <-- title text color */
            font-weight: 700;
        }

        .back-btn {
            padding: 10px 22px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;

            background-color: #7c5cfc;        /* <-- back button background color */
            color: #ffffff;                   /* <-- back button text color */
        }

        .back-btn:hover {
            background-color: #6a4ae0;        /* <-- back button hover color */
        }


        /* ================================
           WELCOME SECTION
           ================================ */
        .dashboard-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;

            padding-top: 30px;
            padding-bottom: 40px;
            min-height: 150vh;   /* makes page tall enough to scroll down */
        }

        .welcome-text {
            text-align: center;
            margin-bottom: 25px;
        }

        .welcome-text h1 {
            font-size: 34px;
            font-weight: 800;
            color: #7c5cfc;                   /* <-- heading text color */
        }

        .welcome-text p {
            margin-top: 8px;
            font-size: 15px;
            color: #666666;                   /* <-- subtitle text color */
        }


        /* ================================
           STAT CARDS
           ================================ */
        .stat-row {
            display: flex;
            flex-wrap: nowrap;
            justify-content: center;
            overflow-x: auto;
            overflow-y: visible;
            gap: 20px;
            padding: 4px 10px 30px 10px;
            width: 100%;
            max-width: 1100px;
        }

        .stat-card {
            flex: 0 0 160px;
            text-align: center;
            background-color: #ffffff;        /* <-- stat card background color */
            border-radius: 12px;
            padding: 22px 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .stat-card .stat-number {
            font-size: 28px;
            font-weight: 800;
            color: #7c5cfc;                   /* <-- stat number color */
        }

        .stat-card .stat-label {
            margin-top: 6px;
            font-size: 13px;
            color: #666666;                   /* <-- stat label color */
        }


        /* ================================
           SECTION HEADINGS
           ================================ */
        .section-heading {
            width: 100%;
            max-width: 1000px;
            margin: 10px 0 14px 0;
            font-size: 18px;
            font-weight: 700;
            color: #222222;
        }


        /* ================================
           REPORT TABLES (GridView)
           ================================ */
        .report-table {
            width: 100%;
            max-width: 1000px;
            border-collapse: collapse;
            margin-bottom: 34px;

            background-color: #ffffff;        /* <-- table background color */
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .report-table th {
            background-color: #7c5cfc;        /* <-- table header background color */
            color: #ffffff;                   /* <-- table header text color */
            font-weight: 700;
            font-size: 14px;
            padding: 14px 18px;
            text-align: left;
        }

        .report-table td {
            padding: 14px 18px;
            font-size: 14px;
            color: #222222;                   /* <-- table cell text color */
            border-bottom: 1px solid #eeeeee;
        }

        .report-table tr:last-child td {
            border-bottom: none;
        }

        .report-table tr:hover td {
            background-color: #f7f5ff;        /* <-- row hover color */
        }

        .empty-row {
            text-align: center;
            padding: 30px 18px;
            color: #999999;
            font-size: 14px;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- TOP BAR -->
        <div class="dashboard-topbar">
            <h2>Reports</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="dashboard-wrapper">

            <!-- Heading -->
            <div class="welcome-text">
                <h1>Platform Reports</h1>
                <p>An overview of platform usage, quiz performance, and activity.</p>
            </div>

            <!-- Stat cards -->
            <div class="stat-row">
                <div class="stat-card">
                    <div class="stat-number"><asp:Literal ID="litTotalUsers" runat="server" /></div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Literal ID="litActiveUsers" runat="server" /></div>
                    <div class="stat-label">Active Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Literal ID="litStudents" runat="server" /></div>
                    <div class="stat-label">Students</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Literal ID="litInstructors" runat="server" /></div>
                    <div class="stat-label">Instructors</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Literal ID="litTotalCourses" runat="server" /></div>
                    <div class="stat-label">Courses</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Literal ID="litTotalQuizzes" runat="server" /></div>
                    <div class="stat-label">Quizzes</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Literal ID="litTotalAttempts" runat="server" /></div>
                    <div class="stat-label">Quiz Attempts</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Literal ID="litAvgScore" runat="server" /></div>
                    <div class="stat-label">Avg Quiz Score</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Literal ID="litPendingTestimonials" runat="server" /></div>
                    <div class="stat-label">Pending Testimonials</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Literal ID="litPendingForum" runat="server" /></div>
                    <div class="stat-label">Unanswered Forum Qs</div>
                </div>
            </div>

            <!-- Quiz performance -->
            <div class="section-heading">Quiz Performance</div>
            <asp:GridView ID="GridViewQuizPerformance" runat="server"
                CssClass="report-table"
                AutoGenerateColumns="false"
                GridLines="None">
                <Columns>
                    <asp:BoundField DataField="QuizID" HeaderText="Quiz ID" />
                    <asp:BoundField DataField="Title" HeaderText="Quiz" />
                    <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                    <asp:BoundField DataField="Attempts" HeaderText="Attempts" />
                    <asp:BoundField DataField="AvgScore" HeaderText="Avg Score" DataFormatString="{0:0.0}" />
                    <asp:BoundField DataField="PassingScore" HeaderText="Passing Score" />
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-row">No quizzes found.</div>
                </EmptyDataTemplate>
            </asp:GridView>

            <!-- Top students -->
            <div class="section-heading">Top Students (Leaderboard)</div>
            <asp:GridView ID="GridViewTopStudents" runat="server"
                CssClass="report-table"
                AutoGenerateColumns="false"
                GridLines="None">
                <Columns>
                    <asp:BoundField DataField="Rank" HeaderText="Rank" />
                    <asp:BoundField DataField="StudentName" HeaderText="Student" />
                    <asp:BoundField DataField="TotalScore" HeaderText="Total Score" />
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-row">No leaderboard data yet.</div>
                </EmptyDataTemplate>
            </asp:GridView>

        </section>

    </form>
</body>
</html>
