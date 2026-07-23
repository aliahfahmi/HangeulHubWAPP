<%@ Page Title="Home"
Language="C#"
MasterPageFile="~/Site.Master"
AutoEventWireup="true"
CodeBehind="Home.aspx.cs"
Inherits="HangeulHubWAPP.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="assets/css/custom.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<section class="hero-section">
    <div class="container">
        <div class="hero-center">

    <img src="assets/images/LogoHangeulHub.png"
         alt="HangeulHub Logo"
         class="hero-logo"/>

    <h1>
        Learn Korean<br>
        <span>The Smart & Fun Way</span>
    </h1>

    <p>
        Master Hangul, vocabulary, grammar and daily conversation
        through structured lessons, interactive quizzes
        and personalised progress tracking.
    </p>

    <div class="hero-buttons">

        <a href="Register.aspx"
           class="btn-primary-custom">
            Start Learning
        </a>

        <a href="Courses.aspx"
           class="btn-secondary-custom">
            View Courses
        </a>

    </div>


    </div>
</section>

<section class="features-section">
    <div class="container">

        <div class="section-title-custom">

            <!-- ***** Why user's choice ***** -->
<section id="about" class="community-section">

    <div class="container">

        <div class="community-box">

            <span class="community-tag">
                Trusted by Korean Learners
            </span>

            <h2>
                Why <span>2,000+</span> Students Choose HangeulHub
            </h2>

            <div class="rating">

                ★★★★★

                <span>4.9 Average Rating</span>

            </div>

            <p>
                Join thousands of learners improving their Korean
                through structured lessons, engaging quizzes,
                achievement badges and progress tracking.
            </p>

        </div>

    </div>

</section>
            <h2>Why Choose HangeulHub?</h2>
            <p>Everything you need to become confident in Korean.</p>
        </div>

        <div class="feature-grid">

            <div class="feature-card">
                <i class="fa fa-book"></i>
                <h4>Structured Lessons</h4>
                <p>Learn from Beginner to Advanced with organised modules.</p>
            </div>

            <div class="feature-card">
                <i class="fa fa-pencil"></i>
                <h4>Interactive Quizzes</h4>
                <p>Practice after every lesson with engaging quizzes.</p>
            </div>

            <div class="feature-card">
                <i class="fa fa-line-chart"></i>
                <h4>Track Progress</h4>
                <p>Monitor achievements and improve consistently.</p>
            </div>

            <div class="feature-card">
                <i class="fa fa-trophy"></i>
                <h4>Achievement Badges</h4>
                <p>Stay motivated by earning badges and join the leaderboard 🏆.</p>
            </div>

        </div>

    </div>
</section>

<section class="journey-section">
    <div class="container">

        <div class="section-title-custom">
            <h2>Your Learning Journey</h2>
        </div>

        <div class="journey-grid">

            <div class="journey-card">
                <h3>🌱 Beginner</h3>
                <p>Hangul • Pronunciation • Basic Alphabet</p>
            </div>

            <div class="journey-card">
                <h3>🌸 Intermediate</h3>
                <p>Pronunciation • Conversation • Intermediate Vocabulary</p>
            </div>

            <div class="journey-card">
                <h3>👑 Advanced</h3>
                <p>Reading • Writing • Advanced Grammar</p>
            </div>

        </div>

    </div>
</section>

<section class="cta-section">
    <div class="container">
        <h2>Ready to Begin Your Korean Journey?</h2>
        <p>Create your free account and start learning today.</p>
        <a href="Register.aspx" class="btn-primary-custom">Register Now</a>
    </div>
</section>

</asp:Content>