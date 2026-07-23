<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="HangeulHubWAPP.Admin.AdminDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard - HangeulHub</title>

    <!-- Google Font (Poppins) - loaded directly, no custom.css used -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome, for the small icons (users, book, chart, quote, bullhorn) -->
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
           TOP BAR (title + logout button)
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

        .logout-btn {
            padding: 10px 22px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;

            background-color: #7c5cfc;        /* <-- logout button background color */
            color: #ffffff;                   /* <-- logout button text color */
        }

        .logout-btn:hover {
            background-color: #6a4ae0;        /* <-- logout button hover color */
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
           FUNCTION CARDS (Users / Courses / Testimonials / Announcements / Reports)
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

    </style>
</head>

<body>

    <form id="form1" runat="server">

        <!-- TOP BAR -->
        <div class="dashboard-topbar">
            <h2>Admin Dashboard</h2>
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-btn">Log Out</asp:LinkButton>
        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="dashboard-wrapper">

            <!-- Welcome message -->
            <div class="welcome-text">
                <h1>Welcome, <asp:Label ID="name" runat="server" Text="Admin"></asp:Label>!</h1>
                <p>Manage users, content, and platform activity from one place.</p>
            </div>

            <!-- Function cards (can be scrolled left/right) -->
            <div class="card-row">

                <a href="ManageUsers.aspx" class="dash-card">
                    <i class="fa fa-users"></i>
                    <h4>Manage Users</h4>
                    <p>View, edit, or deactivate student and instructor accounts.</p>
                </a>

                <a href="ManageCourses.aspx" class="dash-card">
                    <i class="fa fa-book"></i>
                    <h4>Manage Courses</h4>
                    <p>Oversee lessons and quizzes across all courses.</p>
                </a>

                <a href="Testimonials.aspx" class="dash-card">
                    <i class="fa fa-quote-left"></i>
                    <h4>Testimonials</h4>
                    <p>Approve or reject feedback submitted by students.</p>
                </a>

                <a href="Announcements.aspx" class="dash-card">
                    <i class="fa fa-bullhorn"></i>
                    <h4>Announcements</h4>
                    <p>Post and manage platform-wide announcements.</p>
                </a>

                <a href="Reports.aspx" class="dash-card">
                    <i class="fa fa-bar-chart"></i>
                    <h4>Reports</h4>
                    <p>View platform usage, quiz performance, and activity.</p>
                </a>
            </div>

        </section>

    </form>
</body>
</html>
