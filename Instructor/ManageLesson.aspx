<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageLessons.aspx.cs" Inherits="HangeulHubWAPP.Instructor.ManageLessons" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Lessons - HangeulHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet" />

    <style>
        * { box-sizing: border-box; }
        body { font-family: Poppins, Arial; background: #f4f4fc; margin: 0; color: #222; }
        .topbar {
            background: white; padding: 18px 40px; display: flex;
            justify-content: space-between; align-items: center;
        }
        .topbar a {
            text-decoration: none; background: #7c5cfc; color: white;
            padding: 10px 18px; border-radius: 8px;
        }
        .container { max-width: 1150px; margin: auto; padding: 35px 25px; }
        .card {
            background: white; border-radius: 16px; padding: 28px;
            box-shadow: 0 4px 15px rgba(0,0,0,.08); margin-bottom: 25px;
        }
        h1 { margin-top: 0; }
        h2 { color: #7c5cfc; font-size: 20px; }
        label { display: block; margin: 14px 0 6px; font-weight: 600; }
        input, select, textarea {
            width: 100%; padding: 10px; border: 1px solid #ddd;
            border-radius: 7px; font-family: Poppins;
        }
        textarea { min-height: 110px; resize: vertical; }
        .btn {
            margin-top: 18px; border: none; background: #7c5cfc;
            color: white; padding: 11px 22px; border-radius: 8px;
            cursor: pointer; font-family: Poppins; font-weight: 600;
        }
        .btn:hover { background: #6847e8; }
        .grid { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .grid th { background: #7c5cfc; color: white; padding: 12px; text-align: left; }
        .grid td { padding: 12px; border-bottom: 1px solid #eee; }
        .delete-btn {
            background: #f9538b; color: white; padding: 7px 11px;
            text-decoration: none; border-radius: 6px;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <div class="topbar">
        <h2>Manage Lessons</h2>
        <a href="InstructorDashboard.aspx">Back to Dashboard</a>
    </div>

    <main class="container">
        <div class="card">
            <h1>Add New Lesson</h1>

            <label>Course Level</label>
            <asp:DropDownList ID="ddlCourse" runat="server">
                <asp:ListItem Value="C001">Beginner Korean</asp:ListItem>
                <asp:ListItem Value="C002">Intermediate Korean</asp:ListItem>
                <asp:ListItem Value="C003">Advanced Korean</asp:ListItem>
            </asp:DropDownList>

            <label>Lesson Type</label>
            <asp:DropDownList ID="ddlType" runat="server">
                <asp:ListItem>Hangul</asp:ListItem>
                <asp:ListItem>Vocabulary</asp:ListItem>
                <asp:ListItem>Grammar</asp:ListItem>
            </asp:DropDownList>

            <label>Lesson Content</label>
            <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine"></asp:TextBox>

            <asp:Button ID="btnAddLesson" runat="server" Text="Add Lesson"
                CssClass="btn" OnClick="btnAddLesson_Click" />

            <br />
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </div>

        <div class="card">
            <h2>All Lessons</h2>

            <asp:GridView ID="gvLessons" runat="server" AutoGenerateColumns="False"
                CssClass="grid" GridLines="None"
                OnRowCommand="gvLessons_RowCommand">
                <Columns>
                    <asp:BoundField DataField="lessonID" HeaderText="Lesson ID" />
                    <asp:BoundField DataField="courseID" HeaderText="Course" />
                    <asp:BoundField DataField="instructorID" HeaderText="Instructor" />
                    <asp:BoundField DataField="type" HeaderText="Type" />
                    <asp:BoundField DataField="content" HeaderText="Content" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server"
                                CssClass="delete-btn"
                                CommandName="DeleteLesson"
                                CommandArgument='<%# Eval("lessonID") %>'
                                OnClientClick="return confirm('Delete this lesson?');">
                                Delete
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </main>

</form>
</body>
</html>