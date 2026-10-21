
<%@ Page Title="Log In | Stillroom" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Login.aspx.cs"
    Inherits="Stillroom_Frontend.Login" %>

<asp:Content ID="LoginHead" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .login-section {
            max-width: 440px;
            margin: 55px auto;
            padding: 35px;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 30px rgba(0,0,0,.07);
        }

        .login-section h1 {
            color: #354638;
            margin-bottom: 10px;
        }

        .login-intro {
            color: #6c756c;
            margin-bottom: 25px;
        }

        .login-field {
            display: block;
            width: 100%;
            box-sizing: border-box;
            padding: 12px;
            margin: 8px 0 18px;
            border: 1px solid #d8ded5;
            border-radius: 8px;
        }

        .login-button {
            width: 100%;
            padding: 13px;
            background: #536b53;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }

        .login-button:hover {
            background: #405540;
        }

        .login-message {
            display: block;
            margin-top: 15px;
            overflow-wrap: anywhere;
        }

        .login-register {
            margin-top: 20px;
            text-align: center;
        }
    </style>
</asp:Content>

<asp:Content ID="LoginBody" ContentPlaceHolderID="MainContent" runat="server">
    <section class="login-section">
        <h1>Welcome back</h1>
        <p class="login-intro">Make some space for what matters today.</p>

        <asp:Label ID="lblEmail" runat="server"
            AssociatedControlID="txtEmail" Text="Email address" />
        <asp:TextBox ID="txtEmail" runat="server"
            CssClass="login-field" TextMode="Email" MaxLength="254" />

        <asp:Label ID="lblPassword" runat="server"
            AssociatedControlID="txtPassword" Text="Password" />
        <asp:TextBox ID="txtPassword" runat="server"
            CssClass="login-field" TextMode="Password" />

        <asp:Button ID="btnLogin" runat="server"
            Text="Log in"
            CssClass="login-button"
            OnClick="btnLogin_Click" />

        <asp:Label ID="lblMessage" runat="server"
            CssClass="login-message" role="status" />

        <p class="login-register">
            New to Stillroom?
            <a href="<%= ResolveUrl("~/Register.aspx") %>">Create an account</a>
        </p>
    </section>
</asp:Content>
