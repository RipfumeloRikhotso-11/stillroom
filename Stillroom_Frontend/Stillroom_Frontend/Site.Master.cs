using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Stillroom_Frontend
{
    public partial class SiteMaster : MasterPage
    {
       
protected void Page_Load(object sender, EventArgs e)
        {
            bool loggedIn = Session["UserID"] != null;

            lnkLogin.Visible = !loggedIn;
            lnkRegister.Visible = !loggedIn;

            lnkDashboard.Visible = loggedIn;
            lnkFocusRoom.Visible = loggedIn;
            btnLogout.Visible = loggedIn;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("~/Login.aspx");
        }
    }
}