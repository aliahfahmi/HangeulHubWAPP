<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageQuestions.aspx.cs" Inherits="HangeulHubWAPP.Instructor.ManageQuestions" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Questions - HangeulHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; }
        body { font-family: Poppins, Arial, sans-serif; background: #f4f4fc; margin: 0; color: #222; }
        .topbar { background: white; padding: 18px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,.05); }
        .topbar h2 { margin: 0; color: #7c5cfc; font-size: 20px; }
        .topbar a { text-decoration: none; background: #7c5cfc; color: white; padding: 10px 18px; border-radius: 10px; font-weight: 500; }
        .container { max-width: 850px; margin: auto; padding: 35px 25px 90px; }
        .quiz-info { background: white; border-radius: 16px; padding: 20px 24px; box-shadow: 0 4px 15px rgba(0,0,0,.06); margin-bottom: 26px; }
        .quiz-info h3 { margin: 0 0 4px; color: #7c5cfc; }
        .quiz-info p { margin: 0; color: #888; font-size: 14px; }
        .question-card { background: white; border-radius: 14px; padding: 18px 22px; box-shadow: 0 4px 15px rgba(0,0,0,.06); margin-bottom: 14px; }
        .question-text { font-weight: 600; margin: 0 0 6px; }
        .answer-text { font-size: 13px; color: #0d9668; background: #e1f8ef; display: inline-block; padding: 4px 12px; border-radius: 999px; }
        .q-actions { display: flex; gap: 8px; margin-top: 12px; }
        .icon-btn { border: none; border-radius: 10px; padding: 8px 16px; font-family: Poppins; font-size: 13px; font-weight: 500; cursor: pointer; }
        .icon-btn.edit { background: #efe9ff; color: #7c5cfc; }
        .icon-btn.delete { background: #ffeef3; color: #e0447c; }
        .empty-state { text-align: center; padding: 60px 20px; background: white; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,.06); }
        .fab { position: fixed; right: 34px; bottom: 34px; background: linear-gradient(135deg, #7c5cfc, #6847e8); color: white; border: none; border-radius: 999px; padding: 15px 26px; font-family: Poppins; font-size: 15px; font-weight: 600; cursor: pointer; box-shadow: 0 10px 25px rgba(124,92,252,.4); }
        .fab.ai { right: 210px; background: linear-gradient(135deg, #0d9668, #10b981); box-shadow: 0 10px 25px rgba(13,150,104,.4); }
        .modal .hint { font-size: 12px; color: #888; margin-top: 4px; }
        .modal-overlay { display: none; position: fixed; inset: 0; z-index: 100; background: rgba(30,25,60,.45); align-items: center; justify-content: center; padding: 20px; }
        .modal-overlay.open { display: flex; }
        .modal { background: white; border-radius: 16px; width: 100%; max-width: 500px; padding: 26px; }
        .modal h3 { margin: 0 0 14px; color: #7c5cfc; }
        .modal label { display: block; margin: 12px 0 6px; font-weight: 600; font-size: 14px; }
        .modal input, .modal textarea { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 10px; font-family: Poppins; font-size: 14px; }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 22px; }
        .btn { border: none; border-radius: 10px; padding: 11px 22px; cursor: pointer; font-family: Poppins; font-weight: 600; font-size: 14px; }
        .btn.primary { background: #7c5cfc; color: white; }
        .btn.ghost { background: #f1f0fa; color: #555; }
        .msg { display: block; margin-top: 10px; font-size: 14px; font-weight: 500; color: #7c5cfc; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="topbar">
        <h2>Manage Questions</h2>
        <a href="ManageQuizzes.aspx">Back to Quizzes</a>
    </div>

    <main class="container">
        <div class="quiz-info">
            <h3><asp:Literal ID="litQuizTitle" runat="server"></asp:Literal></h3>
            <p><asp:Literal ID="litQuizMeta" runat="server"></asp:Literal></p>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="msg"></asp:Label>

        <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
            <ItemTemplate>
                <div class="question-card">
                    <p class="question-text"><%#: Container.ItemIndex + 1 %>. <%#: Eval("questionText") %></p>
                    <span class="answer-text">Correct answer: <%#: Eval("correctAns") %></span>
                    <div class="q-actions">
                        <asp:LinkButton runat="server" CssClass="icon-btn edit"
                            CommandName="EditQuestion" CommandArgument='<%# Eval("questionID") %>'>Edit</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="icon-btn delete"
                            CommandName="DeleteQuestion" CommandArgument='<%# Eval("questionID") %>'
                            OnClientClick='return confirm("Delete this question?");'>Delete</asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-state" Visible="false">
            <h3>No questions yet</h3>
            <p>Add your first question for this quiz.</p>
        </asp:Panel>
    </main>

    <button type="button" class="fab ai" onclick="openAiModal()">&#129302; Generate with AI</button>
    <button type="button" class="fab" onclick="openQuestionModal()">+ New Question</button>

    <!-- AI question generator: instructor gives a topic + count, AI drafts the -->
    <!-- questions and they get added straight into the list below, where the -->
    <!-- instructor can Edit or Delete them exactly like a manually added question. -->
    <div class="modal-overlay" id="aiModal">
        <div class="modal">
            <h3>Generate Questions with AI</h3>

            <label>Topic</label>
            <asp:TextBox ID="txtAiTopic" runat="server" placeholder="e.g. Hangul vowels, past tense verbs"></asp:TextBox>

            <label>Number of Questions</label>
            <asp:DropDownList ID="ddlAiCount" runat="server">
                <asp:ListItem>3</asp:ListItem>
                <asp:ListItem Selected="True">5</asp:ListItem>
                <asp:ListItem>10</asp:ListItem>
            </asp:DropDownList>
            <p class="hint">Difficulty is taken automatically from this quiz's level.</p>

            <asp:Label ID="lblAiMessage" runat="server" CssClass="msg"></asp:Label>

            <div class="modal-actions">
                <button type="button" class="btn ghost" onclick="document.getElementById('aiModal').classList.remove('open')">Cancel</button>
                <asp:Button ID="btnGenerateAi" runat="server" Text="Generate" CssClass="btn primary" OnClick="btnGenerateAi_Click" />
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="questionModal">
        <div class="modal">
            <h3>Question Details</h3>
            <asp:HiddenField ID="hfQuestionID" runat="server" />

            <label>Question Text</label>
            <asp:TextBox ID="txtQuestionText" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>

            <label>Correct Answer</label>
            <asp:TextBox ID="txtCorrectAns" runat="server"></asp:TextBox>

            <asp:Label ID="lblModalMessage" runat="server" CssClass="msg"></asp:Label>

            <div class="modal-actions">
                <button type="button" class="btn ghost" onclick="document.getElementById('questionModal').classList.remove('open')">Cancel</button>
                <asp:Button ID="btnSaveQuestion" runat="server" Text="Save Question" CssClass="btn primary" OnClick="btnSaveQuestion_Click" />
            </div>
        </div>
    </div>

    <script>
        function openQuestionModal() { document.getElementById('questionModal').classList.add('open'); }
        function openAiModal() { document.getElementById('aiModal').classList.add('open'); }
        document.querySelectorAll('.modal-overlay').forEach(function (ov) {
            ov.addEventListener('mousedown', function (e) { if (e.target === ov) ov.classList.remove('open'); });
        });
    </script>
</form>
</body>
</html>