<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearningModules.aspx.cs" Inherits="HangeulHubWAPP.Student.LearningModules" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Learning Modules - HangeulHub</title>

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

        .welcome-text { text-align: center; margin-bottom: 20px; }
        .welcome-text h1 { font-size: 30px; font-weight: 800; color: #222222; }
        .welcome-text h1 span { color: #7c5cfc; }
        .welcome-text p { margin-top: 8px; font-size: 15px; color: #666666; }

        .level-badge {
            display: inline-block;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 14px;
            border-radius: 20px;
            background-color: #ece8ff;
            color: #7c5cfc;
            margin-bottom: 15px;
        }

        /* LEVEL FILTER (only shown when student has more than one level) */
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

        /* COURSE TITLE */
        .course-title {
            width: 100%;
            max-width: 700px;
            font-size: 18px;
            font-weight: 700;
            color: #222222;
            margin-bottom: 15px;
        }

        /* LESSON TYPE CARDS */
        .type-row {
            width: 100%;
            max-width: 700px;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }

        .type-card {
            flex: 0 0 200px;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            background-color: #ffffff;
            border-radius: 12px;
            padding: 25px 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            cursor: pointer;
            border: none;
            font-family: 'Poppins', Arial, sans-serif;
            transition: transform 0.15s ease;
        }

        .type-card:hover { transform: translateY(-4px); }

        .type-card.active {
            border: 2px solid #7c5cfc;
        }

        .type-card i {
            font-size: 28px;
            margin-bottom: 10px;
            color: #7c5cfc;
        }

        .type-card span {
            font-size: 14px;
            font-weight: 700;
            color: #222222;
        }

        /* LESSON CONTENT PANEL */
        .lesson-content-box {
            width: 100%;
            max-width: 700px;
            background-color: #ffffff;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }

        .lesson-content-box h4 {
            font-size: 15px;
            font-weight: 700;
            color: #7c5cfc;
            margin-bottom: 10px;
        }

        .lesson-content-box p {
            font-size: 14px;
            color: #333333;
            white-space: pre-line;
        }

        .empty-message {
            text-align: center;
            color: #666666;
            font-size: 14px;
            padding: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="dashboard-topbar">
            <h2>Learning Modules</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <section class="content-wrapper">

            <div class="welcome-text">
                <h1>Your <span>Lessons</span></h1>
                <p>Pick a topic to continue learning.</p>
            </div>

            <!-- Shown only when the student has ONE level - no selection needed -->
            <asp:Label ID="lblLevel" runat="server" CssClass="level-badge" Visible="false"></asp:Label>

            <!-- Shown only when the student has MORE THAN ONE level -->
            <div class="filter-bar" id="divLevelSelect" runat="server" visible="false">
                <label>Select Level:</label>
                <asp:DropDownList ID="ddlLevelSelect" runat="server" CssClass="filter-dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlLevelSelect_SelectedIndexChanged">
                </asp:DropDownList>
            </div>

            <!-- Course title for the selected level -->
            <asp:Label ID="lblCourseTitle" runat="server" CssClass="course-title"></asp:Label>

            <!-- Lesson type cards -->
            <asp:Repeater ID="rptTypes" runat="server" OnItemCommand="rptTypes_ItemCommand">
                <HeaderTemplate><div class="type-row"></HeaderTemplate>
                <ItemTemplate>
                    <asp:LinkButton ID="btnType" runat="server"
                        CssClass='<%# "type-card" + (Eval("type").ToString() == "" + Eval("type") && Eval("type").ToString() == SelectedTypeValue ? " active" : "") %>'
                        CommandName="SelectType"
                        CommandArgument='<%# Eval("type") %>'>
                        <i class="fa fa-bookmark"></i>
                        <span><%# Eval("type") %></span>
                    </asp:LinkButton>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>

            <!-- Lesson content for the selected type -->
            <asp:Repeater ID="rptLessonContent" runat="server">
                <ItemTemplate>
                    <div class="lesson-content-box">
                        <h4><%# Eval("type") %> Lesson</h4>
                        <p><%# Eval("content") %></p>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </section>

    </form>
</body>
</html>