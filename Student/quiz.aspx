<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Quiz.aspx.cs" Inherits="HangeulHubWAPP.Student.Quiz" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quiz - HangeulHub</title>

    <!-- Google Font (Poppins) -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet" />

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

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

        .dashboard-topbar h2 {
            color: #222222;
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
            background-color: #7c5cfc;
            color: #ffffff;
        }

        .back-btn:hover {
            background-color: #6a4ae0;
        }

        /* PAGE CONTENT */
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
            color: #222222;
        }

        .quiz-info {
            text-align: center;
            font-size: 14px;
            color: #666666;
            margin-bottom: 25px;
        }

        .alert-message {
            color: #e74c3c;
            font-weight: 600;
            margin-bottom: 15px;
            text-align: center;
        }

        /* QUESTION CARD */
        .question-card {
            width: 100%;
            max-width: 650px;
            background-color: #ffffff;
            border-radius: 12px;
            padding: 20px 25px;
            margin-bottom: 18px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .question-card .q-number {
            font-size: 12px;
            font-weight: 700;
            color: #7c5cfc;
            margin-bottom: 6px;
        }

        .question-card .q-text {
            font-size: 15px;
            color: #222222;
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

        /* SUBMIT BUTTON */
        .submit-btn {
            padding: 12px 34px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 700;
            font-size: 15px;
            margin-top: 10px;
            background-color: #7c5cfc;
            color: #ffffff;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .submit-btn:hover {
            background-color: #6a4ae0;
        }

        /* RESULT BOX */
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
            color: #222222;
        }

        .result-box .result-score {
            font-size: 36px;
            font-weight: 800;
            color: #7c5cfc;
            margin-bottom: 10px;
        }

        .result-box p {
            color: #666666;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Hidden field to store time taken in minutes -->
        <asp:HiddenField ID="hfTimeTaken" runat="server" Value="0" />

        <!-- TOP BAR -->
        <div class="dashboard-topbar">
            <h2>Quiz</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="content-wrapper">

            <!-- Alert or Info Messages -->
            <asp:Label ID="lblMessage" runat="server" CssClass="alert-message"></asp:Label>

            <!-- Quiz Title & Info -->
            <div class="welcome-text">
                <h1>Quiz: <asp:Label ID="lblQuizTitle" runat="server" Text="[Select Quiz]"></asp:Label></h1>
            </div>
            <div class="quiz-info">
                Time Limit: <asp:Label ID="lblTimeLimit" runat="server" Text="0"></asp:Label> min
                &nbsp;|&nbsp;
                Passing Score: <asp:Label ID="lblPassingScore" runat="server" Text="0"></asp:Label>%
            </div>

            <!-- Questions Panel -->
            <asp:Panel ID="pnlQuiz" runat="server">

                <asp:Repeater ID="rptQuestions" runat="server">
                    <ItemTemplate>
                        <div class="question-card">
                            <div class="q-number">Question <%# Container.ItemIndex + 1 %></div>
                            <div class="q-text"><%# Eval("questionText") %></div>

                            <asp:HiddenField ID="hfQuestionID" runat="server" Value='<%# Eval("questionID") %>' />
                            <asp:TextBox ID="txtAnswer" runat="server" CssClass="q-answer-box" placeholder="Type your answer here"></asp:TextBox>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Button ID="btnSubmitQuiz" runat="server" Text="Submit Quiz" CssClass="submit-btn" OnClick="btnSubmitQuiz_Click" />

            </asp:Panel>

            <!-- Result Panel -->
            <asp:Panel ID="pnlResult" runat="server" CssClass="result-box" Visible="false">
                <h2>Quiz Completed!</h2>
                <div class="result-score"><asp:Label ID="lblScore" runat="server"></asp:Label></div>
                <p><asp:Label ID="lblResultMessage" runat="server"></asp:Label></p>
            </asp:Panel>

        </section>

    </form>

    <!-- JavaScript to calculate elapsed time before submit -->
    <script type="text/javascript">
        let startTime = new Date();

        document.getElementById('<%= btnSubmitQuiz.ClientID %>')?.addEventListener('click', function () {
            let endTime = new Date();
            let timeTakenMinutes = Math.round((endTime - startTime) / 1000 / 60);

            // Record at least 1 minute if submitted under 60 seconds
            if (timeTakenMinutes < 1) {
                timeTakenMinutes = 1;
            }

            document.getElementById('<%= hfTimeTaken.ClientID %>').value = timeTakenMinutes;
        });
    </script>
</body>
</html>