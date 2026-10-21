
<%@ Page Title="About Stillroom" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="About.aspx.cs"
    Inherits="Stillroom_Frontend.About" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .about-page {
            max-width: 1100px;
            margin: 40px auto;
            padding: 30px;
            color: #35483b;
        }

        .about-hero {
            min-height: 350px;
            display: flex;
            align-items: center;
            padding: 45px;
            border-radius: 24px;
            background:
                linear-gradient(
                    90deg,
                    rgba(247,248,242,.94),
                    rgba(247,248,242,.60)
                ),
                url('<%= ResolveUrl("~/Content/images/about.jpg") %>');
            background-size: cover;
            background-position: center;
            box-shadow: 0 8px 28px rgba(0,0,0,.08);
        }

        .about-hero-content {
            max-width: 600px;
        }

        .about-hero h1 {
            font-size: 46px;
            margin-bottom: 15px;
        }

        .about-hero p {
            font-size: 18px;
            line-height: 1.8;
        }

        .about-section {
            margin-top: 30px;
            padding: 30px;
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 5px 20px rgba(0,0,0,.05);
        }

        .about-section h2 {
            color: #536b57;
            margin-top: 0;
        }

        .about-section p {
            line-height: 1.9;
            color: #626e63;
        }

        .about-features {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-top: 22px;
        }

        .feature-card {
            padding: 24px;
            border-radius: 15px;
            background: #f2f5ef;
        }

        .feature-card h3 {
            color: #536b57;
        }

        .feature-card p {
            font-size: 14px;
        }

        .about-button {
            display: inline-block;
            margin-top: 15px;
            padding: 13px 22px;
            background: #536b57;
            color: white;
            text-decoration: none;
            border-radius: 10px;
        }

        .about-button:hover {
            background: #3e5542;
            color: white;
        }

        @media (max-width: 750px) {
            .about-page {
                padding: 15px;
                margin: 20px auto;
            }

            .about-hero {
                padding: 25px;
                min-height: 300px;
            }

            .about-hero h1 {
                font-size: 34px;
            }

            .about-features {
                grid-template-columns: 1fr;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <main class="about-page">

        <section class="about-hero">
            <div class="about-hero-content">
                <h1>A little more calm. A little more focus.</h1>

                <p>
                    Welcome to Stillroom, a peaceful study space designed
                    to help you slow down, organise your work and focus
                    on one task at a time.
                </p>

                <asp:HyperLink ID="lnkGetStarted" runat="server"
                    NavigateUrl="~/Dashboard.aspx"
                    CssClass="about-button">
                    Find Your Focus
                </asp:HyperLink>
            </div>
        </section>

        <section class="about-section">
            <h2>Our Story</h2>

            <p>
                Studying can sometimes feel overwhelming. Assignments,
                tests and deadlines can make it difficult to know where
                to begin. Stillroom was created around a simple idea:
                studying feels more manageable when you have a quiet
                space, a clear goal and a plan.
            </p>

            <p>
                Stillroom brings your study goals, focus sessions and
                tasks together in one place, helping you build a routine
                that works for you.
            </p>
        </section>

        <section class="about-section">
            <h2>Our Purpose</h2>

            <p>
                Our purpose is to make focused studying feel simpler
                and more achievable. You do not have to complete
                everything at once. You can begin with one goal,
                one task and one focused session.
            </p>
        </section>

        <section class="about-section">
            <h2>What You Can Do with Stillroom</h2>

            <div class="about-features">

                <div class="feature-card">
                    <h3>Focus Sessions</h3>
                    <p>
                        Set aside dedicated time for studying with
                        a timer that helps you stay on track.
                    </p>
                </div>

                <div class="feature-card">
                    <h3>Study Tasks</h3>
                    <p>
                        Break larger goals into smaller tasks and
                        mark them complete as you progress.
                    </p>
                </div>

                <div class="feature-card">
                    <h3>Track Progress</h3>
                    <p>
                        Keep track of completed study sessions and
                        see how your study time adds up.
                    </p>
                </div>

            </div>
        </section>

        <section class="about-section">
            <h2>Start Where You Are</h2>

            <p>
                You do not need a perfect plan to begin.
                Choose one thing you want to accomplish today
                and give it your attention.
            </p>

            <asp:HyperLink ID="lnkDashboardBottom" runat="server"
                NavigateUrl="~/Dashboard.aspx"
                CssClass="about-button">
                Go to My Dashboard
            </asp:HyperLink>
        </section>

    </main>

</asp:Content>
