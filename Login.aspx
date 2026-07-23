<%@ Page Language="C#"
    AutoEventWireup="true"
    CodeBehind="Login.aspx.cs"
    Inherits="HangeulHubWAPP.Login" %>

<!DOCTYPE html>

<html>

<head runat="server">

    <title>Login | HangeulHub</title>

    <link href="assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/css/font-awesome.css" rel="stylesheet" />
    <link href="assets/css/templatemo-softy-pinko.css" rel="stylesheet" />
    <link href="assets/css/custom.css" rel="stylesheet" />
    <link href="assets/css/login.css" rel="stylesheet" />

</head>

<body class="login-body">
<form id="form1" runat="server">
<div class="login-container">

    <!-- LEFT PANEL -->

    <div class="left-panel">
        <img src="assets/images/LogoHangeulHub.png"
             class="logo" />
        <h1>Learn Korean<br />The Smart Way</h1>
        <p>
            Build your Korean skills through structured lessons,
            interactive quizzes and personalised progress tracking.
        </p>
        <div class="features">

        </div>
    </div>

    <!-- RIGHT PANEL -->

    <div class="right-panel">
        <div class="login-card">
            <h2>Welcome Back</h2>
            <p>
                Login to continue your learning journey.
            </p>

            <asp:TextBox
                ID="txtEmail"
                runat="server"
                CssClass="login-input"
                placeholder="Email Address">
            </asp:TextBox>

            <div class="password-box">

            <asp:TextBox
                ID="txtPassword"
                runat="server"
                TextMode="Password"
                CssClass="login-input"
                ClientIDMode="Static"
                placeholder="Password">
            </asp:TextBox>

            <i class="fa fa-eye toggle-password"
                onclick="togglePassword('txtPassword', this)"></i>

            </div>
            <asp:CheckBox
                ID="chkRemember"
                runat="server"
                Text="Remember Me" />

            <asp:Label
                ID="lblMessage"
                runat="server"
                CssClass="errorLabel">
            </asp:Label>

            <asp:Button
                ID="btnLogin"
                runat="server"
                Text="LOGIN"
                CssClass="login-btn"
                OnClick="btnLogin_Click">
            </asp:Button>

            <div class="text-center mt-4">

            <asp:HyperLink
                ID="lnkForgotPassword"
                runat="server"
                NavigateUrl="~/ForgotPassword.aspx"
                CssClass="forgot-link">

                Forgot Password?

            </asp:HyperLink>

                <br /><br />
                Don't have an account?
                <a href="Register.aspx">
                    Register
                </a>
            </div>
        </div>
    </div>
</form>
<script>

    function togglePassword(id, icon) {

        const txt = document.getElementById(id);

        if (txt.type === "password") {

            txt.type = "text";

            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");

        } else {

            txt.type = "password";

            icon.classList.remove("fa-eye-slash");
            icon.classList.add("fa-eye");

        }

    }
</script>
</body>
</html>
