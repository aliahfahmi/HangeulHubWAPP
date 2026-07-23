<%@ Page Title="Courses"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Courses.aspx.cs"
    Inherits="HangeulHubWAPP.Courses" %>

<asp:Content ID="HeadContent"
    ContentPlaceHolderID="HeadContent"
    runat="server">

    <link href="assets/css/courses.css" rel="stylesheet" />

</asp:Content>

<asp:Content ID="MainContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="search-container">

    <asp:TextBox
        ID="txtSearch"
        runat="server"
        CssClass="search-box"
        placeholder="Search lessons, courses or topics...">
    </asp:TextBox>

    <asp:Button
        ID="btnSearch"
        runat="server"
        Text="Search"
        CssClass="search-btn"
        OnClick="btnSearch_Click" />

</div>
    <div class="filter-buttons">

    <asp:Button ID="btnAll"
        runat="server"
        Text="All"
        CssClass="filter-btn"
        OnClick="btnAll_Click" />

    <asp:Button ID="btnBeginner"
        runat="server"
        Text="Beginner"
        CssClass="filter-btn"
        OnClick="btnBeginner_Click" />

    <asp:Button ID="btnIntermediate"
        runat="server"
        Text="Intermediate"
        CssClass="filter-btn"
        OnClick="btnIntermediate_Click" />

    <asp:Button ID="btnAdvanced"
        runat="server"
        Text="Advanced"
        CssClass="filter-btn"
        OnClick="btnAdvanced_Click" />

</div>
<div class="course-grid">

    <asp:HiddenField ID="hfLessonID" runat="server" />

    <asp:Repeater
        ID="rptCourses"
        runat="server"
        OnItemCommand="rptCourses_ItemCommand">

        <ItemTemplate>

            <div class="course-card">

                <!-- Lesson Icon -->
                <div class="lesson-icon">
                    <%# Eval("type").ToString() == "Hangul" ? "한"
                        : Eval("type").ToString() == "Vocabulary" ? "단"
                        : "문" %>
                </div>

                <!-- Lesson Title -->
                <h3><%# Eval("lessonTitle") %></h3>

                <!-- Badges -->
                <div class="badge-row">

                    <span class='level-badge <%# Eval("level").ToString().ToLower() %>'>
                        <%# Eval("level") %>
                    </span>

                    <span class="type-badge">
                        <%# Eval("type") %>
                    </span>

                </div>

                <!-- Preview -->
                <p class="lesson-preview">

                    <%#
                        Eval("content").ToString().Length > 120
                        ? Eval("content").ToString().Substring(0,120) + "..."
                        : Eval("content").ToString()
                    %>

                </p>

                <!-- Buttons -->
                <div class="course-buttons">

                    <asp:Button
                        ID="btnPreview"
                        runat="server"
                        Text="View Details"
                        CssClass="preview-btn"
                        CommandName="Preview"
                        CommandArgument='<%# Eval("lessonID") %>' />

                    <a href="Register.aspx"
                        class="unlock-btn">

                        Register to Unlock

                    </a>

                </div>

            </div>

        </ItemTemplate>

    </asp:Repeater>
 </div>

<asp:Panel
    ID="pnlPreview"
    runat="server"
    CssClass="preview-modal"
    Visible="false">

    <div class="modal-content">

        <h2>

            <asp:Label
                ID="lblTitle"
                runat="server" />

        </h2>

        <p>

            <strong>Level :</strong>

            <asp:Label
                ID="lblLevel"
                runat="server" />

        </p>

        <p>

            <strong>Type :</strong>

            <asp:Label
                ID="lblType"
                runat="server" />

        </p>

        <hr />

        <p>

            <asp:Label
                ID="lblContent"
                runat="server" />

        </p>

        <br />

        <asp:HyperLink
            ID="lnkRegister"
            runat="server"
            NavigateUrl="Register.aspx"
            CssClass="unlock-btn">

            Register to Unlock

        </asp:HyperLink>

        <br /><br />

        <asp:Button
            ID="btnClose"
            runat="server"
            Text="Close"
            CssClass="preview-btn"
            OnClick="btnClose_Click" />

    </div>

</asp:Panel>
</asp:Content>