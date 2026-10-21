
using System;

namespace Stillroom_Frontend
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // A user must be logged in to see the dashboard.
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                lblFullName.Text =
                    Server.HtmlEncode(
                        Convert.ToString(Session["FullName"])
                    );

                LoadStudyStatistics();
            }
        }

        private void LoadStudyStatistics()
        {
            int userID = Convert.ToInt32(Session["UserID"]);

            ServiceReference1.StillroomClient client = null;

            try
            {
                client = new ServiceReference1.StillroomClient();

                int minutes = client.GetTotalStudyMinutes(userID);

                client.Close();
                client = null;

                lblStudyMinutes.Text = minutes.ToString();
            }
            catch (Exception)
            {
                if (client != null)
                {
                    client.Abort();
                }

                lblStatsMessage.Text =
                    "Study statistics are temporarily unavailable.";
            }
        }

        protected void btnStartFocus_Click(object sender, EventArgs e)
        {
            // We'll connect this button to the real focus room next.
            Response.Redirect("~/FocusRoom.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("~/Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
