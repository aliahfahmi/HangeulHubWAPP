<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentQuizDashboard.aspx.cs" Inherits="HangeulHubWAPP.Student.StudentQuizDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quiz Dashboard - HangeulHub</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', Arial, sans-serif;
            background-color: #f4f4fc;
            color: #222222;
        }

        /* TOP BAR */
        .dashboard-topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 40px;
            background-color: #ffffff;
        }

        .dashboard-topbar h2 { color: #222222; font-weight: 700; }

        .back-btn {
            padding: 10px 22px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;
            background-color: #7c5cfc;
            color: #ffffff;
        }

        .back-btn:hover { background-color: #6a4ae0; }

        /* PAGE CONTENT */
        .content-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 30px 20px 60px 20px;
        }

        .welcome-text { text-align: center; margin-bottom: 30px; }

        .welcome-text h1 { font-size: 30px; font-weight: 800; color: #222222; }
        .welcome-text h1 span { color: #7c5cfc; }
        .welcome-text p { margin-top: 8px; font-size: 15px; color: #666666; }

        /* QUIZ LIST */
        .quiz-list {
            width: 100%;
            max-width: 700px;
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .quiz-card {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 20px 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .quiz-card-info h4 {
            font-size: 16px;
            font-weight: 700;
            color: #222222;
            margin-bottom: 6px;
        }

        .level-badge {
            display: inline-block;
            font-size: 11px;
            font-weight: 600;
            padding: 3px 10px;
            border-radius: 20px;
            background-color: #ece8ff;
            color: #7c5cfc;
            margin-bottom: 8px;
        }

        .quiz-card-info p {
            font-size: 13px;
            color: #666666;
        }

        .quiz-card-action {
            text-align: right;
        }

        .best-score {
            font-size: 13px;
            color: #666666;
            margin-bottom: 8px;
        }

        .best-score strong { color: #7c5cfc; }

        .start-btn {
            padding: 10px 24px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 700;
            font-size: 14px;
            background-color: #7c5cfc;
            color: #ffffff;
            text-decoration: none;
            display: inline-block;
        }

        .start-btn:hover { background-color: #6a4ae0; }

        .start-btn.disabled {
            background-color: #cccccc;
            cursor: not-allowed;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="dashboard-topbar">
            <h2>Quiz Dashboard</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <section class="content-wrapper">

            <div class="welcome-text">
                <h1>Choose a <span>Quiz</span></h1>
                <p>Pick a quiz to test your Korean knowledge.</p>
            </div>

            <div class="quiz-list">
                <asp:Repeater ID="rptQuizzes" runat="server" OnItemDataBound="rptQuizzes_ItemDataBound" OnItemCommand="rptQuizzes_ItemCommand">
                    <ItemTemplate>
                        <div class="quiz-card">
                            <div class="quiz-card-info">
                                <div class="level-badge"><%# Eval("diffLevel") %></div>
                                <h4><%# Eval("title") %></h4>
                                <p>
                                    Time Limit: <%# Eval("timelimit") %> min &nbsp;|&nbsp;
                                    Passing Score: <%# Eval("passingScore") %>%
                                </p>
                            </div>
                            <div class="quiz-card-action">
                                <div class="best-score" runat="server" id="divBestScore">
                                    Attempts: <%# Eval("attemptsUsed") %>/3
                                </div>
                                <asp:HyperLink ID="lnkStart" runat="server" CssClass="start-btn">Start Quiz</asp:HyperLink>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

        </section>

    </form>
</body>
</html>