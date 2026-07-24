<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Testimonials.aspx.cs" Inherits="HangeulHubWAPP.Admin.Testimonials" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Testimonials - HangeulHub</title>

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
           FILTER ROW
           ================================ */
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

        .filter-row select {
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            padding: 9px 14px;
            border-radius: 6px;
            border: 1px solid #dddddd;
            color: #222222;
            background-color: #ffffff;
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

        .status-message {
            width: 100%;
            max-width: 950px;
            text-align: center;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 14px;
        }


        /* ================================
           TESTIMONIALS TABLE (GridView)
           ================================ */
        .testimonials-table {
            width: 100%;
            max-width: 950px;
            border-collapse: collapse;

            background-color: #ffffff;        /* <-- table background color */
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .testimonials-table th {
            background-color: #7c5cfc;        /* <-- table header background color */
            font-weight: 700;
            font-size: 14px;
            padding: 14px 18px;
            text-align: left;
        }

        .testimonials-table th a {
            color: #ffffff;                   /* <-- sortable header link color */
            text-decoration: none;
        }

        .testimonials-table td {
            padding: 14px 18px;
            font-size: 14px;
            color: #222222;                   /* <-- table cell text color */
            border-bottom: 1px solid #eeeeee;
            vertical-align: top;
        }

        .testimonials-table tr:last-child td {
            border-bottom: none;
        }

        .testimonials-table tr:hover td {
            background-color: #f7f5ff;        /* <-- row hover color */
        }

        .content-cell {
            max-width: 340px;
            white-space: normal;
            line-height: 1.4;
        }

        .status-pill {
            display: inline-block;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
            white-space: nowrap;
        }

        .status-pill.pending {
            background-color: #fff4e0;
            color: #cc8b00;                   /* <-- pending status color */
        }

        .status-pill.approved {
            background-color: #e6f9ee;
            color: #2ecc71;                   /* <-- approved status color */
        }

        .status-pill.rejected {
            background-color: #fdeaea;
            color: #e05555;                   /* <-- rejected status color */
        }

        .action-link {
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            margin-right: 10px;
            white-space: nowrap;
        }

        .action-link.approve {
            color: #2ecc71;
        }

        .action-link.reject {
            color: #e05555;
        }

        .action-link.delete {
            color: #999999;
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
            <h2>Manage Testimonials</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="dashboard-wrapper">

            <!-- Heading -->
            <div class="welcome-text">
                <h1>Testimonial Management</h1>
                <p>Approve or reject feedback submitted by students before it appears publicly.</p>
            </div>

            <!-- Filter row -->
            <div class="filter-row">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by student name or content..."></asp:TextBox>

                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Text="All Status" Value="" />
                    <asp:ListItem Text="Pending" Value="PENDING" />
                    <asp:ListItem Text="Approved" Value="APPROVED" />
                    <asp:ListItem Text="Rejected" Value="REJECTED" />
                </asp:DropDownList>

                <asp:LinkButton ID="btnSearch" runat="server" CssClass="back-btn" OnClick="btnSearch_Click">Search</asp:LinkButton>
            </div>

            <!-- Only shows on error/success feedback -->
            <asp:Label ID="lblMessage" runat="server" CssClass="status-message"></asp:Label>

            <!-- GridView - bound manually in code-behind (BindGrid), same
                 ADO.NET style as ManageUsers.aspx.cs / ManageCourses.aspx.cs -->
            <asp:GridView ID="GridViewTestimonials" runat="server"
                CssClass="testimonials-table"
                AutoGenerateColumns="false"
                GridLines="None"
                DataKeyNames="TestimonialID"
                AllowSorting="true"
                AllowPaging="true"
                PageSize="8"
                OnRowCommand="GridViewTestimonials_RowCommand"
                OnSorting="GridViewTestimonials_Sorting"
                OnPageIndexChanging="GridViewTestimonials_PageIndexChanging">
                <Columns>
                    <asp:BoundField DataField="TestimonialID" HeaderText="ID" />
                    <asp:BoundField DataField="StudentName" HeaderText="Student" SortExpression="StudentName" />

                    <asp:TemplateField HeaderText="Content">
                        <ItemStyle CssClass="content-cell" />
                        <ItemTemplate><%# Eval("Content") %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status" SortExpression="Status">
                        <ItemTemplate>
                            <span class='status-pill <%# Eval("Status").ToString().ToLower() %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CssClass="action-link approve"
                                CommandName="Approve"
                                CommandArgument='<%# Eval("TestimonialID") %>'
                                Visible='<%# Eval("Status").ToString() != "APPROVED" %>'
                                OnClientClick="return confirmAction('Approve this testimonial? It will become visible to guests.', this);">Approve</asp:LinkButton>

                            <asp:LinkButton runat="server" CssClass="action-link reject"
                                CommandName="Reject"
                                CommandArgument='<%# Eval("TestimonialID") %>'
                                Visible='<%# Eval("Status").ToString() != "REJECTED" %>'
                                OnClientClick="return confirmAction('Reject this testimonial?', this);">Reject</asp:LinkButton>

                            <asp:LinkButton runat="server" CssClass="action-link delete"
                                CommandName="DeleteTestimonial"
                                CommandArgument='<%# Eval("TestimonialID") %>'
                                OnClientClick="return confirmAction('Delete this testimonial permanently?', this);">Delete</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="empty-row">No testimonials found.</div>
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
