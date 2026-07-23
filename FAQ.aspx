<%@ Page Title="FAQ" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="FAQ.aspx.cs"
    Inherits="HangeulHubWAPP.FAQ" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="assets/css/FAQ.css" rel="stylesheet" />

<section class="faq-header">

    <div class="container">

        <div class="text-center">

            <h1>Frequently Asked Questions</h1>

            <p>
                Find answers to the most common questions about learning Korean with HangeulHub.
            </p>

            <div class="faq-search">

                <input type="text"
                    class="form-control"
                    placeholder="Search FAQs..." />

            </div>

        </div>

    </div>

</section>

<section class="faq-section">

<div class="container">

    <h2 class="faq-category">
        📚 Learning
    </h2>

    <div class="faq-accordion">

        <!-- FAQ 1 -->

        <div class="faq-item">

            <div class="faq-question">

                <span>
                    How do I start learning Korean?
                </span>

                <span class="faq-toggle">
                    +
                </span>

            </div>

            <div class="faq-answer">

                Simply register for a free HangeulHub account
                and begin with our Beginner Korean course.

            </div>

        </div>

        <!-- FAQ 2 -->

        <div class="faq-item">

            <div class="faq-question">

                <span>
                    Are the lessons free?
                </span>

                <span class="faq-toggle">
                    +
                </span>

            </div>

            <div class="faq-answer">

                Guests can preview selected lessons.
                Register to unlock complete lessons,
                quizzes and progress tracking.

            </div>

        </div>

        <!-- FAQ 3 -->

        <div class="faq-item">

            <div class="faq-question">

                <span>
                    What learning levels are available?
                </span>

                <span class="faq-toggle">
                    +
                </span>

            </div>

            <div class="faq-answer">

                Beginner

                <br />

                Intermediate

                <br />

                Advanced

            </div>

        </div>

    </div>

        <!-- ======================= -->
    <!-- ACCOUNT -->
    <!-- ======================= -->

    <h2 class="faq-category">
        👤 Account
    </h2>

    <div class="faq-accordion">

        <div class="faq-item">

            <div class="faq-question">

                <span>Do I need an account?</span>

                <span class="faq-toggle">+</span>

            </div>

            <div class="faq-answer">

                Yes. A HangeulHub account is required to access
                quizzes, progress tracking and the discussion forum.

            </div>

        </div>

        <div class="faq-item">

            <div class="faq-question">

                <span>How do I register?</span>

                <span class="faq-toggle">+</span>

            </div>

            <div class="faq-answer">

                Click the <strong>Register</strong> button on the
                navigation bar and complete the registration form.

            </div>

        </div>

        <div class="faq-item">

            <div class="faq-question">

                <span>I forgot my password.</span>

                <span class="faq-toggle">+</span>

            </div>

            <div class="faq-answer">

                Click the <strong>Forgot Password</strong> option
                on the Login page to reset your password.

            </div>

        </div>

    </div>


    <!-- ======================= -->
    <!-- QUIZ -->
    <!-- ======================= -->

    <h2 class="faq-category">
        📝 Quiz & Progress
    </h2>

    <div class="faq-accordion">

        <div class="faq-item">

            <div class="faq-question">

                <span>Can guests attempt quizzes?</span>

                <span class="faq-toggle">+</span>

            </div>

            <div class="faq-answer">

                No. Only registered users can access quizzes
                and receive scores.

            </div>

        </div>

        <div class="faq-item">

            <div class="faq-question">

                <span>Is my learning progress saved?</span>

                <span class="faq-toggle">+</span>

            </div>

            <div class="faq-answer">

                Yes. Your learning progress is automatically
                tracked after you log in.

            </div>

        </div>

        <div class="faq-item">

            <div class="faq-question">

                <span>Can I retake quizzes?</span>

                <span class="faq-toggle">+</span>

            </div>

            <div class="faq-answer">

                Yes. You may retake quizzes based on the
                attempt limit set for each assessment.

            </div>

        </div>

    </div>

</div>


<script>

    document.addEventListener("DOMContentLoaded", function () {

        const items = document.querySelectorAll(".faq-item");

        items.forEach(function (item) {

            const question = item.querySelector(".faq-question");

            question.addEventListener("click", function () {

                const isActive = item.classList.contains("active");

                // Close all
                items.forEach(function (i) {

                    i.classList.remove("active");

                    i.querySelector(".faq-toggle").textContent = "+";

                });

                // Open selected
                if (!isActive) {

                    item.classList.add("active");

                    item.querySelector(".faq-toggle").textContent = "−";

                }

            });

        });

        const searchInput = document.querySelector(".faq-search input");

        searchInput.addEventListener("keyup", function () {

            let keyword = this.value.toLowerCase();

            document.querySelectorAll(".faq-item").forEach(item => {

                let question = item.querySelector(".faq-question").innerText.toLowerCase();

                if (question.includes(keyword))
                    item.style.display = "";
                else
                    item.style.display = "none";

            });

        });

    });

</script>
</asp:Content>