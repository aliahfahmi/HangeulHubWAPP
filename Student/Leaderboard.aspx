<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Leaderboard.aspx.cs" Inherits="HangeulHubWAPP.Student.Leaderboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Leaderboard - HangeulHub</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', Arial, sans-serif;
            background-color: #f4f4fc;
            color: #222222;
        }

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

        .content-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 30px 20px 60px 20px;
        }

        .welcome-text { text-align: center; margin-bottom: 20px; }
        .welcome-text h1 { font-size: 30px; font-weight: 800; color: #222222; }
        .welcome-text h1 span { color: #7c5cfc; }
        .welcome-text p { margin-top: 8px; font-size: 15px; color: #666666; }

        .filter-bar {
            width: 100%;
            max-width: 700px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .filter-bar label { font-size: 14px; color: #666666; font-weight: 600; }

        .filter-dropdown {
            padding: 8px 12px;
            border: 1px solid #dddddd;
            border-radius: 6px;
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            background-color: #ffffff;
            color: #222222;
        }

        .leaderboard-table {
            width: 100%;
            max-width: 700px;
            border-collapse: collapse;
            background-color: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .leaderboard-table th {
            background-color: #7c5cfc;
            color: #ffffff;
            font-weight: 700;
            font-size: 14px;
            padding: 14px 18px;
            text-align: left;
        }

        .leaderboard-table td {
            padding: 14px 18px;
            font-size: 14px;
            color: #222222;
            border-bottom: 1px solid #eeeeee;
        }

        .leaderboard-table tr:last-child td { border-bottom: none; }
        .leaderboard-table tr:hover td { background-color: #f7f5ff; }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="dashboard-topbar">
            <h2>Leaderboard</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <section class="content-wrapper">

            <div class="welcome-text">
                <h1>Top <span>Learners</span></h1>
                <p>See how you rank among students at the same level.</p>
            </div>

            <div class="filter-bar">
                <label>Level:</label>
                <asp:DropDownList ID="ddlLevelFilter" runat="server" CssClass="filter-dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlLevelFilter_SelectedIndexChanged">
                    <asp:ListItem Text="Beginner" Value="Beginner" />
                    <asp:ListItem Text="Intermediate" Value="Intermediate" />
                    <asp:ListItem Text="Advanced" Value="Advanced" />
                </asp:DropDownList>
            </div>

            <asp:GridView ID="GridViewLeaderboard" runat="server"
                CssClass="leaderboard-table"
                AutoGenerateColumns="false"
                GridLines="None"
                OnSelectedIndexChanged="GridViewLeaderboard_SelectedIndexChanged">
                <Columns>
                    <asp:BoundField DataField="rank" HeaderText="Rank" />
                    <asp:BoundField DataField="name" HeaderText="Student" />
                    <asp:BoundField DataField="totalScore" HeaderText="Total Score" />
                </Columns>
            </asp:GridView>

        </section>

    </form>
</body>
</html>