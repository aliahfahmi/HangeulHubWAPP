<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="HangeulHubWAPP.Login" %>

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
            <div>📚 Structured Lessons</div>
            <div>📝 Interactive Quizzes</div>
            <div>🏆 Track Your Progress</div>
        </div>
    </div>

    <!-- RIGHT PANEL -->

    <div class="right-panel">
        <div class="login-card">
            <h2>Welcome Back 👋</h2>
            <p>
                Login to continue your learning journey.
            </p>

            <asp:TextBox
                ID="txtEmail"
                runat="server"
                CssClass="login-input"
                placeholder="Email Address">
            </asp:TextBox>

            <asp:TextBox
                ID="txtPassword"
                runat="server"
                TextMode="Password"
                CssClass="login-input"
                placeholder="Password">
            </asp:TextBox>
            <div class="remember">

            <asp:CheckBox
                ID="chkRemember"
                runat="server"
                Text="Remember Me" />
            </div>

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
                OnClick="btnLogin_Click" />

            <div class="bottom-links">
                <a href="#">Forgot Password?</a>
                <br /><br />
                Don't have an account?
                <a href="Register.aspx">
                    Register
                </a>
            </div>
        </div>
    </div>

</div>
</form>
</body>
</html>