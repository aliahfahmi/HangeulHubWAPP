<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ManageUsers.aspx.cs" Inherits="HangeulHubWAPP.Admin.ManageUsers" %>

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
            color: #ffffff;                   /* <-- table header text color */
            font-weight: 700;
            font-size: 14px;
            padding: 14px 18px;
            text-align: left;
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

            <!-- Filter row -->
            <div class="filter-row">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by name or email..."></asp:TextBox>

                <asp:DropDownList ID="ddlRoleFilter" runat="server" AutoPostBack="true">
                    <asp:ListItem Text="All Roles" Value="" />
                    <asp:ListItem Text="Student" Value="Student" />
                    <asp:ListItem Text="Language Instructor" Value="Language Instructor" />
                    <asp:ListItem Text="Admin" Value="Admin" />
                </asp:DropDownList>

                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true">
                    <asp:ListItem Text="All Status" Value="" />
                    <asp:ListItem Text="Active" Value="ACTIVE" />
                    <asp:ListItem Text="Inactive" Value="INACTIVE" />
                </asp:DropDownList>

                <asp:LinkButton ID="btnSearch" runat="server" CssClass="back-btn">Search</asp:LinkButton>
            </div>

            <!-- GridView - fully declarative: edit/update/cancel and data
                 binding all handled by SqlDataSourceUsers below, same
                 "wire it up, no code-behind" approach as Leaderboard.aspx -->
            <asp:GridView ID="GridViewUsers" runat="server"
                CssClass="users-table"
                AutoGenerateColumns="false"
                GridLines="None"
                DataSourceID="SqlDataSourceUsers"
                DataKeyNames="UserID">
                <Columns>
                    <asp:BoundField DataField="UserID" HeaderText="User ID" ReadOnly="true" />
                    <asp:BoundField DataField="Name" HeaderText="Name" />
                    <asp:BoundField DataField="Email" HeaderText="Email" />

                    <asp:TemplateField HeaderText="Role">
                        <ItemTemplate><%# Eval("Role") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditRole" runat="server" SelectedValue='<%# Bind("Role") %>'>
                                <asp:ListItem Text="Student" Value="Student" />
                                <asp:ListItem Text="Language Instructor" Value="Language Instructor" />
                                <asp:ListItem Text="Admin" Value="Admin" />
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate><%# Eval("Status") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditStatus" runat="server" SelectedValue='<%# Bind("Status") %>'>
                                <asp:ListItem Text="Active" Value="ACTIVE" />
                                <asp:ListItem Text="Inactive" Value="INACTIVE" />
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="RegisteredDate" HeaderText="Registered" DataFormatString="{0:dd/MM/yyyy}" ReadOnly="true" />

                    <asp:CommandField ShowEditButton="true" ShowCancelButton="true" />
                </Columns>
            </asp:GridView>

            <!-- Data source for GridViewUsers - handles both the filtered
                 select and the row update, no C# needed for either.
                 Update the ConnectionString name to match your Web.config. -->
            <asp:SqlDataSource ID="SqlDataSourceUsers" runat="server"
                ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                OldValuesParameterFormatString="{0}"
                SelectCommand="SELECT UserID, name AS Name, email AS Email, role AS Role, stat AS Status, regdate AS RegisteredDate FROM userTable WHERE (@search = '' OR name LIKE '%' + @search + '%' OR email LIKE '%' + @search + '%') AND (@role = '' OR role = @role) AND (@status = '' OR stat = @status) ORDER BY regdate DESC"
                UpdateCommand="UPDATE userTable SET name=@Name, email=@Email, role=@Role, stat=@Status WHERE UserID=@UserID">
                <SelectParameters>
                    <asp:ControlParameter Name="search" ControlID="txtSearch" PropertyName="Text" DefaultValue="" />
                    <asp:ControlParameter Name="role" ControlID="ddlRoleFilter" PropertyName="SelectedValue" DefaultValue="" />
                    <asp:ControlParameter Name="status" ControlID="ddlStatusFilter" PropertyName="SelectedValue" DefaultValue="" />
                </SelectParameters>
            </asp:SqlDataSource>

        </section>

    </form>
</body>
</html>