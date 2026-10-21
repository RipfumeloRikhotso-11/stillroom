
<%@ Page Title="Home | Stillroom" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Stillroom_Frontend._Default" %>

<asp:Content ID="HeadContentSection" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .home-hero {
            min-height: 480px;
            display: flex;
            align-items: center;
            padding: 55px;
            border-radius: 20px;
            overflow: hidden;
            background:
                linear-gradient(
                    90deg,
                    rgba(28, 48, 38, 0.88),
                    rgba(28, 48, 38, 0.18)
                ),
                url('<%= ResolveUrl("~/Content/images/hero-home.jpg") %>')
                center / cover no-repeat;
            color: white;
        }

        .home-hero-content {
            max-width: 550px;
        }

        .home-eyebrow {
            text-transform: uppercase;
            letter-spacing: 3px;
            font-size: 12px;
            font-weight: bold;
        }

        .home-hero h1 {
            font-family: Georgia, "Times New Roman", serif;
            font-size: clamp(38px, 5vw, 62px);
            line-height: 1.1;
            margin: 18px 0;
        }

        .home-hero p {
            line-height: 1.8;
            font-size: 16px;
        }

        .home-button {
            display: inline-block;
            margin-top: 18px;
            padding: 13px 24px;
            background: #e7e9d9;
            color: #2d493b;
            border-radius: 30px;
            text-decoration: none;
            font-weight: bold;
        }

        .home-button:hover {
            background: white;
        }

        .home-intro {
            padding: 45px 10px 20px;
            text-align: center;
        }

        .home-intro h2 {
            color: #35594b;
            font-family: Georgia, "Times New Roman", serif;
            font-size: 32px;
        }

        .home-intro p {
            color: #68746b;
            line-height: 1.8;
        }

        .home-features {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 22px;
            margin-top: 25px;
        }

        .feature-card {
            padding: 25px;
            background: white;
            border: 1px solid #e5e2d8;
            border-radius: 16px;
            text-align: center;
        }

        .feature-card img {
            width: 42px;
            height: 42px;
            object-fit: contain;
        }

        .feature-card h3 {
            color: #35594b;
            margin-bottom: 8px;
        }

        .feature-card p {
            color: #788078;
            font-size: 14px;
            line-height: 1.7;
        }

        @media (max-width: 700px) {
            .home-hero {
                min-height: 420px;
                padding: 28px;
            }

            .home-features {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContentSection" ContentPlaceHolderID="MainContent" runat="server">

    <section class="home-hero">
        <div class="home-hero-content">
            <div class="home-eyebrow">Your space to focus</div>

            <h1>Make space for what matters.</h1>

            <p>
                Find your rhythm, set your goals, and make progress
                one focused study session at a time.
            </p>

            <a href="<%= ResolveUrl("~/Register.aspx") %>" class="home-button">
                Start your journey
            </a>
        </div>
    </section>

    <section class="home-intro">
        <h2>A little more calm. A little more focus.</h2>

        <p>
            Create study sessions, organise your tasks, and build
            a routine that works for you.
        </p>
    </section>

    <section class="home-features">

        <div class="feature-card">
            <img src="<%= ResolveUrl("~/Content/images/timer-icon.png") %>"
                 alt="Timer" />
            <h3>Focus your time</h3>
            <p>Set a study duration and dedicate time to what matters.</p>
        </div>

        <div class="feature-card">
            <img src="<%= ResolveUrl("~/Content/images/tasks-icon.png") %>"
                 alt="Tasks" />
            <h3>Organise your tasks</h3>
            <p>Break your goals into smaller, manageable steps.</p>
        </div>

        <div class="feature-card">
            <img src="<%= ResolveUrl("~/Content/images/stats-icon.png") %>"
                 alt="Progress statistics" />
            <h3>Track your progress</h3>
            <p>Build a study habit by keeping track of your sessions.</p>
        </div>

    </section>

</asp:Content>
