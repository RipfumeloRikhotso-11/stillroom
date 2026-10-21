
using System;
using System.Web.UI;

namespace Stillroom_Frontend
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }


        protected void btnSend_Click(object sender, EventArgs e)
        {
            Page.Validate("ContactForm");

            if (!Page.IsValid)
            {
                return;
            }

            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string subject = txtSubject.Text.Trim();
            string message = txtMessage.Text.Trim();

            if (name.Length > 100 ||
                email.Length > 254 ||
                subject.Length > 150 ||
                message.Length > 2000)
            {
                lblContactMessage.Text =
                    "One or more fields exceed the allowed length.";
                return;
            }

            ServiceReference1.StillroomClient client = null;

            try
            {
                client = new ServiceReference1.StillroomClient();

                bool saved = client.SendContactMessage(
                    name,
                    email,
                    subject,
                    message);

                client.Close();

                if (saved)
                {
                    lblContactMessage.Text =
                        "Thank you! Your message has been sent successfully.";

                    txtName.Text = "";
                    txtEmail.Text = "";
                    txtSubject.Text = "";
                    txtMessage.Text = "";
                }
                else
                {
                    lblContactMessage.Text =
                        "We couldn't send your message. Please try again.";
                }
            }
            catch (Exception ex)
            {
                if (client != null)
                {
                    try
                    {
                        client.Abort();
                    }
                    catch
                    {
                        // Ignore errors while closing the service client.
                    }
                }

                lblContactMessage.Text =
                   "Something went wrong while sending your message. Please try again.";
            }
        }

    }
}
