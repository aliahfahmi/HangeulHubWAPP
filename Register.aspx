<%@ Page Title="Register"
Language="C#"
MasterPageFile="~/Site.Master"
AutoEventWireup="true"
CodeBehind="Register.aspx.cs"
Inherits="HangeulHubWAPP.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

<link rel="stylesheet" href="assets/css/register.css" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="register-page">

    <div class="register-container">

        <!-- LEFT PANEL -->

<div class="register-left">

    <div class="gradient-circle circle1"></div>
    <div class="gradient-circle circle2"></div>
    <div class="gradient-circle circle3"></div>

<div class="korean-bg">
    <span class="word1">안녕</span>
    <span class="word2">한국</span>
    <span class="word3">사랑</span>
</div>

</div>

        <!-- RIGHT PANEL -->

        <div class="register-right">

            <h2>Create Your Account</h2>

            <p class="subtitle">

                Start your Korean learning journey today.

            </p>

            <label>Full Name</label>

            <asp:TextBox
                ID="txtName"
                runat="server"
                CssClass="textbox">
            </asp:TextBox>

            <label>Email Address</label>

            <asp:TextBox
                ID="txtEmail"
                runat="server"
                CssClass="textbox"
                TextMode="Email">
            </asp:TextBox>

            <asp:RequiredFieldValidator
                ID="rfvEmail"
                runat="server"
                ControlToValidate="txtEmail"
                ErrorMessage="Email is required."
                ForeColor="Red"
                Display="Dynamic" />

            <asp:RegularExpressionValidator
                ID="RegularExpressionValidator1"
                runat="server"
                ControlToValidate="txtEmail"
                ValidationExpression="^[A-Za-z0-9._%+-]+@(student|instructor)\.edu$"
                ErrorMessage="Email must end with @student.edu or @instructor.edu."
                ForeColor="Red"
                Display="Dynamic"/>

            <label>Password</label>

            <div class="password-box">

            <asp:TextBox
                ID="txtPassword"
                runat="server"
                TextMode="Password"
                CssClass="textbox"
                ClientIDMode="Static">
            </asp:TextBox>

            <i class="fa fa-eye toggle-password"
                onclick="togglePassword('txtPassword', this)"></i>
            </div>

            <asp:RequiredFieldValidator
                ID="rfvPassword"
                runat="server"
                ControlToValidate="txtPassword"
                ErrorMessage="Password is required."
                ForeColor="Red"
                Display="Dynamic" />

            <asp:RegularExpressionValidator
                ID="revPassword"
                runat="server"
                ControlToValidate="txtPassword"
                ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$"
                ErrorMessage="Password must contain at least 8 characters, one uppercase letter, one lowercase letter and one number."
                ForeColor="Red"
                Display="Dynamic" />

            <label>Confirm Password</label>

            <div class="password-box">

            <asp:TextBox
                ID="txtConfirmPassword"
                runat="server"
                TextMode="Password"
                CssClass="textbox"
                ClientIDMode="Static">
            </asp:TextBox>

            <i class="fa fa-eye toggle-password"
                onclick="togglePassword('txtConfirmPassword', this)"></i>
            </div>
            <asp:RequiredFieldValidator
                ID="rfvConfirm"
                runat="server"
                ControlToValidate="txtConfirmPassword"
                ErrorMessage="Please confirm your password."
                ForeColor="Red"
                Display="Dynamic" />

            <asp:RequiredFieldValidator
                ID="rfvName"
                runat="server"
                ControlToValidate="txtName"
                ErrorMessage="Full Name is required."
                ForeColor="Red"
                Display="Dynamic" />

            <asp:CompareValidator
                ID="cvPassword"
                runat="server"
                ControlToValidate="txtConfirmPassword"
                ControlToCompare="txtPassword"
                ErrorMessage="Password does not match."
                ForeColor="Red"
                Display="Dynamic">
            </asp:CompareValidator>

            <label>Role</label>

            <asp:RadioButtonList
                ID="rblRole"
                runat="server"
                RepeatDirection="Horizontal"
                CssClass="role">

                <asp:ListItem Selected="True">
                    Student
                </asp:ListItem>

                <asp:ListItem>
                    Language Instructor
                </asp:ListItem>

            </asp:RadioButtonList>

            <label>Profile Picture (Optional)</label>

            <asp:FileUpload
                ID="fuProfile"
                runat="server"
                CssClass="textbox"
                onchange="previewImage(this);" />

            <br /><br />

            <img id="imgPreview"
                src="#"
                style="display:none;
                    width:140px;
                    height:140px;
                    border-radius:50%;
                    object-fit:cover;
                    border:4px solid #8261EE;
                    box-shadow:0 10px 30px rgba(0,0,0,.15);" />

            <asp:ValidationSummary
                    ID="vsRegister"
                    runat="server"
                    HeaderText="Please fix the following errors:"
                    ForeColor="Red"
                    CssClass="validation-summary" />
  
            <asp:Button
                    ID="btnRegister"
                    runat="server"
                    Text="Create Account"
                    CssClass="register-btn" OnClick="btnRegister_Click" />
            
            <br /><br />

            <asp:Label
                    ID="lblMessage"
                    runat="server"
                    ForeColor="Red"
                    Font-Bold="true">
            </asp:Label>

            <div class="bottom-link">

                Already have an account?

                <a href="Login.aspx">

                    Login Here

                </a>

            </div>

        </div>

    </div>

</div>

    <script>

        function previewImage(input) {

            if (input.files && input.files[0]) {

                const reader = new FileReader();

                reader.onload = function (e) {

                    document.getElementById("imgPreview").src = e.target.result;

                    document.getElementById("imgPreview").style.display = "block";

                };

                reader.readAsDataURL(input.files[0]);

            }

        }
        function togglePassword(id, icon) {

            var txt = document.getElementById(id);

            if (txt.type === "password") {
                txt.type = "text";

                icon.classList.remove("fa-eye");

                icon.classList.add("fa-eye-slash");
            }
            else {
                txt.type = "password";

                icon.classList.remove("fa-eye-slash");

                icon.classList.add("fa-eye");
            }

        }

    </script>
</asp:Content>