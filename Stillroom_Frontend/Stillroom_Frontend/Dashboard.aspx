
<%@ Page Title="My Dashboard | Stillroom" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="Stillroom_Frontend.Dashboard" %>

<asp:Content ID="DashboardHead" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .dashboard {
            max-width: 1050px;
            margin: 45px auto;
            padding: 20px;
        }

        .dashboard h1 {
            color: #354638;
            margin-bottom: 8px;
        }

        .dashboard-intro {
            color: #6c756c;
            margin-bottom: 30px;
        }

        .dashboard-card {
            background: #fff;
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0,0,0,.06);
            margin-bottom: 20px;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
        }

        .dashboard-number {
            color: #536b53;
            font-size: 32px;
            font-weight: bold;
        }

        .dashboard-button {
            display: inline-block;
            padding: 12px 20px;
            background: #536b53;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
        }

        .dashboard-button:hover {
            background: #405540;
            color: white;
        }

        .dashboard-message {
            display: block;
            margin-top: 12px;
            color: #6c756c;
        }
    </style>
</asp:Content>

<asp:Content ID="DashboardBody" ContentPlaceHolderID="MainContent" runat="server">
    <main class="dashboard">
        <h1>Hello, <asp:Label ID="lblFullName" runat="server" />!</h1>

        <p class="dashboard-intro">
            Welcome to your Stillroom. Let's make today count.
        </p>

        <div class="dashboard-grid">
            <section class="dashboard-card">
                <h3>Your study time</h3>
                <div class="dashboard-number">
                    <asp:Label ID="lblStudyMinutes" runat="server" Text="0" />
                </div>
                <p>Completed study minutes</p>
                <asp:Label ID="lblStatsMessage" runat="server"
                    CssClass="dashboard-message" />
            </section>

            <section class="dashboard-card">
                <h3>Ready to focus?</h3>
                <p>Choose a goal and make time for your studies.</p>
                <asp:Button ID="btnStartFocus" runat="server"
                    Text="Start a focus session"
                    CssClass="dashboard-button"
                    OnClick="btnStartFocus_Click" />
            </section>
        </div>

        <section class="dashboard-card">
            <h3>Your next step</h3>
            <p>We'll add your focus timer, task list and study history here.</p>

            <asp:Button ID="btnLogout" runat="server"
                Text="Log out"
                CssClass="dashboard-button"
                OnClick="btnLogout_Click"
                CausesValidation="false" />
        </section>
    </main>
</asp:Content>
