<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="HangeulHubWAPP.Student.StudentDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Student Dashboard - HangeulHub</title>

    <!-- Google Font (Poppins) - loaded directly, no custom.css used -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome, for the small icons (book, pencil, trophy, forum) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <style>


        /* ================================
           COLOUR SETTINGS (change here to re-theme the whole page)
           ================================ */
        /*
            Background color   : #f4f4fc  (light lavender, same tone as Home.aspx)
            Purple accent color: #7c5cfc  (used for headings, icons, buttons)
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
           TOP BAR (title + account + logout buttons)
           ================================ */
        .dashboard-topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 25px 50px;
            background: white;
        }

        .topbar-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .dashboard-topbar h2 {
            color: #222222;                   /* <-- title text color */
            font-weight: 700;
        }

        .account-btn {
            color: #7c5cfc;                   /* <-- account settings link color */
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
        }

        .account-btn:hover {
            text-decoration: underline;
        }

        .logout-btn {
            background: #6C63FF;
            color: white;
            border: none;
            border-radius: 10px;
            padding: 12px 24px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .logout-btn:hover {
            background: #574fd6;
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
            color: #222222;                   /* <-- "Welcome" text color */
        }

        .welcome-text h1 span {
            color: #7c5cfc;                   /* <-- accent purple word color */
        }

        .welcome-text p {
            margin-top: 8px;
            font-size: 15px;
            color: #666666;                   /* <-- subtitle text color */
        }


        /* ================================
           FUNCTION CARDS (Learning / Quiz / Leaderboard / Forum)
           ================================ */
        .card-row {
            display: flex;
            flex-wrap: nowrap;
            justify-content: center;
            overflow-x: auto;
            overflow-y: visible;
            gap: 25px;
            padding: 20px 10px 30px 10px;
            width: 100%;
        }

        .dash-card {
            flex: 0 0 220px;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;

            background-color: #ffffff;        /* <-- card background color */
            border-radius: 12px;
            padding: 30px 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.15s ease;
        }

        .dash-card:hover {
            transform: translateY(-4px);
        }

        .dash-card i {
            font-size: 32px;
            margin-bottom: 14px;
            color: #7c5cfc;                   /* <-- icon color */
        }

        .dash-card h4 {
            font-size: 16px;
            font-weight: 700;
            color: #222222;                   /* <-- card title color */
            margin-bottom: 8px;
        }

        .dash-card p {
            font-size: 13px;
            color: #666666;                   /* <-- card description color */
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-actions {
            display: flex;
            gap: 15px;
        }


    </style>
</head>

<body>

    <form id="form1" runat="server">
        <!-- TOP BAR -->
        <div class="dashboard-topbar">

            <h2>Student Dashboard</h2>

            <div class="topbar-actions">

                <asp:HyperLink
                    ID="lnkAccount"
                    runat="server"
                    NavigateUrl="~/Account/EditProfile.aspx"
                    CssClass="account-btn">
                    ⚙ Account Settings
                </asp:HyperLink>

                <asp:Button
                    ID="btnLogout"
                    runat="server"
                    Text="Log Out"
                    CssClass="logout-btn"
                    OnClick="btnLogout_Click" />

            </div>

        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="dashboard-wrapper">

            <!-- Welcome message -->
            <div class="welcome-text">
                <h1>Welcome, <asp:Label ID="name" runat="server" Text="Learner"></asp:Label>!</h1>
                <p>Pick up where you left off and keep learning Korean.</p>
            </div>

            <!-- Function cards (can be scrolled left/right) -->
            <div class="card-row">

                <a href="learningModules.aspx" class="dash-card">
                    <i class="fa fa-book"></i>
                    <h4>Learning Modules</h4>
                    <p>Continue lessons from Beginner to Advanced.</p>
                </a>

                <a href="StudentQuizDashboard.aspx" class="dash-card">
                    <i class="fa fa-pencil"></i>
                    <h4>Attempt Quiz</h4>
                    <p>Test what you've learned so far.</p>
                </a>

                <a href="Leaderboard.aspx" class="dash-card">
                    <i class="fa fa-trophy"></i>
                    <h4>Leaderboard</h4>
                    <p>See how you rank among learners.</p>
                </a>

                <a href="StudentForum.aspx" class="dash-card">
                    <i class="fa fa-comments"></i>
                    <h4>Student Forum</h4>
                    <p>Discuss lessons and ask questions with fellow learners.</p>
                </a>

                <a href="testimonialStudent.aspx" class="dash-card">
                    <i class="fa fa-quote-right"></i>
                    <h4>Share Testimonial</h4>
                    <p>Tell us about your learning experience with HangeulHub.</p>
                </a>

            </div>

        </section>

    </form>
</body>
</html>