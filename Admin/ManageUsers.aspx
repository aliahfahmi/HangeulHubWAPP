<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="HangeulHubWAPP.Admin.ManageUsers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Users - HangeulHub</title>

    <!-- Google Font (Poppins) - loaded directly, no custom.css used -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome, for the small icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <!-- Shared confirmation modal styling (used across Admin pages) -->
    <link href="../Content/confirmModal.css" rel="stylesheet" />

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
           ADD NEW USER FORM
           ================================ */
        .add-row {
            width: 100%;
            max-width: 900px;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            gap: 12px;
            margin-bottom: 22px;
            background-color: #ffffff;
            border-radius: 12px;
            padding: 18px 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .add-row input[type="text"],
        .add-row input[type="password"],
        .add-row select {
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            padding: 9px 14px;
            border-radius: 6px;
            border: 1px solid #dddddd;
            color: #222222;
            background-color: #ffffff;
        }


        /* ================================
           FILTER ROW (search + role/status dropdowns)
           ================================ */
        .filter-row {
            width: 100%;
            max-width: 900px;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            gap: 12px;
            margin-bottom: 22px;
        }

        .filter-row input[type="text"],
        .filter-row select {
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            padding: 9px 14px;
            border-radius: 6px;
            border: 1px solid #dddddd;
            color: #222222;
            background-color: #ffffff;
        }

        .status-message {
            width: 100%;
            max-width: 900px;
            text-align: center;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 14px;
        }


        /* ================================
           USERS TABLE (GridView)
           ================================ */
        .users-table {
            width: 100%;
            max-width: 900px;
            border-collapse: collapse;

            background-color: #ffffff;        /* <-- table background color */
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .users-table th {
            background-color: #7c5cfc;        /* <-- table header background color */
            font-weight: 700;
            font-size: 14px;
            padding: 14px 18px;
            text-align: left;
        }

        .users-table th a {
            color: #ffffff;                   /* <-- sortable header link color */
            text-decoration: none;
        }

        .users-table td {
            padding: 14px 18px;
            font-size: 14px;
            color: #222222;                   /* <-- table cell text color */
            border-bottom: 1px solid #eeeeee;
        }

        .users-table tr:last-child td {
            border-bottom: none;
        }

        .users-table tr:hover td {
            background-color: #f7f5ff;        /* <-- row hover color */
        }

        .users-table select,
        .users-table input[type="text"] {
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 13px;
            padding: 6px 8px;
            border-radius: 4px;
            border: 1px solid #dddddd;
        }

        .action-link {
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            margin-right: 12px;
            color: #7c5cfc;                   /* <-- action link color */
        }

        .action-link:hover {
            text-decoration: underline;
        }

        .empty-row {
            text-align: center;
            padding: 30px 18px;
            color: #999999;
            font-size: 14px;
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

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- TOP BAR -->
        <div class="dashboard-topbar">
            <h2>Manage Users</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="dashboard-wrapper">

            <!-- Heading -->
            <div class="welcome-text">
                <h1>User Management</h1>
                <p>View, search, edit, or deactivate student, instructor, and admin accounts.</p>
            </div>

            <!-- Add new user form -->
            <div class="add-row">
                <asp:TextBox ID="txtNewName" runat="server" placeholder="Full name"></asp:TextBox>
                <asp:TextBox ID="txtNewEmail" runat="server" placeholder="Email address"></asp:TextBox>
                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" placeholder="Password"></asp:TextBox>
                <asp:DropDownList ID="ddlNewRole" runat="server">
                    <asp:ListItem Text="Student" Value="Student" />
                    <asp:ListItem Text="Language Instructor" Value="Language Instructor" />
                    <asp:ListItem Text="Admin" Value="Admin" />
                </asp:DropDownList>
                <asp:LinkButton ID="btnAddUser" runat="server" CssClass="back-btn" OnClick="btnAddUser_Click"
                    OnClientClick="return confirmAction('Add this new user?', this);">Add User</asp:LinkButton>
            </div>

            <!-- Filter row -->
            <div class="filter-row">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by name or email..."></asp:TextBox>

                <asp:DropDownList ID="ddlRoleFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Text="All Roles" Value="" />
                    <asp:ListItem Text="Student" Value="Student" />
                    <asp:ListItem Text="Language Instructor" Value="Language Instructor" />
                    <asp:ListItem Text="Admin" Value="Admin" />
                </asp:DropDownList>

                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Text="All Status" Value="" />
                    <asp:ListItem Text="Active" Value="ACTIVE" />
                    <asp:ListItem Text="Inactive" Value="INACTIVE" />
                </asp:DropDownList>

                <asp:LinkButton ID="btnSearch" runat="server" CssClass="back-btn" OnClick="btnSearch_Click">Search</asp:LinkButton>
            </div>

            <!-- Only shows on error/success feedback -->
            <asp:Label ID="lblMessage" runat="server" CssClass="status-message"></asp:Label>

            <!-- GridView - bound manually in code-behind (BindGrid), same
                 ADO.NET style as Login.aspx.cs -->
            <asp:GridView ID="GridViewUsers" runat="server"
                CssClass="users-table"
                AutoGenerateColumns="false"
                GridLines="None"
                DataKeyNames="UserID"
                AllowSorting="true"
                AllowPaging="true"
                PageSize="8"
                OnRowEditing="GridViewUsers_RowEditing"
                OnRowUpdating="GridViewUsers_RowUpdating"
                OnRowCancelingEdit="GridViewUsers_RowCancelingEdit"
                OnRowDataBound="GridViewUsers_RowDataBound"
                OnSorting="GridViewUsers_Sorting"
                OnPageIndexChanging="GridViewUsers_PageIndexChanging">
                <Columns>
                    <asp:BoundField DataField="UserID" HeaderText="User ID" ReadOnly="true" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                    <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />

                    <asp:TemplateField HeaderText="Role" SortExpression="Role">
                        <ItemTemplate><%# Eval("Role") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditRole" runat="server">
                                <asp:ListItem Text="Student" Value="Student" />
                                <asp:ListItem Text="Language Instructor" Value="Language Instructor" />
                                <asp:ListItem Text="Admin" Value="Admin" />
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status" SortExpression="Status">
                        <ItemTemplate><%# Eval("Status") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditStatus" runat="server">
                                <asp:ListItem Text="Active" Value="ACTIVE" />
                                <asp:ListItem Text="Inactive" Value="INACTIVE" />
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="RegisteredDate" HeaderText="Registered" DataFormatString="{0:dd/MM/yyyy}" ReadOnly="true" SortExpression="RegisteredDate" />

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CssClass="action-link" CommandName="Edit">Edit</asp:LinkButton>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton runat="server" CssClass="action-link"
                                CommandName="Update"
                                OnClientClick="return confirmAction('Save changes to this user?', this);">Update</asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="action-link" CommandName="Cancel">Cancel</asp:LinkButton>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="empty-row">No users found matching your search.</div>
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
