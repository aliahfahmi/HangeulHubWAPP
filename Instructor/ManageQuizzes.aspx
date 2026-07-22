<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageQuizzes.aspx.cs" Inherits="HangeulHubWAPP.Instructor.ManageQuizzes" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Quizzes - HangeulHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; }
        body { font-family: Poppins, Arial, sans-serif; background: #f4f4fc; margin: 0; color: #222; }
        .topbar { background: white; padding: 18px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,.05); }
        .topbar h2 { margin: 0; color: #7c5cfc; }
        .topbar a { text-decoration: none; background: #7c5cfc; color: white; padding: 10px 18px; border-radius: 10px; font-weight: 500; }
        .topbar a:hover { background: #6847e8; }
        .container { max-width: 1100px; margin: auto; padding: 35px 25px 90px; }
        .stats { display: flex; gap: 18px; margin-bottom: 26px; }
        .stat-card { background: white; border-radius: 16px; padding: 20px 24px; box-shadow: 0 4px 15px rgba(0,0,0,.06); border-top: 4px solid #7c5cfc; }
        .stat-card .stat-label { font-size: 13px; color: #888; }
        .stat-card .stat-value { font-size: 30px; font-weight: 700; }
        .quiz-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .quiz-card { background: white; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,.06); padding: 20px 22px; display: flex; flex-direction: column; }
        .quiz-title { font-weight: 600; font-size: 16px; margin: 0 0 6px; }
        .quiz-meta { font-size: 13px; color: #888; margin-bottom: 10px; }
        .badge { display: inline-block; padding: 4px 12px; border-radius: 999px; font-size: 12px; font-weight: 600; background: #efe9ff; color: #7c5cfc; margin-right: 6px; }
        .quiz-actions { display: flex; gap: 8px; margin-top: 16px; }
        .icon-btn { flex: 1; border: none; border-radius: 10px; padding: 9px 0; font-family: Poppins; font-size: 13px; font-weight: 500; cursor: pointer; text-align: center; text-decoration: none; }
        .icon-btn.edit { background: #efe9ff; color: #7c5cfc; }
        .icon-btn.questions { background: #eef4ff; color: #2f6fdb; }
        .icon-btn.delete { background: #ffeef3; color: #e0447c; }
        .empty-state { text-align: center; padding: 70px 20px; background: white; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,.06); }
        .fab { position: fixed; right: 34px; bottom: 34px; background: linear-gradient(135deg, #7c5cfc, #6847e8); color: white; border: none; border-radius: 999px; padding: 15px 26px; font-family: Poppins; font-size: 15px; font-weight: 600; cursor: pointer; box-shadow: 0 10px 25px rgba(124,92,252,.4); }
        .modal-overlay { display: none; position: fixed; inset: 0; z-index: 100; background: rgba(30,25,60,.45); align-items: center; justify-content: center; padding: 20px; }
        .modal-overlay.open { display: flex; }
        .modal { background: white; border-radius: 16px; width: 100%; max-width: 480px; padding: 26px; }
        .modal h3 { margin: 0 0 14px; color: #7c5cfc; }
        .modal label { display: block; margin: 12px 0 6px; font-weight: 600; font-size: 14px; }
        .modal input, .modal select { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 10px; font-family: Poppins; font-size: 14px; }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 22px; }
        .btn { border: none; border-radius: 10px; padding: 11px 22px; cursor: pointer; font-family: Poppins; font-weight: 600; font-size: 14px; }
        .btn.primary { background: #7c5cfc; color: white; }
        .btn.ghost { background: #f1f0fa; color: #555; }
        .btn.danger { background: #e0447c; color: white; }
        .msg { display: block; margin-top: 10px; font-size: 14px; font-weight: 500; color: #7c5cfc; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="topbar">
        <h2>Manage Quizzes</h2>
        <a href="InstructorDashboard.aspx">Back to Dashboard</a>
    </div>

    <main class="container">
        <!-- Simple stat: how many quizzes this instructor has created -->
        <div class="stats">
            <div class="stat-card">
                <div class="stat-label">Total Quizzes</div>
                <div class="stat-value"><asp:Literal ID="litTotal" runat="server">0</asp:Literal></div>
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="msg"></asp:Label>

        <!-- One card per quiz, data comes from the Repeater's DataSource (a DataTable) -->
        <div class="quiz-grid">
            <asp:Repeater ID="rptQuizzes" runat="server" OnItemCommand="rptQuizzes_ItemCommand">
                <ItemTemplate>
                    <div class="quiz-card">
                        <p class="quiz-title"><%#: Eval("title") %></p>
                        <div class="quiz-meta"><%#: Eval("courseTitle") %> &middot; <%#: Eval("quizID") %></div>
                        <div>
                            <span class="badge"><%#: Eval("diffLevel") %></span>
                            <span class="badge"><%#: Eval("timelimit") %> min</span>
                            <span class="badge"><%#: Eval("passingScore") %>% to pass</span>
                        </div>
                        <div class="quiz-meta" style="margin-top:8px;"><%#: Eval("questionCount") %> question(s)</div>

                        <div class="quiz-actions">
                            <asp:LinkButton runat="server" CssClass="icon-btn edit"
                                CommandName="EditQuiz" CommandArgument='<%# Eval("quizID") %>'>Edit</asp:LinkButton>
                            <a class="icon-btn questions"
                               href='ManageQuestions.aspx?quizID=<%#: Eval("quizID") %>'>Questions</a>
                            <asp:LinkButton runat="server" CssClass="icon-btn delete"
                                CommandName="DeleteQuiz" CommandArgument='<%# Eval("quizID") %>'
                                OnClientClick='return confirm("Delete this quiz and all its questions?");'>Delete</asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-state" Visible="false">
            <h3>No quizzes yet</h3>
            <p>Create your first quiz to get started.</p>
        </asp:Panel>
    </main>

    <button type="button" class="fab" onclick="document.getElementById('quizModal').classList.add('open')">+ New Quiz</button>

    <!-- Add / Edit Quiz modal -->
    <div class="modal-overlay" id="quizModal">
        <div class="modal">
            <h3>Quiz Details</h3>
            <asp:HiddenField ID="hfQuizID" runat="server" />

            <label>Course</label>
            <asp:DropDownList ID="ddlCourse" runat="server"></asp:DropDownList>

            <label>Quiz Title</label>
            <asp:TextBox ID="txtTitle" runat="server"></asp:TextBox>

            <label>Difficulty</label>
            <asp:DropDownList ID="ddlDifficulty" runat="server">
                <asp:ListItem>Beginner</asp:ListItem>
                <asp:ListItem>Intermediate</asp:ListItem>
                <asp:ListItem>Advanced</asp:ListItem>
            </asp:DropDownList>

            <label>Time Limit (minutes)</label>
            <asp:TextBox ID="txtTimeLimit" runat="server" TextMode="Number"></asp:TextBox>

            <label>Passing Score (%)</label>
            <asp:TextBox ID="txtPassingScore" runat="server" TextMode="Number"></asp:TextBox>

            <asp:Label ID="lblModalMessage" runat="server" CssClass="msg"></asp:Label>

            <div class="modal-actions">
                <button type="button" class="btn ghost" onclick="document.getElementById('quizModal').classList.remove('open')">Cancel</button>
                <asp:Button ID="btnSaveQuiz" runat="server" Text="Save Quiz" CssClass="btn primary" OnClick="btnSaveQuiz_Click" />
            </div>
        </div>
    </div>

    <script>
        // Close modal when clicking the dark overlay
        document.querySelectorAll('.modal-overlay').forEach(function (ov) {
            ov.addEventListener('mousedown', function (e) { if (e.target === ov) ov.classList.remove('open'); });
        });

        // If the server re-shows the modal after a validation error or an Edit click,
        // it calls this via RegisterStartupScript (see code-behind).
        function openQuizModal() { document.getElementById('quizModal').classList.add('open'); }
    </script>
</form>
</body>
</html>