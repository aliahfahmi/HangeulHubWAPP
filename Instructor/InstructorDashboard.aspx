<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InstructorDashboard.aspx.cs" Inherits="HangeulHubWAPP.Instructor.InstructorDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Instructor Dashboard - HangeulHub</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', Arial, sans-serif;
            background: #f4f4fc;
            color: #222;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 40px;
            background: white;
        }

        .topbar h2 { font-size: 24px; }

        .logout-btn {
            background: #7c5cfc;
            color: white;
            text-decoration: none;
            padding: 10px 22px;
            border-radius: 8px;
            font-weight: 600;
        }

        .logout-btn:hover { background: #6847e8; }

        .wrapper {
            max-width: 1200px;
            margin: auto;
            padding: 35px 25px 50px;
        }

        .welcome {
            text-align: center;
            margin-bottom: 30px;
        }

        .welcome h1 {
            font-size: 32px;
            font-weight: 800;
        }

        .welcome span { color: #7c5cfc; }

        .welcome p {
            color: #666;
            margin-top: 8px;
        }

        .stats-row, .action-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card, .action-card, .questions-box {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .stat-card {
            padding: 24px;
            text-align: center;
            border-top: 5px solid #7c5cfc;
        }

        .stat-card i {
            color: #7c5cfc;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .stat-card h3 {
            font-size: 28px;
            color: #222;
        }

        .stat-card p {
            color: #666;
            font-size: 14px;
        }

        .section-title {
            font-size: 21px;
            margin: 15px 0;
        }

        .action-card {
            text-decoration: none;
            color: #222;
            padding: 28px 20px;
            text-align: center;
            transition: 0.2s;
        }

        .action-card:hover {
            transform: translateY(-5px);
        }

        .action-card i {
            color: #7c5cfc;
            font-size: 32px;
            margin-bottom: 12px;
        }

        .action-card h4 { margin-bottom: 7px; }

        .action-card p {
            color: #666;
            font-size: 13px;
        }

        .questions-box {
            padding: 25px;
        }

        .question-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .question-grid th {
            background: #7c5cfc;
            color: white;
            padding: 12px;
            text-align: left;
        }

        .question-grid td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            color: #555;
        }

        @media (max-width: 600px) {
            .topbar { padding: 16px 20px; }
            .topbar h2 { font-size: 18px; }
            .welcome h1 { font-size: 25px; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <div class="topbar">
        <h2>Instructor Dashboard</h2>
        <asp:LinkButton ID="btnLogout" runat="server"
            OnClick="btnLogout_Click" CssClass="logout-btn">Log Out</asp:LinkButton>
    </div>

    <main class="wrapper">

        <div class="welcome">
            <h1>Welcome back, <span><asp:Label ID="lblInstructorName" runat="server" Text="Instructor"></asp:Label></span>!</h1>
            <p>Manage Korean learning content and support your students.</p>
        </div>

        <div class="stats-row">
            <div class="stat-card">
                <i class="fa fa-book"></i>
                <h3><asp:Label ID="lblTotalLessons" runat="server" Text="0"></asp:Label></h3>
                <p>Total Lessons</p>
            </div>

            <div class="stat-card">
                <i class="fa fa-question-circle"></i>
                <h3><asp:Label ID="lblOpenQuestions" runat="server" Text="0"></asp:Label></h3>
                <p>Open Forum Questions</p>
            </div>

            <div class="stat-card">
                <i class="fa fa-seedling"></i>
                <h3><asp:Label ID="lblBeginner" runat="server" Text="0"></asp:Label></h3>
                <p>Beginner Lessons</p>
            </div>

            <div class="stat-card">
                <i class="fa fa-graduation-cap"></i>
                <h3><asp:Label ID="lblIntermediateAdvanced" runat="server" Text="0"></asp:Label></h3>
                <p>Intermediate & Advanced Lessons</p>
            </div>
        </div>

        <h3 class="section-title">Instructor Actions</h3>

        <div class="action-row">
            <a href="ManageLessons.aspx" class="action-card">
                <i class="fa fa-book"></i>
                <h4>Manage Lessons</h4>
                <p>Add, edit, or remove Hangul, vocabulary, and grammar lessons.</p>
            </a>

            <a href="ManageForum.aspx" class="action-card">
                <i class="fa fa-comments"></i>
                <h4>Student Forum</h4>
                <p>Read student questions and send helpful replies.</p>
            </a>

            <a href="#" class="action-card">
                <i class="fa fa-pencil-square-o"></i>
                <h4>Manage Quizzes</h4>
                <p>Create and update quizzes for each course level.</p>
            </a>

            <a href="#" class="action-card">
                <i class="fa fa-bullhorn"></i>
                <h4>Announcements</h4>
                <p>Post updates about lessons and assessments.</p>
            </a>
        </div>

        <div class="questions-box">
            <h3 class="section-title">Recent Student Questions</h3>

            <asp:GridView ID="gvRecentQuestions" runat="server"
                AutoGenerateColumns="False" CssClass="question-grid"
                GridLines="None">
                <Columns>
                    <asp:BoundField DataField="Question" HeaderText="Question" />
                    <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                </Columns>
            </asp:GridView>
        </div>

    </main>
</form>
</body>
</html>