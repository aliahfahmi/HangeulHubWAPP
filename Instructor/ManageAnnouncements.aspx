<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageAnnouncements.aspx.cs" Inherits="HangeulHubWAPP.Instructor.ManageAnnouncements" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Announcements - HangeulHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; }
        body { font-family: Poppins, Arial, sans-serif; background: #f4f4fc; margin: 0; color: #222; }
        .topbar { background: white; padding: 18px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,.05); }
        .topbar h2 { margin: 0; color: #7c5cfc; }
        .topbar a { text-decoration: none; background: #7c5cfc; color: white; padding: 10px 18px; border-radius: 10px; font-weight: 500; }
        .container { max-width: 850px; margin: auto; padding: 35px 25px 90px; }
        .announcement-card { background: white; border-radius: 14px; padding: 18px 22px; box-shadow: 0 4px 15px rgba(0,0,0,.06); margin-bottom: 14px; }
        .a-title { font-weight: 600; margin: 0 0 6px; }
        .a-date { font-size: 12px; color: #999; margin-bottom: 8px; }
        .a-content { font-size: 14px; color: #555; line-height: 1.5; }
        .a-actions { display: flex; gap: 8px; margin-top: 12px; }
        .icon-btn { border: none; border-radius: 10px; padding: 8px 16px; font-family: Poppins; font-size: 13px; font-weight: 500; cursor: pointer; }
        .icon-btn.edit { background: #efe9ff; color: #7c5cfc; }
        .icon-btn.delete { background: #ffeef3; color: #e0447c; }
        .empty-state { text-align: center; padding: 60px 20px; background: white; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,.06); }
        .fab { position: fixed; right: 34px; bottom: 34px; background: linear-gradient(135deg, #7c5cfc, #6847e8); color: white; border: none; border-radius: 999px; padding: 15px 26px; font-family: Poppins; font-size: 15px; font-weight: 600; cursor: pointer; box-shadow: 0 10px 25px rgba(124,92,252,.4); }
        .modal-overlay { display: none; position: fixed; inset: 0; z-index: 100; background: rgba(30,25,60,.45); align-items: center; justify-content: center; padding: 20px; }
        .modal-overlay.open { display: flex; }
        .modal { background: white; border-radius: 16px; width: 100%; max-width: 520px; padding: 26px; }
        .modal h3 { margin: 0 0 14px; color: #7c5cfc; }
        .modal label { display: block; margin: 12px 0 6px; font-weight: 600; font-size: 14px; }
        .modal input, .modal textarea { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 10px; font-family: Poppins; font-size: 14px; }
        .modal textarea { min-height: 120px; resize: vertical; }
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
        <h2>Announcements</h2>
        <a href="InstructorDashboard.aspx">Back to Dashboard</a>
    </div>

    <main class="container">
        <asp:Label ID="lblMessage" runat="server" CssClass="msg"></asp:Label>

        <asp:Repeater ID="rptAnnouncements" runat="server" OnItemCommand="rptAnnouncements_ItemCommand">
            <ItemTemplate>
                <div class="announcement-card">
                    <p class="a-title"><%#: Eval("title") %></p>
                    <div class="a-date">Posted <%#: Eval("datePosted", "{0:dd MMM yyyy}") %></div>
                    <div class="a-content"><%#: Eval("content") %></div>
                    <div class="a-actions">
                        <asp:LinkButton runat="server" CssClass="icon-btn edit"
                            CommandName="EditAnnouncement" CommandArgument='<%# Eval("announcementID") %>'>Edit</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="icon-btn delete"
                            CommandName="DeleteAnnouncement" CommandArgument='<%# Eval("announcementID") %>'
                            OnClientClick='return confirm("Delete this announcement?");'>Delete</asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-state" Visible="false">
            <h3>No announcements yet</h3>
            <p>Post your first announcement to keep students informed.</p>
        </asp:Panel>
    </main>

    <button type="button" class="fab" onclick="openAnnouncementModal()">+ New Announcement</button>

    <div class="modal-overlay" id="announcementModal">
        <div class="modal">
            <h3>Announcement Details</h3>
            <asp:HiddenField ID="hfAnnouncementID" runat="server" />

            <label>Title</label>
            <asp:TextBox ID="txtTitle" runat="server"></asp:TextBox>

            <label>Content</label>
            <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine"></asp:TextBox>

            <asp:Label ID="lblModalMessage" runat="server" CssClass="msg"></asp:Label>

            <div class="modal-actions">
                <button type="button" class="btn ghost" onclick="document.getElementById('announcementModal').classList.remove('open')">Cancel</button>
                <asp:Button ID="btnSaveAnnouncement" runat="server" Text="Post" CssClass="btn primary" OnClick="btnSaveAnnouncement_Click" />
            </div>
        </div>
    </div>

    <script>
        function openAnnouncementModal() { document.getElementById('announcementModal').classList.add('open'); }
        document.querySelectorAll('.modal-overlay').forEach(function (ov) {
            ov.addEventListener('mousedown', function (e) { if (e.target === ov) ov.classList.remove('open'); });
        });
    </script>
</form>
</body>
</html>