
using System;
using System.ServiceModel;

namespace Stillroom_Frontend
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            if (string.IsNullOrWhiteSpace(fullName) ||
                string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(password) ||
                string.IsNullOrWhiteSpace(confirmPassword))
            {
                ShowMessage("Please complete every field.");
                return;
            }

            if (password.Length < 8)
            {
                ShowMessage("Your password must contain at least 8 characters.");
                return;
            }

            if (password != confirmPassword)
            {
                ShowMessage("Your passwords do not match.");
                return;
            }

            ServiceReference1.StillroomClient client = null;

            try
            {
                client = new ServiceReference1.StillroomClient();

                string result = client.Register(fullName, email, password);

                client.Close();
                client = null;

                ShowMessage(result);

                if (result == "Registration successful.")
                {
                    txtFullName.Text = "";
                    txtEmail.Text = "";
                    txtPassword.Text = "";
                    txtConfirmPassword.Text = "";
                }
            }
            catch (Exception)
            {
                if (client != null)
                    client.Abort();

                ShowMessage(
                    "Registration could not be completed. Please check the service connection and try again."
                );
            }
        }

        private void ShowMessage(string message)
        {
            lblMessage.Text = Server.HtmlEncode(message);
        }
    }
}
