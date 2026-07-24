<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageForum.aspx.cs" Inherits="HangeulHubWAPP.Instructor.ManageForum" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Forum - HangeulHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; }
        body { font-family: Poppins, Arial, sans-serif; background: #f4f4fc; margin: 0; color: #222; }
        .topbar { background: white; padding: 18px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,.05); }
        .topbar h2 { margin: 0; color: #7c5cfc; }
        .topbar a { text-decoration: none; background: #7c5cfc; color: white; padding: 10px 18px; border-radius: 10px; font-weight: 500; }
        .container { max-width: 800px; margin: auto; padding: 35px 25px 90px; }

        .filter-bar { display: flex; gap: 8px; margin-bottom: 22px; }
        .filter-btn {
            border: 1px solid #e2e0f5; background: white; color: #555;
            padding: 8px 18px; border-radius: 999px; cursor: pointer;
            font-family: Poppins; font-size: 14px; font-weight: 500;
        }
        .filter-btn.active { background: #7c5cfc; border-color: #7c5cfc; color: white; }

        .post-card { background: white; border-radius: 16px; padding: 20px 24px; box-shadow: 0 4px 15px rgba(0,0,0,.06); margin-bottom: 16px; }
        .post-head { display: flex; justify-content: space-between; align-items: flex-start; gap: 12px; margin-bottom: 10px; }
        .student-name { font-weight: 600; font-size: 14px; }
        .post-date { font-size: 12px; color: #999; }
        .badge { display: inline-block; padding: 4px 12px; border-radius: 999px; font-size: 12px; font-weight: 600; white-space: nowrap; }
        .badge.needs-reply { background: #fff3e0; color: #e08a1e; }
        .badge.answered { background: #e1f8ef; color: #0d9668; }
        .post-question { font-size: 15px; margin: 10px 0; line-height: 1.5; }
        .response-box { background: #f7f5ff; border-left: 3px solid #7c5cfc; padding: 12px 15px; border-radius: 8px; font-size: 14px; color: #333; margin-top: 12px; }
        .response-label { font-size: 12px; font-weight: 700; color: #7c5cfc; margin-bottom: 4px; }
        .post-actions { margin-top: 14px; }
        .icon-btn { border: none; border-radius: 10px; padding: 9px 18px; font-family: Poppins; font-size: 13px; font-weight: 500; cursor: pointer; }
        .icon-btn.reply { background: #efe9ff; color: #7c5cfc; }

        .empty-state { text-align: center; padding: 60px 20px; background: white; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,.06); }

        .modal-overlay { display: none; position: fixed; inset: 0; z-index: 100; background: rgba(30,25,60,.45); align-items: center; justify-content: center; padding: 20px; }
        .modal-overlay.open { display: flex; }
        .modal { background: white; border-radius: 16px; width: 100%; max-width: 520px; padding: 26px; }
        .modal h3 { margin: 0 0 6px; color: #7c5cfc; }
        .modal .modal-sub { font-size: 13px; color: #666; background: #f7f5ff; padding: 10px 14px; border-radius: 8px; margin-bottom: 14px; }
        .modal label { display: block; margin: 12px 0 6px; font-weight: 600; font-size: 14px; }
        .modal textarea { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 10px; font-family: Poppins; font-size: 14px; min-height: 120px; resize: vertical; }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 22px; }
        .btn { border: none; border-radius: 10px; padding: 11px 22px; cursor: pointer; font-family: Poppins; font-weight: 600; font-size: 14px; }
        .btn.primary { background: #7c5cfc; color: white; }
        .btn.ghost { background: #f1f0fa; color: #555; }
        .msg { display: block; margin-top: 10px; font-size: 14px; font-weight: 500; color: #0d9668; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="topbar">
        <h2>Manage Forum</h2>
        <a href="InstructorDashboard.aspx">Back to Dashboard</a>
    </div>

    <main class="container">
        <asp:Label ID="lblMessage" runat="server" CssClass="msg"></asp:Label>

        <!-- Server-side filter: re-queries forumTable scoped to this instructor -->
        <div class="filter-bar">
            <asp:LinkButton ID="btnFilterAll" runat="server" CssClass="filter-btn active" CommandArgument="All" OnClick="Filter_Click">All</asp:LinkButton>
            <asp:LinkButton ID="btnFilterOpen" runat="server" CssClass="filter-btn" CommandArgument="Open" OnClick="Filter_Click">Needs Reply</asp:LinkButton>
            <asp:LinkButton ID="btnFilterAnswered" runat="server" CssClass="filter-btn" CommandArgument="Answered" OnClick="Filter_Click">Answered</asp:LinkButton>
        </div>

        <asp:Repeater ID="rptForum" runat="server" OnItemCommand="rptForum_ItemCommand">
            <ItemTemplate>
                <div class="post-card">
                    <div class="post-head">
                        <div>
                            <div class="student-name"><%#: Eval("studentName") %></div>
                            <div class="post-date"><%# Eval("questionDate", "{0:dd MMM yyyy, h:mm tt}") %></div>
                        </div>
                        <span class='badge <%# Eval("stat").ToString() == "Answered" ? "answered" : "needs-reply" %>'>
                            <%#: Eval("stat").ToString() == "Answered" ? "Answered" : "Needs Reply" %>
                        </span>
                    </div>

                    <p class="post-question"><%#: Eval("questionText") %></p>

                    <asp:Panel ID="pnlResponse" runat="server" Visible='<%# Eval("responseText") != DBNull.Value %>'>
                        <div class="response-box">
                            <div class="response-label">Your Response</div>
                            <%#: Eval("responseText") %>
                        </div>
                    </asp:Panel>

                    <div class="post-actions">
                        <asp:LinkButton runat="server" CssClass="icon-btn reply"
                            CommandName="Reply" CommandArgument='<%# Eval("ForumID") %>'>
                            <%#: Eval("responseText") == DBNull.Value ? "Reply" : "Edit Reply" %>
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-state" Visible="false">
            <h3>No questions here</h3>
            <p>Nothing in this view right now.</p>
        </asp:Panel>
    </main>

    <!-- Reply modal - used for both a first reply and editing an existing one -->
    <div class="modal-overlay" id="replyModal">
        <div class="modal">
            <h3>Reply to Student</h3>
            <div class="modal-sub" id="modalQuestionText" runat="server"></div>
            <asp:HiddenField ID="hfForumID" runat="server" />

            <label>Your Response</label>
            <asp:TextBox ID="txtReply" runat="server" TextMode="MultiLine"></asp:TextBox>

            <asp:Label ID="lblModalMessage" runat="server" CssClass="msg"></asp:Label>

            <div class="modal-actions">
                <button type="button" class="btn ghost" onclick="document.getElementById('replyModal').classList.remove('open')">Cancel</button>
                <asp:Button ID="btnSubmitReply" runat="server" Text="Send Reply" CssClass="btn primary" OnClick="btnSubmitReply_Click" />
            </div>
        </div>
    </div>

    <script>
function openReplyModal() { document.getElementById('replyModal').classList.add('open'); }
document.querySelectorAll('.modal-overlay').forEach(function(ov) {
    ov.addEventListener('mousedown', function(e) { if (e.target === ov) ov.classList.remove('open'); });
        });
    </script>
</form>
</body>
</html>