
<%@ Page Title="Create Account | Stillroom" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Register.aspx.cs"
    Inherits="Stillroom_Frontend.Register" %>

<asp:Content ID="RegisterHead" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .register-section {
            max-width: 480px;
            margin: 55px auto;
            padding: 35px;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 30px rgba(0,0,0,.07);
        }

        .register-section h1 {
            margin-bottom: 10px;
            color: #354638;
        }

        .register-intro {
            color: #6c756c;
            margin-bottom: 25px;
        }

        .register-field {
            display: block;
            width: 100%;
            box-sizing: border-box;
            padding: 12px;
            margin: 8px 0 18px;
            border: 1px solid #d8ded5;
            border-radius: 8px;
            font-size: 15px;
        }

        .register-button {
            width: 100%;
            padding: 13px;
            background: #536b53;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
        }

        .register-button:hover {
            background: #405540;
        }

        .register-message {
            display: block;
            margin-top: 15px;
            overflow-wrap: anywhere;
        }
    </style>
</asp:Content>

<asp:Content ID="RegisterBody" ContentPlaceHolderID="MainContent" runat="server">
    <section class="register-section">
        <h1>Create your account</h1>
        <p class="register-intro">
            Create a little space for focus, progress and better study habits.
        </p>

        <asp:Label ID="lblFullName" runat="server"
            AssociatedControlID="txtFullName" Text="Full name" />
        <asp:TextBox ID="txtFullName" runat="server"
            CssClass="register-field" MaxLength="100" />

        <asp:Label ID="lblEmail" runat="server"
            AssociatedControlID="txtEmail" Text="Email address" />
        <asp:TextBox ID="txtEmail" runat="server"
            CssClass="register-field" TextMode="Email" MaxLength="254" />

        <asp:Label ID="lblPassword" runat="server"
            AssociatedControlID="txtPassword" Text="Password" />
        <asp:TextBox ID="txtPassword" runat="server"
            CssClass="register-field" TextMode="Password" />

        <asp:Label ID="lblConfirmPassword" runat="server"
            AssociatedControlID="txtConfirmPassword"
            Text="Confirm password" />
        <asp:TextBox ID="txtConfirmPassword" runat="server"
            CssClass="register-field" TextMode="Password" />

        <asp:Button ID="btnRegister" runat="server"
            Text="Create account"
            CssClass="register-button"
            OnClick="btnRegister_Click"
            CausesValidation="true" />

        <asp:Label ID="lblMessage" runat="server"
            CssClass="register-message"
            role="status" />
    </section>
</asp:Content>
