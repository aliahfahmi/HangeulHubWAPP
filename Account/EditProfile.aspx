<%@ Page Title="" Language="C#" MasterPageFile="~/Account/Account.Master" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="HangeulHubWAPP.Account.EditProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="container mt-4">

    <div class="card shadow rounded-4 p-4">

        <div class="profile-header">
            <h1>
                <asp:Label ID="lblProfileName" runat="server"></asp:Label>'s Profile
            </h1>
        </div>

        <div class="text-center mb-4">
            <asp:Image ID="imgProfile" runat="server"
                Width="150px"
                Height="150px"
                CssClass="rounded-circle border" />

            <br /><br />

            <asp:FileUpload ID="fuProfile" runat="server" />
        </div>

        <div class="mb-3">
            <label>User ID</label>

            <asp:TextBox
                ID="txtUserID"
                runat="server"
                CssClass="form-control"
                ReadOnly="true">
            </asp:TextBox>
        </div>

        <div class="mb-3">
            <label>Full Name</label>

            <asp:TextBox
                ID="txtName"
                runat="server"
                CssClass="form-control">
            </asp:TextBox>
        </div>

        <div class="mb-3">
            <label>Email</label>

            <asp:TextBox
                ID="txtEmail"
                runat="server"
                CssClass="form-control">
            </asp:TextBox>
        </div>

        <div class="mb-3">
            <label>Password</label>

            <asp:TextBox
                ID="txtPassword"
                runat="server"
                TextMode="Password"
                CssClass="form-control">
            </asp:TextBox>
        </div>

        <div class="mb-3">
            <label>Role</label>

            <asp:TextBox
                ID="txtRole"
                runat="server"
                CssClass="form-control"
                ReadOnly="true">
            </asp:TextBox>
        </div>

        <div class="mb-4">
            <label>Status</label>

            <asp:TextBox
                ID="txtStatus"
                runat="server"
                CssClass="form-control"
                ReadOnly="true">
            </asp:TextBox>
        </div>

        <div class="text-center">

            <asp:Button
                ID="btnUpdate"
                runat="server"
                Text="Update Profile"
                CssClass="btn btn-primary px-5"
                OnClick="btnUpdate_Click"/>

        </div>

        <br />

        <asp:Label
            ID="lblMessage"
            runat="server"
            CssClass="text-success fw-bold">
        </asp:Label>

    </div>

</div>

</asp:Content>
