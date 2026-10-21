
using System;

namespace Stillroom_Frontend
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(password))
            {
                ShowMessage("Please enter your email and password.");
                return;
            }

            ServiceReference1.StillroomClient client = null;

            try
            {
                client = new ServiceReference1.StillroomClient();

                var result = client.Login(email, password);

                client.Close();
                client = null;

                if (result != null && result.Success)
                {
                    Session["UserID"] = result.UserID;
                    Session["FullName"] = result.FullName;
                    Session["Email"] = email;

                    Response.Redirect("~/Dashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                ShowMessage(
                    result == null
                        ? "Login failed. Please try again."
                        : result.Message
                );
            }
            catch (Exception)
            {
                if (client != null)
                {
                    client.Abort();
                }

                ShowMessage(
                    "We could not connect to Stillroom. Please try again."
                );
            }
        }

        private void ShowMessage(string message)
        {
            lblMessage.Text = Server.HtmlEncode(message);
        }
    }
}
