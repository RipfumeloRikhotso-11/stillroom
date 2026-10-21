
<%@ Page Title="Contact Stillroom" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Contact.aspx.cs"
    Inherits="Stillroom_Frontend.Contact" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .contact-page {
            max-width: 1100px;
            margin: 40px auto;
            padding: 25px;
            color: #35483b;
        }

        .contact-hero {
            padding: 45px;
            min-height: 220px;
            display: flex;
            align-items: center;
            border-radius: 24px;
            background:
                linear-gradient(
                    rgba(247, 248, 242, .82),
                    rgba(247, 248, 242, .88)
                ),
                url('<%= ResolveUrl("~/Content/images/contact.jpg") %>');
            background-size: cover;
            background-position: center;
            box-shadow: 0 8px 28px rgba(0,0,0,.08);
        }

        .contact-hero h1 {
            font-size: 42px;
            margin: 0 0 12px;
        }

        .contact-hero p {
            font-size: 17px;
            line-height: 1.8;
            max-width: 650px;
        }

        .contact-layout {
            display: grid;
            grid-template-columns: 1fr 1.5fr;
            gap: 25px;
            margin-top: 25px;
        }

        .contact-card {
            background: #fff;
            padding: 28px;
            border-radius: 18px;
            box-shadow: 0 5px 20px rgba(0,0,0,.05);
        }

        .contact-card h2 {
            color: #536b57;
            margin-top: 0;
        }

        .contact-card p {
            line-height: 1.8;
            color: #667367;
        }

        .contact-label {
            display: block;
            font-weight: 600;
            margin: 15px 0 7px;
        }

        .contact-input {
            width: 100%;
            box-sizing: border-box;
            padding: 12px;
            border: 1px solid #d8dfd5;
            border-radius: 10px;
            font: inherit;
            background: #fcfdfb;
        }

        textarea.contact-input {
            min-height: 140px;
            resize: vertical;
        }

        .contact-input:focus {
            outline: 2px solid #9caf9b;
            border-color: #536b57;
        }

        .contact-button {
            margin-top: 18px;
            padding: 13px 24px;
            border: none;
            border-radius: 10px;
            background: #536b57;
            color: white;
            font-size: 15px;
            cursor: pointer;
        }

        .contact-button:hover {
            background: #3e5542;
        }

        .contact-message {
            display: block;
            margin-top: 15px;
            line-height: 1.6;
        }

        .validation-message {
            display: block;
            color: #a13d35;
            font-size: 13px;
            margin-top: 5px;
        }

        .contact-note {
            padding: 15px;
            background: #f2f5ef;
            border-radius: 12px;
            margin-top: 20px;
        }

        @media (max-width: 750px) {
            .contact-page {
                padding: 12px;
            }

            .contact-hero {
                padding: 25px;
            }

            .contact-hero h1 {
                font-size: 32px;
            }

            .contact-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <main class="contact-page">

        <section class="contact-hero">
            <div>
                <h1>Let's talk.</h1>
                <p>
                    Have a question, suggestion, or idea for Stillroom?
                    We'd love to hear from you. Send us a message below.
                </p>
            </div>
        </section>

        <div class="contact-layout">

            <section class="contact-card">
                <h2>Get in touch</h2>

                <p>
                    Stillroom is designed to make studying feel calmer
                    and more manageable. Your feedback can help us
                    improve the experience.
                </p>

                <div class="contact-note">
                    <strong>A little reminder</strong>
                    <p>
                        You don't have to figure everything out at once.
                        One question or one suggestion is a good place
                        to start.
                    </p>
                </div>

                <p>We appreciate you being part of Stillroom.</p>
            </section>

            <section class="contact-card">
                <h2>Send us a message</h2>

                <asp:ValidationSummary ID="vsContact" runat="server"
                    ValidationGroup="ContactForm"
                    CssClass="validation-message"
                    HeaderText="Please check the following:" />

                <asp:Label ID="lblContactMessage" runat="server"
                    CssClass="contact-message"
                    EnableViewState="false" />

                <asp:Label ID="lblName" runat="server"
                    Text="Your name"
                    AssociatedControlID="txtName"
                    CssClass="contact-label" />

                <asp:TextBox ID="txtName" runat="server"
                    CssClass="contact-input"
                    MaxLength="100"
                    placeholder="Enter your name" />

                <asp:RequiredFieldValidator ID="rfvName" runat="server"
                    ControlToValidate="txtName"
                    ValidationGroup="ContactForm"
                    ErrorMessage="Please enter your name."
                    CssClass="validation-message"
                    Display="Dynamic" />

                <asp:Label ID="lblEmail" runat="server"
                    Text="Email address"
                    AssociatedControlID="txtEmail"
                    CssClass="contact-label" />

                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="contact-input"
                    TextMode="Email"
                    MaxLength="254"
                    placeholder="you@example.com" />

                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationGroup="ContactForm"
                    ErrorMessage="Please enter your email address."
                    CssClass="validation-message"
                    Display="Dynamic" />

                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationGroup="ContactForm"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                    ErrorMessage="Please enter a valid email address."
                    CssClass="validation-message"
                    Display="Dynamic" />

                <asp:Label ID="lblSubject" runat="server"
                    Text="Subject"
                    AssociatedControlID="txtSubject"
                    CssClass="contact-label" />

                <asp:TextBox ID="txtSubject" runat="server"
                    CssClass="contact-input"
                    MaxLength="150"
                    placeholder="What would you like to discuss?" />

                <asp:RequiredFieldValidator ID="rfvSubject" runat="server"
                    ControlToValidate="txtSubject"
                    ValidationGroup="ContactForm"
                    ErrorMessage="Please enter a subject."
                    CssClass="validation-message"
                    Display="Dynamic" />

                <asp:Label ID="lblMessage" runat="server"
                    Text="Your message"
                    AssociatedControlID="txtMessage"
                    CssClass="contact-label" />

                <asp:TextBox ID="txtMessage" runat="server"
                    CssClass="contact-input"
                    TextMode="MultiLine"
                    MaxLength="2000"
                    placeholder="Write your message here..." />

                <asp:RequiredFieldValidator ID="rfvMessage" runat="server"
                    ControlToValidate="txtMessage"
                    ValidationGroup="ContactForm"
                    ErrorMessage="Please enter a message."
                    CssClass="validation-message"
                    Display="Dynamic" />

                <asp:Button
    ID="btnSend"
    runat="server"
    Text="Send Message"
    CssClass="contact-button"
    OnClick="btnSend_Click"
    ValidationGroup="ContactForm"
    CausesValidation="true" />

            </section>

        </div>

    </main>

</asp:Content>
