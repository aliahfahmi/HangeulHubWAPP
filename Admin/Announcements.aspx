<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Announcements.aspx.cs" Inherits="HangeulHubWAPP.Admin.Announcements" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Announcements - HangeulHub</title>

    <!-- Google Font (Poppins) - loaded directly, no custom.css used -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome, for the small icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <!-- Shared confirmation modal styling (used across Admin pages) -->
    <link href="../Content/confirmModal.css" rel="stylesheet" />

    <style>

        /* ================================
           COLOUR SETTINGS (same palette as ManageUsers.aspx / ManageCourses.aspx)
           ================================ */
        /*
            Background color   : #f4f4fc  (light lavender)
            Purple accent color: #7c5cfc
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
           WELCOME SECTION
           ================================ */
        .dashboard-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;

            padding-top: 30px;
            padding-bottom: 40px;
            min-height: 150vh;   /* makes page tall enough to scroll down */
        }

        .welcome-text {
            text-align: center;
            margin-bottom: 25px;
        }

        .welcome-text h1 {
            font-size: 34px;
            font-weight: 800;
            color: #7c5cfc;                   /* <-- heading text color */
        }

        .welcome-text p {
            margin-top: 8px;
            font-size: 15px;
            color: #666666;                   /* <-- subtitle text color */
        }


        /* ================================
           NEW ANNOUNCEMENT FORM
           ================================ */
        .add-row {
            width: 100%;
            max-width: 950px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 22px;
            background-color: #ffffff;
            border-radius: 12px;
            padding: 20px 22px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .add-row input[type="text"],
        .add-row textarea {
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            padding: 10px 14px;
            border-radius: 6px;
            border: 1px solid #dddddd;
            color: #222222;
            background-color: #ffffff;
            width: 100%;
            resize: vertical;
        }

        .add-row-actions {
            display: flex;
            justify-content: flex-end;
        }

        .status-message {
            width: 100%;
            max-width: 950px;
            text-align: center;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 14px;
        }


        /* ================================
           ANNOUNCEMENTS TABLE (GridView)
           ================================ */
        .announcements-table {
            width: 100%;
            max-width: 950px;
            border-collapse: collapse;

            background-color: #ffffff;        /* <-- table background color */
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .announcements-table th {
            background-color: #7c5cfc;        /* <-- table header background color */
            font-weight: 700;
            font-size: 14px;
            padding: 14px 18px;
            text-align: left;
        }

        .announcements-table th a {
            color: #ffffff;                   /* <-- sortable header link color */
            text-decoration: none;
        }

        .filter-row {
            width: 100%;
            max-width: 950px;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            gap: 12px;
            margin-bottom: 22px;
        }

        .filter-row input[type="text"] {
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            padding: 9px 14px;
            border-radius: 6px;
            border: 1px solid #dddddd;
            flex: 1 1 220px;
        }

        .pager-row td {
            padding: 14px 18px;
            background-color: #f9f9fd;
        }

        .pager-row a,
        .pager-row span {
            font-size: 13px;
            font-weight: 600;
            margin-right: 10px;
            color: #7c5cfc;
            text-decoration: none;
        }

        .pager-row span {
            color: #222222;
        }

        .announcements-table td {
            padding: 14px 18px;
            font-size: 14px;
            color: #222222;                   /* <-- table cell text color */
            border-bottom: 1px solid #eeeeee;
            vertical-align: top;
        }

        .announcements-table tr:last-child td {
            border-bottom: none;
        }

        .announcements-table tr:hover td {
            background-color: #f7f5ff;        /* <-- row hover color */
        }

        .announcements-table input[type="text"],
        .announcements-table textarea {
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 13px;
            padding: 6px 8px;
            border-radius: 4px;
            border: 1px solid #dddddd;
            width: 100%;
            resize: vertical;
        }

        .content-cell {
            max-width: 320px;
            white-space: normal;
            line-height: 1.4;
        }

        .action-link {
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            margin-right: 10px;
            white-space: nowrap;
            color: #7c5cfc;
        }

        .action-link.delete {
            color: #e05555;
        }

        .empty-row {
            text-align: center;
            padding: 30px 18px;
            color: #999999;
            font-size: 14px;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- TOP BAR -->
        <div class="dashboard-topbar">
            <h2>Announcements</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="dashboard-wrapper">

            <!-- Heading -->
            <div class="welcome-text">
                <h1>Announcement Management</h1>
                <p>Post and manage platform-wide announcements visible to all users.</p>
            </div>

            <!-- New announcement form -->
            <div class="add-row">
                <asp:TextBox ID="txtNewTitle" runat="server" placeholder="Announcement title"></asp:TextBox>
                <asp:TextBox ID="txtNewContent" runat="server" TextMode="MultiLine" Rows="3" placeholder="Announcement content"></asp:TextBox>
                <div class="add-row-actions">
                    <asp:LinkButton ID="btnPost" runat="server" CssClass="back-btn" OnClick="btnPost_Click"
                        OnClientClick="return confirmAction('Post this announcement? It will be visible to all users.', this);">Post Announcement</asp:LinkButton>
                </div>
            </div>

            <!-- Search row -->
            <div class="filter-row">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by title or content..."></asp:TextBox>
                <asp:LinkButton ID="btnSearch" runat="server" CssClass="back-btn" OnClick="btnSearch_Click">Search</asp:LinkButton>
            </div>

            <!-- Only shows on error/success feedback -->
            <asp:Label ID="lblMessage" runat="server" CssClass="status-message"></asp:Label>

            <!-- GridView - bound manually in code-behind (BindGrid), same
                 ADO.NET style as ManageUsers.aspx.cs / ManageCourses.aspx.cs -->
            <asp:GridView ID="GridViewAnnouncements" runat="server"
                CssClass="announcements-table"
                AutoGenerateColumns="false"
                GridLines="None"
                DataKeyNames="AnnouncementID"
                AllowSorting="true"
                AllowPaging="true"
                PageSize="8"
                OnRowEditing="GridViewAnnouncements_RowEditing"
                OnRowUpdating="GridViewAnnouncements_RowUpdating"
                OnRowCancelingEdit="GridViewAnnouncements_RowCancelingEdit"
                OnRowDeleting="GridViewAnnouncements_RowDeleting"
                OnRowDataBound="GridViewAnnouncements_RowDataBound"
                OnSorting="GridViewAnnouncements_Sorting"
                OnPageIndexChanging="GridViewAnnouncements_PageIndexChanging">
                <Columns>
                    <asp:BoundField DataField="AnnouncementID" HeaderText="ID" ReadOnly="true" />
                    <asp:BoundField DataField="AuthorName" HeaderText="Posted By" ReadOnly="true" SortExpression="AuthorName" />
                    <asp:BoundField DataField="Title" HeaderText="Title" SortExpression="Title" />

                    <asp:TemplateField HeaderText="Content">
                        <ItemStyle CssClass="content-cell" />
                        <ItemTemplate><%# Eval("Content") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditContent" runat="server" TextMode="MultiLine" Rows="4"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="DatePosted" HeaderText="Posted On" DataFormatString="{0:dd/MM/yyyy}" ReadOnly="true" SortExpression="DatePosted" />

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CssClass="action-link" CommandName="Edit">Edit</asp:LinkButton>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton runat="server" CssClass="action-link"
                                CommandName="Update"
                                OnClientClick="return confirmAction('Save changes to this announcement?', this);">Update</asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="action-link" CommandName="Cancel">Cancel</asp:LinkButton>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CssClass="action-link delete"
                                CommandName="Delete"
                                OnClientClick="return confirmAction('Delete this announcement permanently?', this);">Delete</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="empty-row">No announcements posted yet.</div>
                </EmptyDataTemplate>

                <PagerStyle CssClass="pager-row" />
            </asp:GridView>

        </section>

    </form>

    <!-- Shared confirmation modal logic (used across Admin pages) -->
    <script src="../Scripts/jquery-3.7.0.min.js"></script>
    <script src="../Scripts/confirmModal.js"></script>
</body>
</html>
