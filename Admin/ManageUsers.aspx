<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="HangeulHubWAPP.Admin.ManageUsers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Users - HangeulHub</title>

    <!-- Google Font (Poppins) - loaded directly, no custom.css used -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome, for the small icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <style>


        /* ================================
           COLOUR SETTINGS (same palette as AdminDashboard.aspx / StudentDashboard.aspx)
           ================================ */
        /*
            Background color   : #f4f4fc  (light lavender)
            Purple accent color: #7c5cfc
            Dark text color    : #222222
            Grey text color    : #666666
            White (cards/topbar): #ffffff
            Success/Active green: #2ecc71
            Inactive grey       : #b0b0b0
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
           TOP BAR (title + back + logout button)
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

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .back-link {
            font-size: 14px;
            font-weight: 600;
            color: #7c5cfc;                   /* <-- back link color */
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .logout-btn {
            padding: 10px 22px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;

            background-color: #7c5cfc;        /* <-- logout button background color */
            color: #ffffff;                   /* <-- logout button text color */
        }

        .logout-btn:hover {
            background-color: #6a4ae0;        /* <-- logout button hover color */
        }


        /* ================================
           PAGE WRAPPER
           ================================ */
        .content-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;

            padding: 30px 40px 50px 40px;
            min-height: 100vh;
        }

        .page-heading {
            width: 100%;
            max-width: 1100px;
            margin-bottom: 20px;
        }

        .page-heading h1 {
            font-size: 28px;
            font-weight: 800;
            color: #222222;
        }

        .page-heading h1 span {
            color: #7c5cfc;                   /* <-- accent purple word color */
        }

        .page-heading p {
            margin-top: 6px;
            font-size: 14px;
            color: #666666;
        }


        /* ================================
           FILTER BAR
           ================================ */
        .filter-bar {
            width: 100%;
            max-width: 1100px;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 14px;

            background-color: #ffffff;        /* <-- filter bar background color */
            border-radius: 12px;
            padding: 18px 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 24px;
        }

        .filter-bar input[type="text"],
        .filter-bar select {
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            padding: 9px 14px;
            border-radius: 6px;
            border: 1px solid #dcdcec;
            color: #222222;
            background-color: #f9f9fd;
        }

        .filter-bar input[type="text"] {
            flex: 1 1 220px;
        }

        .filter-bar select {
            flex: 0 0 auto;
        }

        .btn-primary {
            padding: 10px 20px;
            border-radius: 6px;
            border: none;
            font-family: 'Poppins', Arial, sans-serif;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;

            background-color: #7c5cfc;        /* <-- primary button background color */
            color: #ffffff;
        }

        .btn-primary:hover {
            background-color: #6a4ae0;
        }

        .btn-add {
            margin-left: auto;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;

            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 14px;

            background-color: #222222;        /* <-- "Add New User" button background color */
            color: #ffffff;
        }

        .btn-add:hover {
            background-color: #3a3a3a;
        }


        /* ================================
           TABLE CARD
           ================================ */
        .table-card {
            width: 100%;
            max-width: 1100px;

            background-color: #ffffff;        /* <-- table card background color */
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
        }

        .users-table th {
            text-align: left;
            font-size: 13px;
            font-weight: 700;
            color: #666666;
            text-transform: uppercase;
            letter-spacing: 0.4px;

            background-color: #f4f4fc;        /* <-- table header background color */
            padding: 14px 18px;
            border-bottom: 1px solid #eaeaf5;
        }

        .users-table td {
            font-size: 14px;
            color: #222222;
            padding: 14px 18px;
            border-bottom: 1px solid #f0f0f7;
            vertical-align: middle;
        }

        .users-table tr:last-child td {
            border-bottom: none;
        }

        .users-table tr:hover td {
            background-color: #faf9ff;
        }

        .profile-cell {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .profile-cell img {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            object-fit: cover;
            background-color: #eaeaf5;
        }

        .role-pill {
            display: inline-block;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
            background-color: #efe9ff;
            color: #7c5cfc;                   /* <-- role pill text color */
        }

        .status-pill {
            display: inline-block;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
        }

        .status-pill.active {
            background-color: #e6f9ee;
            color: #2ecc71;                   /* <-- active status color */
        }

        .status-pill.inactive {
            background-color: #f1f1f1;
            color: #999999;                   /* <-- inactive status color */
        }

        .action-link {
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            margin-right: 14px;
        }

        .action-link.edit {
            color: #7c5cfc;                   /* <-- edit action color */
        }

        .action-link.edit:hover {
            text-decoration: underline;
        }

        .action-link.toggle {
            color: #e05555;                   /* <-- deactivate/activate action color */
        }

        .action-link.toggle:hover {
            text-decoration: underline;
        }

        .empty-row td {
            text-align: center;
            color: #999999;
            padding: 30px 18px;
        }


        /* ================================
           PAGER
           ================================ */
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
            <div class="topbar-right">
                <a href="AdminDashboard.aspx" class="back-link"><i class="fa fa-arrow-left"></i> Back to Dashboard</a>
                <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-btn">Log Out</asp:LinkButton>
            </div>
        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="content-wrapper">

            <div class="page-heading">
                <h1>User <span>Management</span></h1>
                <p>View, search, edit, or deactivate student, instructor, and admin accounts.</p>
            </div>

            <!-- FILTER / SEARCH BAR -->
            <div class="filter-bar">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by name or email..."></asp:TextBox>

                <asp:DropDownList ID="ddlRoleFilter" runat="server">
                    <asp:ListItem Text="All Roles" Value="" />
                    <asp:ListItem Text="Student" Value="student" />
                    <asp:ListItem Text="Language Instructor" Value="instructor" />
                    <asp:ListItem Text="Admin" Value="admin" />
                </asp:DropDownList>

                <asp:DropDownList ID="ddlStatusFilter" runat="server">
                    <asp:ListItem Text="All Status" Value="" />
                    <asp:ListItem Text="Active" Value="Active" />
                    <asp:ListItem Text="Inactive" Value="Inactive" />
                </asp:DropDownList>

                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-primary" OnClick="btnSearch_Click" />

                <a href="AddUser.aspx" class="btn-add"><i class="fa fa-plus"></i> Add New User</a>
            </div>

            <!-- USERS TABLE -->
            <div class="table-card">
                <asp:GridView
                    ID="gvUsers"
                    runat="server"
                    CssClass="users-table"
                    AutoGenerateColumns="false"
                    GridLines="None"
                    AllowPaging="true"
                    PageSize="10"
                    OnPageIndexChanging="gvUsers_PageIndexChanging"
                    OnRowCommand="gvUsers_RowCommand"
                    DataKeyNames="UserID">

                    <Columns>

                        <asp:TemplateField HeaderText="User">
                            <ItemTemplate>
                                <div class="profile-cell">
                                    <img src='<%# "~/Images/Profiles/" + Eval("ProfilePicture") %>' alt="" />
                                    <div>
                                        <div><%# Eval("Name") %></div>
                                        <div style="font-size:12px;color:#999999;"><%# Eval("Email") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField HeaderText="User ID" DataField="UserID" />

                        <asp:TemplateField HeaderText="Role">
                            <ItemTemplate>
                                <span class="role-pill"><%# Eval("Role") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='status-pill <%# Eval("Status").ToString().ToLower() %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField HeaderText="Registered" DataField="RegisteredDate" DataFormatString="{0:dd/MM/yyyy}" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton
                                    runat="server"
                                    CssClass="action-link edit"
                                    CommandName="EditUser"
                                    CommandArgument='<%# Eval("UserID") %>'>Edit</asp:LinkButton>

                                <asp:LinkButton
                                    runat="server"
                                    CssClass="action-link toggle"
                                    CommandName="ToggleStatus"
                                    CommandArgument='<%# Eval("UserID") %>'
                                    OnClientClick="return confirm('Are you sure you want to change this user\'s status?');">
                                    <%# Eval("Status").ToString() == "Active" ? "Deactivate" : "Activate" %>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                    <EmptyDataTemplate>
                        <table class="users-table">
                            <tr class="empty-row"><td>No users found matching your search.</td></tr>
                        </table>
                    </EmptyDataTemplate>

                    <PagerStyle CssClass="pager-row" />

                </asp:GridView>
            </div>

        </section>

    </form>
</body>
</html>
