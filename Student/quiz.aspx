<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Quiz.aspx.cs" Inherits="HangeulHubWAPP.Student.Quiz" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quiz - HangeulHub</title>

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
            margin-bottom: 10px;
        }

        .welcome-text h1 {
            font-size: 30px;
            font-weight: 800;
            color: #222222;                   /* <-- heading text color */
        }

        .welcome-text h1 span {
            color: #7c5cfc;                   /* <-- accent purple word color */
        }

        .quiz-info {
            text-align: center;
            font-size: 14px;
            color: #666666;                   /* <-- quiz info text color */
            margin-bottom: 25px;
        }


        /* ================================
           QUESTION CARD
           ================================ */
        .question-card {
            width: 100%;
            max-width: 650px;

            background-color: #ffffff;        /* <-- card background color */
            border-radius: 12px;
            padding: 20px 25px;
            margin-bottom: 18px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .question-card .q-number {
            font-size: 12px;
            font-weight: 700;
            color: #7c5cfc;                   /* <-- "Question X" label color */
            margin-bottom: 6px;
        }

        .question-card .q-text {
            font-size: 15px;
            color: #222222;                   /* <-- question text color */
            margin-bottom: 12px;
        }

        .question-card .q-answer-box {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #dddddd;
            border-radius: 6px;
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
        }


        /* ================================
           SUBMIT BUTTON
           ================================ */
        .submit-btn {
            padding: 12px 34px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 700;
            font-size: 15px;
            margin-top: 10px;

            background-color: #7c5cfc;        /* <-- submit button background color */
            color: #ffffff;                   /* <-- submit button text color */
        }

        .submit-btn:hover {
            background-color: #6a4ae0;        /* <-- submit button hover color */
        }


        /* ================================
           RESULT BOX (shown after submit)
           ================================ */
        .result-box {
            width: 100%;
            max-width: 650px;
            text-align: center;

            background-color: #ffffff;
            border-radius: 12px;
            padding: 30px 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .result-box h2 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #222222;                   /* <-- result heading color */
        }

        .result-box .result-score {
            font-size: 36px;
            font-weight: 800;
            color: #7c5cfc;                   /* <-- score number color */
            margin-bottom: 10px;
        }

        .result-box p {
            color: #666666;                   /* <-- result description color */
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- TOP BAR -->
        <div class="dashboard-topbar">
            <h2>Quiz</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="content-wrapper">

            <!-- Quiz title + info -->
            <div class="welcome-text">
                <h1>Quiz: <asp:Label ID="lblQuizTitle" runat="server" Text="[Quiz Title]"></asp:Label></h1>
            </div>
            <div class="quiz-info">
                Time Limit: <asp:Label ID="lblTimeLimit" runat="server" Text="0"></asp:Label> min
                &nbsp;|&nbsp;
                Passing Score: <asp:Label ID="lblPassingScore" runat="server" Text="0"></asp:Label>
            </div>

            <!-- Questions panel - hidden after submit -->
            <asp:Panel ID="pnlQuiz" runat="server">

                <!-- Repeater loads questions from questionTable - bind its DataSource via Toolbox (Design view) -->
                <asp:Repeater ID="rptQuestions" runat="server">
                    <ItemTemplate>
                        <div class="question-card">
                            <div class="q-number">Question <%# Container.ItemIndex + 1 %></div>
                            <div class="q-text"><%# Eval("questionText") %></div>

                            <!-- Hidden field keeps track of which question this answer belongs to -->
                            <asp:HiddenField ID="hfQuestionID" runat="server" Value='<%# Eval("questionID") %>' />

                            <asp:TextBox ID="txtAnswer" runat="server" CssClass="q-answer-box" placeholder="Type your answer here"></asp:TextBox>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Button ID="btnSubmitQuiz" runat="server" Text="Submit Quiz" CssClass="submit-btn" OnClick="btnSubmitQuiz_Click" />

            </asp:Panel>

            <!-- Result panel - shown only after submit -->
            <asp:Panel ID="pnlResult" runat="server" CssClass="result-box" Visible="false">
                <h2>Quiz Completed!</h2>
                <div class="result-score"><asp:Label ID="lblScore" runat="server"></asp:Label></div>
                <p><asp:Label ID="lblResultMessage" runat="server"></asp:Label></p>
            </asp:Panel>

        </section>

    </form>
</body>
</html>