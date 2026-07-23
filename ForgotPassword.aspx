<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="HangeulHubWAPP.ForgotPassword" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Forgot Password | HangeulHub</title>

    <link href="assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/css/login.css" rel="stylesheet" />
    <link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

    <style>
        body {
            background: #f6f7fb;
        }

        .forgot-card {
            width: 420px;
            margin: 80px auto;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,.1);
        }

        h2{
            text-align:center;
            font-weight:bold;
            margin-bottom:10px;
        }

        .btn-purple{
            background:#7B5CF5;
            color:white;
            width:100%;
            border:none;
            border-radius:40px;
            padding:14px;
            font-weight:bold;
        }

        .btn-purple:hover{
            background:#6548e6;
        }

        .msg{
            color:red;
            text-align:center;
            margin-top:15px;
        }

        .success{
            color:green;
        }
    </style>

</head>

<body>

<form id="form1" runat="server">

<div class="forgot-card">

<h2>Forgot Password</h2>

<p class="text-center mb-4">
Enter your registered email and create a new password.
</p>

<asp:TextBox
ID="txtEmail"
runat="server"
CssClass="form-control mb-3"
placeholder="Email Address" />

<div class="input-group mb-3">

    <asp:TextBox
        ID="txtNewPassword"
        runat="server"
        TextMode="Password"
        CssClass="form-control"
        placeholder="New Password">
    </asp:TextBox>

    <span class="input-group-text password-icon"
          onclick="togglePassword('<%= txtNewPassword.ClientID %>', this)">

        <i class="fa-solid fa-eye"></i>

    </span>

</div>

<div class="input-group mb-4">

    <asp:TextBox
        ID="txtConfirmPassword"
        runat="server"
        TextMode="Password"
        CssClass="form-control"
        placeholder="Confirm Password">
    </asp:TextBox>

    <span class="input-group-text password-icon"
          onclick="togglePassword('<%= txtConfirmPassword.ClientID %>', this)">

        <i class="fa-solid fa-eye"></i>

    </span>

</div>

<asp:Button
ID="btnUpdate"
runat="server"
Text="UPDATE PASSWORD"
CssClass="btn-purple"
OnClick="btnUpdate_Click" />

<br /><br />

<div class="text-center">
<asp:HyperLink
ID="HyperLink1"
runat="server"
NavigateUrl="~/Login.aspx">
Back to Login
</asp:HyperLink>
</div>

<asp:Label
ID="lblMessage"
runat="server"
CssClass="msg" />

</div>

</form>
<script>

    function togglePassword(textboxId, element) {

        var textbox = document.getElementById(textboxId);
        var icon = element.querySelector("i");

        if (textbox.type === "password") {

            textbox.type = "text";

            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");

        }
        else {

            textbox.type = "password";

            icon.classList.remove("fa-eye-slash");
            icon.classList.add("fa-eye");

        }
    }

</script>
</body>
</html>
