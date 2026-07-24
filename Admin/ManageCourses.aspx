<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageCourses.aspx.cs" Inherits="HangeulHubWAPP.Admin.ManageCourses" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Courses - HangeulHub</title>

    <!-- Google Font (Poppins) - loaded directly, no custom.css used -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome, for the small icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <!-- Shared confirmation modal styling (used across Admin pages) -->
    <link href="../Content/confirmModal.css" rel="stylesheet" />

    <style>

        /* ================================
           COLOUR SETTINGS (same palette as ManageUsers.aspx / Leaderboard.aspx)
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
           ADD COURSE ROW
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
            padding: 16px 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .add-row input[type="text"],
        .add-row select {
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            padding: 9px 14px;
            border-radius: 6px;
            border: 1px solid #dddddd;
            color: #222222;
            background-color: #ffffff;
        }

        .add-row input[type="text"] {
            flex: 1 1 220px;
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
           COURSES TABLE (GridView)
           ================================ */
        .courses-table {
            width: 100%;
            max-width: 900px;
            border-collapse: collapse;

            background-color: #ffffff;        /* <-- table background color */
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .courses-table th {
            background-color: #7c5cfc;        /* <-- table header background color */
            color: #ffffff;                   /* <-- table header text color */
            font-weight: 700;
            font-size: 14px;
            padding: 14px 18px;
            text-align: left;
        }

        .courses-table td {
            padding: 14px 18px;
            font-size: 14px;
            color: #222222;                   /* <-- table cell text color */
            border-bottom: 1px solid #eeeeee;
        }

        .courses-table tr:last-child td {
            border-bottom: none;
        }

        .courses-table tr:hover td {
            background-color: #f7f5ff;        /* <-- row hover color */
        }

        .courses-table select,
        .courses-table input[type="text"] {
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 13px;
            padding: 6px 8px;
            border-radius: 4px;
            border: 1px solid #dddddd;
        }

        .empty-row {
            text-align: center;
            padding: 30px 18px;
            color: #999999;
            font-size: 14px;
        }

        .action-link {
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            margin-right: 12px;
            color: #7c5cfc;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- TOP BAR -->
        <div class="dashboard-topbar">
            <h2>Manage Courses</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <!-- MAIN CONTENT SECTION -->
        <section class="dashboard-wrapper">

            <!-- Heading -->
            <div class="welcome-text">
                <h1>Course Management</h1>
                <p>View, edit, or add course levels offered on HangeulHub.</p>
            </div>

            <!-- Add course row -->
            <div class="add-row">
                <asp:DropDownList ID="ddlNewLevel" runat="server">
                    <asp:ListItem Text="Beginner" Value="Beginner" />
                    <asp:ListItem Text="Intermediate" Value="Intermediate" />
                    <asp:ListItem Text="Advanced" Value="Advanced" />
                </asp:DropDownList>

                <asp:TextBox ID="txtNewTitle" runat="server" placeholder="Course title (e.g. Beginner Korean)"></asp:TextBox>

                <asp:LinkButton ID="btnAddCourse" runat="server" CssClass="back-btn" OnClick="btnAddCourse_Click"
                    OnClientClick="return confirmAction('Add this new course?', this);">Add Course</asp:LinkButton>
            </div>

            <!-- Only shows on error/success feedback -->
            <asp:Label ID="lblMessage" runat="server" CssClass="status-message"></asp:Label>

            <!-- GridView - bound manually in code-behind (BindGrid), same
                 ADO.NET style as ManageUsers.aspx.cs -->
            <asp:GridView ID="GridViewCourses" runat="server"
                CssClass="courses-table"
                AutoGenerateColumns="false"
                GridLines="None"
                DataKeyNames="CourseID"
                OnRowEditing="GridViewCourses_RowEditing"
                OnRowUpdating="GridViewCourses_RowUpdating"
                OnRowCancelingEdit="GridViewCourses_RowCancelingEdit"
                OnRowDeleting="GridViewCourses_RowDeleting"
                OnRowDataBound="GridViewCourses_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="CourseID" HeaderText="Course ID" ReadOnly="true" />

                    <asp:TemplateField HeaderText="Level">
                        <ItemTemplate><%# Eval("Level") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditLevel" runat="server">
                                <asp:ListItem Text="Beginner" Value="Beginner" />
                                <asp:ListItem Text="Intermediate" Value="Intermediate" />
                                <asp:ListItem Text="Advanced" Value="Advanced" />
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Title" HeaderText="Title" />
                    <asp:BoundField DataField="LessonCount" HeaderText="Lessons" ReadOnly="true" />
                    <asp:BoundField DataField="QuizCount" HeaderText="Quizzes" ReadOnly="true" />

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CssClass="action-link" CommandName="Edit">Edit</asp:LinkButton>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton runat="server" CssClass="action-link"
                                CommandName="Update"
                                OnClientClick="return confirmAction('Save changes to this course?', this);">Update</asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="action-link" CommandName="Cancel">Cancel</asp:LinkButton>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" CssClass="action-link"
                                CommandName="Delete"
                                OnClientClick="return confirmAction('Delete this course? This only works if no lessons or quizzes are linked to it.', this);">Delete</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="empty-row">No courses found.</div>
                </EmptyDataTemplate>
            </asp:GridView>

        </section>

    </form>

    <!-- Shared confirmation modal logic (used across Admin pages) -->
    <script src="../Scripts/jquery-3.7.0.min.js"></script>
    <script src="../Scripts/confirmModal.js"></script>
</body>
</html>
