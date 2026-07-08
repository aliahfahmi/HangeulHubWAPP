<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="HangeulHubWAPP.Student.StudentDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Student Dashboard - HangeulHub</title>
    <link href="../assets/css/custom.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <style>
        html, body { margin: 0; }

        .dashboard-topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 40px;
        }

        .dashboard-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            padding-top: 20px;
            padding-bottom: 40px;
            min-height: 150vh;
        }

        .dashboard-wrapper .hero-center {
            margin-bottom: 15px;
        }

        .dashboard-wrapper.hero-section {
        padding-top: 20px;
        }


        .dashboard-wrapper .container {
            width: 100%;
        }

        /* Horizontal, centered, scrollable row for the function cards */
        .feature-grid.horizontal-scroll {
            display: flex;
            flex-wrap: nowrap;
            justify-content: center;
            overflow-x: auto;
            overflow-y: visible;
            gap: 25px;
            padding: 10px 10px 20px 10px;
            margin-top: 0;
            scroll-behavior: smooth;
        }

        .feature-grid.horizontal-scroll .feature-card {
            flex: 0 0 220px;
            text-decoration: none;
            display: block;
        }

        .feature-grid.horizontal-scroll::-webkit-scrollbar {
            height: 6px;
        }
        .feature-grid.horizontal-scroll::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.5);
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="dashboard-topbar">
            <h2>Student Dashboard</h2>
            <a href="../Home.aspx" class="btn-secondary-custom">Log Out</a>
        </div>

        <section class="hero-section dashboard-wrapper">
            <div class="container">

                <div class="hero-center">
                    <h1>Welcome Back</h1>
                    <p>Pick up where you left off.</p>
                </div>

                <div class="feature-grid horizontal-scroll">

                    <a href="LearningModules.aspx" class="feature-card">
                        <i class="fa fa-book"></i>
                        <h4>Learning Modules</h4>
                        <p>Continue lessons from Beginner to Advanced.</p>
                    </a>

                    <a href="Quiz.aspx" class="feature-card">
                        <i class="fa fa-pencil"></i>
                        <h4>Attempt Quiz</h4>
                        <p>Test what you've learned so far.</p>
                    </a>

                    <a href="Leaderboard.aspx" class="feature-card">
                        <i class="fa fa-trophy"></i>
                        <h4>Leaderboard</h4>
                        <p>See how you rank among learners.</p>
                    </a>

                </div>

            </div>
        </section>

    </form>
</body>
</html>