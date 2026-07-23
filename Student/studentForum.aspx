<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentForum.aspx.cs" Inherits="HangeulHubWAPP.Student.StudentForum" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forum - HangeulHub</title>

    <!-- Google Font (Poppins) - loaded directly, no custom.css used -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome, for icons -->
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
           TOP BAR (title + back button)
           ================================ */
        .dashboard-topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 25px 50px;
            background: white;
        }

        .dashboard-topbar h2 {
            color: #222222;                   /* <-- title text color */
            font-weight: 700;
        }

        .back-btn {
            background: #6C63FF;              /* <-- back button background color */
            color: white;                     /* <-- back button text color */
            border: none;
            border-radius: 10px;
            padding: 12px 24px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: 0.3s;
        }

        .back-btn:hover {
            background: #574fd6;              /* <-- back button hover color */
        }


        /* ================================
           PAGE CONTENT
           ================================ */
        .content-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;

            padding: 30px 20px 60px 20px;
        }

        .welcome-text {
            text-align: center;
            margin-bottom: 25px;
        }

        .welcome-text h1 {
            font-size: 30px;
            font-weight: 800;
            color: #222222;                   /* <-- heading text color */
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
           ASK QUESTION BOX
           ================================ */
        .ask-box {
            width: 100%;
            max-width: 650px;

            background-color: #ffffff;        /* <-- ask box background color */
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 35px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .ask-box h4 {
            font-size: 16px;
            font-weight: 700;
            color: #222222;                   /* <-- ask box title color */
            margin-bottom: 12px;
        }

        .ask-box label {
            font-size: 13px;
            color: #666666;                   /* <-- label text color */
            display: block;
            margin-bottom: 6px;
        }

        .ask-dropdown {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #dddddd;
            border-radius: 6px;
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .ask-textbox {
            width: 100%;
            min-height: 90px;
            padding: 10px 12px;
            border: 1px solid #dddddd;
            border-radius: 6px;
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            resize: vertical;
            margin-bottom: 15px;
        }

        .post-btn {
            padding: 12px 30px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 700;
            font-size: 14px;

            background-color: #7c5cfc;        /* <-- post button background color */
            color: #ffffff;                   /* <-- post button text color */
        }

        .post-btn:hover {
            background-color: #6a4ae0;        /* <-- post button hover color */
        }


        /* ================================
           FORUM POST CARD (Repeater item)
           ================================ */
        .post-card {
            width: 100%;
            max-width: 650px;

            background-color: #ffffff;        /* <-- post card background color */
            border-radius: 12px;
            padding: 20px 25px;
            margin-bottom: 18px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .post-card .post-date {
            font-size: 12px;
            color: #999999;                   /* <-- date text color */
            margin-bottom: 8px;
        }

        .post-card .post-question {
            font-size: 15px;
            color: #222222;                   /* <-- question text color */
            margin-bottom: 12px;
        }

        .post-card .post-status {
            display: inline-block;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
            margin-bottom: 12px;
        }

        .status-pending {
            background-color: #fff3cd;        /* <-- "Pending" badge background */
            color: #997404;                   /* <-- "Pending" badge text color */
        }

        .status-answered {
            background-color: #d4edda;        /* <-- "Answered" badge background */
            color: #276749;                   /* <-- "Answered" badge text color */
        }

        .post-card .post-response-box {
            background-color: #f7f5ff;        /* <-- response box background color */
            border-left: 3px solid #7c5cfc;   /* <-- response box accent border color */
            padding: 12px 15px;
            border-radius: 6px;
            font-size: 14px;
            color: #333333;                   /* <-- response text color */
        }

        .post-card .response-label {
            font-size: 12px;
            font-weight: 700;
            color: #7c5cfc;                   /* <-- "Lecturer's Response" label color */
            margin-bottom: 4px;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- TOP BAR -->
        <div class="dashboard-topbar">
            <h2>Forum</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="content-wrapper">

            <div class="welcome-text">
                <h1>Student <span>Forum</span></h1>
                <p>Ask your instructors questions and view their responses.</p>
            </div>

            <!-- ASK A QUESTION -->
            <div class="ask-box">
                <h4>Ask a Question</h4>

                <label>Select Instructor</label>
                <asp:DropDownList ID="ddlLecturer" runat="server" CssClass="ask-dropdown"
                    DataTextField="Name"
                    DataValueField="UserID">
                </asp:DropDownList>

                <label>Your Question</label>
                <asp:TextBox ID="txtQuestion" runat="server" CssClass="ask-textbox" TextMode="MultiLine" placeholder="Type your question here..."></asp:TextBox>

                <asp:Button ID="btnPostQuestion" runat="server" Text="Post Question" CssClass="post-btn" OnClick="btnPostQuestion_Click" />
            </div>

            <!-- LIST OF THE STUDENT'S OWN FORUM POSTS -->
            <asp:Repeater ID="rptForumPosts" runat="server">
                <ItemTemplate>
                    <div class="post-card">
                        <div class="post-date"><%# Eval("questionDate", "{0:dd MMM yyyy, hh:mm tt}") %></div>

                        <div class="post-question"><%# Eval("questionText") %></div>

                        <span class="post-status <%# Eval("stat").ToString() == "Answered" ? "status-answered" : "status-pending" %>">
                            <%# Eval("stat") %>
                        </span>

                        <asp:Panel ID="pnlResponse" runat="server" Visible='<%# Eval("responseText") != DBNull.Value %>'>
                            <div class="post-response-box">
                                <div class="response-label">Lecturer's Response</div>
                                <%# Eval("responseText") %>
                            </div>
                        </asp:Panel>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </section>

    </form>
</body>
</html>