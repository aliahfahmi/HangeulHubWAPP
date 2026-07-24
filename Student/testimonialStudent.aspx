<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestimonialStudent.aspx.cs" Inherits="HangeulHubWAPP.Student.TestimonialStudent" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Share Your Testimonial - HangeulHub</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', Arial, sans-serif;
            background-color: #f4f4fc;
            color: #222222;
        }

        /* TOP BAR */
        .dashboard-topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 40px;
            background-color: #ffffff;
        }

        .dashboard-topbar h2 { color: #222222; font-weight: 700; }

        .back-btn {
            padding: 10px 22px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;
            background-color: #7c5cfc;
            color: #ffffff;
        }

        .back-btn:hover { background-color: #6a4ae0; }

        /* PAGE CONTENT */
        .content-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 30px 20px 60px 20px;
        }

        .welcome-text { text-align: center; margin-bottom: 25px; }
        .welcome-text h1 { font-size: 30px; font-weight: 800; color: #222222; }
        .welcome-text h1 span { color: #7c5cfc; }
        .welcome-text p { margin-top: 8px; font-size: 15px; color: #666666; }

        /* FORM BOX */
        .form-box {
            width: 100%;
            max-width: 600px;
            background-color: #ffffff;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .form-box label {
            font-size: 13px;
            color: #666666;
            display: block;
            margin-bottom: 6px;
        }

        .testimonial-textbox {
            width: 100%;
            min-height: 130px;
            padding: 10px 12px;
            border: 1px solid #dddddd;
            border-radius: 6px;
            font-family: 'Poppins', Arial, sans-serif;
            font-size: 14px;
            resize: vertical;
            margin-bottom: 10px;
        }

        .error-message {
            color: #e74c3c;
            font-weight: 600;
            font-size: 13px;
            margin-bottom: 15px;
            display: block;
        }

        .submit-btn {
            padding: 12px 30px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 700;
            font-size: 14px;
            background-color: #7c5cfc;
            color: #ffffff;
        }

        .submit-btn:hover { background-color: #6a4ae0; }

        /* DONE MESSAGE */
        .done-box {
            width: 100%;
            max-width: 600px;
            text-align: center;
            background-color: #ffffff;
            border-radius: 12px;
            padding: 40px 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .done-box i {
            font-size: 40px;
            color: #7c5cfc;
            margin-bottom: 15px;
        }

        .done-box h2 {
            font-size: 22px;
            color: #222222;
            margin-bottom: 10px;
        }

        .done-box p {
            color: #666666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="dashboard-topbar">
            <h2>Share Your Testimonial</h2>
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="back-btn">Back to Dashboard</asp:LinkButton>
        </div>

        <section class="content-wrapper">

            <div class="welcome-text">
                <h1>Tell Us Your <span>Story</span></h1>
                <p>Share your experience learning Korean with HangeulHub.</p>
            </div>

            <!-- FORM PANEL - shown before submit -->
            <asp:Panel ID="pnlForm" runat="server" CssClass="form-box">

                <label>Your Testimonial</label>
                <asp:TextBox ID="txtTestimonial" runat="server" CssClass="testimonial-textbox" TextMode="MultiLine" placeholder="Share your experience..."></asp:TextBox>

                <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false"></asp:Label>

                <asp:Button ID="btnSubmit" runat="server" Text="Submit Testimonial" CssClass="submit-btn" OnClick="btnSubmit_Click" />

            </asp:Panel>

            <!-- DONE PANEL - shown after successful submit -->
            <asp:Panel ID="pnlDone" runat="server" CssClass="done-box" Visible="false">
                <i class="fa fa-check-circle"></i>
                <h2>Thank You!</h2>
                <p>Your testimonial has been submitted and is pending review.</p>
            </asp:Panel>

        </section>

    </form>
</body>
</html>