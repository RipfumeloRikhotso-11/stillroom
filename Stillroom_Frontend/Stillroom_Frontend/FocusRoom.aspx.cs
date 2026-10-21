using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stillroom_Frontend.ServiceReference1;

namespace Stillroom_Frontend
{
    public partial class FocusRoom : Page
    {
        private int UserID
        {
            get
            {
                return Convert.ToInt32(Session["UserID"]);
            }
        }

        private int ActiveSessionID
        {
            get
            {
                return Session["ActiveFocusSessionID"] == null
                    ? 0
                    : Convert.ToInt32(Session["ActiveFocusSessionID"]);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (ActiveSessionID > 0)
                {
                    pnlSetup.Visible = false;
                    pnlTimer.Visible = true;
                    pnlTasks.Visible = true;

                    lblGoal.Text = Server.HtmlEncode(
                        Convert.ToString(Session["ActiveFocusGoal"]));

                    int duration = Convert.ToInt32(
                        Session["ActiveFocusDuration"]);

                    hfDurationSeconds.Value = (duration * 60).ToString();

                    BindTasks();
                }
            }
        }

        protected void btnStart_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";

            string goal = txtGoal.Text.Trim();
            int duration;

            if (goal.Length == 0)
            {
                lblMessage.Text = "Please enter your study goal.";
                return;
            }

            if (!int.TryParse(ddlDuration.SelectedValue, out duration) ||
                (duration != 25 && duration != 45 && duration != 60))
            {
                lblMessage.Text = "Please choose a valid timer duration.";
                return;
            }

            StillroomClient client = null;

            try
            {
                client = new StillroomClient();

                int sessionID = client.StartSession(UserID, goal, duration);

                if (sessionID <= 0)
                {
                    lblMessage.Text =
                        "We couldn't start your session. Please check your details and try again.";
                    return;
                }

                Session["ActiveFocusSessionID"] = sessionID;
                Session["ActiveFocusGoal"] = goal;
                Session["ActiveFocusDuration"] = duration;

                pnlSetup.Visible = false;
                pnlTimer.Visible = true;
                pnlTasks.Visible = true;

                lblGoal.Text = Server.HtmlEncode(goal);
                hfDurationSeconds.Value = (duration * 60).ToString();

                BindTasks();

                lblMessage.Text = "Your focus session has been saved.";
            }
            catch (Exception)
            {
                lblMessage.Text =
                    "We couldn't connect to the focus service. Please try again.";
            }
            finally
            {
                CloseClient(client);
            }
        }

        protected void btnAddTask_Click(object sender, EventArgs e)
        {
            string description = txtTask.Text.Trim();

            if (ActiveSessionID <= 0)
            {
                lblTaskMessage.Text = "Start a focus session before adding tasks.";
                return;
            }

            if (description.Length == 0)
            {
                lblTaskMessage.Text = "Please enter a task.";
                return;
            }

            if (description.Length > 200)
            {
                lblTaskMessage.Text = "Tasks must be 200 characters or fewer.";
                return;
            }

            StillroomClient client = null;

            try
            {
                client = new StillroomClient();

                int taskID = client.AddTask(
                    UserID, ActiveSessionID, description);

                if (taskID > 0)
                {
                    txtTask.Text = "";
                    lblTaskMessage.Text = "Task added.";
                    BindTasks();
                }
                else
                {
                    lblTaskMessage.Text =
                        "The task could not be added. Please try again.";
                }
            }
            catch (Exception)
            {
                lblTaskMessage.Text =
                    "Unable to save the task. Please try again.";
            }
            finally
            {
                CloseClient(client);
            }
        }

        protected void rptTasks_ItemCommand(
            object source, RepeaterCommandEventArgs e)
        {
            int taskID;

            if (!int.TryParse(Convert.ToString(e.CommandArgument), out taskID)
                || taskID <= 0)
            {
                lblTaskMessage.Text = "Invalid task.";
                return;
            }

            StillroomClient client = null;

            try
            {
                client = new StillroomClient();

                bool success = false;

                if (e.CommandName == "CompleteTask")
                {
                    success = client.CompleteTask(UserID, taskID);
                    lblTaskMessage.Text = success
                        ? "Task completed!"
                        : "The task could not be completed.";
                }
                else if (e.CommandName == "DeleteTask")
                {
                    success = client.DeleteTask(UserID, taskID);
                    lblTaskMessage.Text = success
                        ? "Task deleted."
                        : "The task could not be deleted.";
                }

                BindTasks();
            }
            catch (Exception)
            {
                lblTaskMessage.Text =
                    "Unable to update the task. Please try again.";
            }
            finally
            {
                CloseClient(client);
            }
        }

        private void BindTasks()
        {
            if (ActiveSessionID <= 0)
            {
                rptTasks.DataSource = null;
                rptTasks.DataBind();
                return;
            }

            StillroomClient client = null;

            try
            {
                client = new StillroomClient();

                var tasks = client.GetSessionTasks(UserID, ActiveSessionID);

                rptTasks.DataSource = tasks;
                rptTasks.DataBind();
            }
            catch (Exception)
            {
                lblTaskMessage.Text =
                    "We couldn't load your tasks. Please refresh and try again.";
            }
            finally
            {
                CloseClient(client);
            }
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            if (ActiveSessionID <= 0)
            {
                Response.Redirect("~/Dashboard.aspx");
                return;
            }

            StillroomClient client = null;

            try
            {
                client = new StillroomClient();

                bool success = client.CompleteSession(
                    UserID, ActiveSessionID);

                if (success)
                {
                    Session.Remove("ActiveFocusSessionID");
                    Session.Remove("ActiveFocusGoal");
                    Session.Remove("ActiveFocusDuration");

                    Response.Redirect("~/Dashboard.aspx");
                }
                else
                {
                    lblMessage.Text =
                        "We couldn't finish your session. Please try again.";
                }
            }
            catch (Exception)
            {
                lblMessage.Text =
                    "Unable to finish your session right now. Please try again.";
            }
            finally
            {
                CloseClient(client);
            }
        }

        private void CloseClient(StillroomClient client)
        {
            if (client == null)
                return;

            try
            {
                if (client.State == System.ServiceModel.CommunicationState.Faulted)
                    client.Abort();
                else
                    client.Close();
            }
            catch
            {
                client.Abort();
            }
        }
    }
}
