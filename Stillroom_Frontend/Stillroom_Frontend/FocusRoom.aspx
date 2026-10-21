
<%@ Page Title="Focus Room" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="FocusRoom.aspx.cs"
    Inherits="Stillroom_Frontend.FocusRoom" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .focus-room {
            max-width: 1000px;
            margin: 40px auto;
            padding: 35px;
            border-radius: 24px;
            background:
                linear-gradient(
                    rgba(247, 248, 242, 0.82),
                    rgba(247, 248, 242, 0.91)
                ),
                url('<%= ResolveUrl("~/Content/images/focus-room.jpg") %>');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        }

        .focus-heading {
            text-align: center;
            margin-bottom: 30px;
        }

        .focus-heading h1 {
            font-size: 38px;
            color: #35483b;
            margin-bottom: 10px;
        }

        .focus-heading p {
            color: #667367;
        }

        .focus-card {
            background: rgba(255,255,255,0.94);
            padding: 25px;
            border-radius: 18px;
            margin-bottom: 22px;
            box-shadow: 0 5px 18px rgba(0,0,0,0.05);
        }

        .timer {
            text-align: center;
        }

        .timer-display {
            font-size: 65px;
            font-weight: bold;
            color: #35483b;
            margin: 20px 0;
            font-variant-numeric: tabular-nums;
        }

        .focus-input {
            width: 100%;
            box-sizing: border-box;
            padding: 12px;
            margin: 8px 0 15px;
            border: 1px solid #d8dfd5;
            border-radius: 10px;
            font-size: 15px;
        }

        .focus-button {
            background: #536b57;
            color: white;
            border: none;
            padding: 12px 22px;
            border-radius: 10px;
            cursor: pointer;
            margin: 5px;
            font-size: 15px;
        }

        .focus-button:hover {
            background: #3e5542;
        }

        .secondary-button {
            background: #e7ede4;
            color: #35483b;
        }

        .secondary-button:hover {
            background: #d7e1d3;
        }

        .message {
            display: block;
            margin: 12px 0;
            color: #35483b;
        }

        .task-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid #edf0eb;
        }

        .task-text {
            overflow-wrap: anywhere;
        }

        .task-complete {
            color: #829083;
            text-decoration: line-through;
        }

        .small-button {
            padding: 7px 10px;
            font-size: 13px;
        }

        .back-link {
            display: inline-block;
            margin-top: 10px;
            color: #35483b;
            text-decoration: none;
            font-weight: bold;
        }

        @media (max-width: 600px) {
            .focus-room {
                margin: 20px 10px;
                padding: 18px;
            }

            .focus-heading h1 {
                font-size: 29px;
            }

            .timer-display {
                font-size: 48px;
            }

            .task-row {
                align-items: flex-start;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <main class="focus-room">

        <div class="focus-heading">
            <h1>Your Focus Room</h1>
            <p>A quiet space to work on what matters, one step at a time.</p>
        </div>

        <asp:Label ID="lblMessage" runat="server"
            CssClass="message" EnableViewState="false" />

        <asp:Panel ID="pnlSetup" runat="server" CssClass="focus-card">

            <h2>Prepare your session</h2>

            <label for="<%= txtGoal.ClientID %>">What would you like to focus on?</label>
            <asp:TextBox ID="txtGoal" runat="server"
                CssClass="focus-input"
                MaxLength="200"
                placeholder="e.g. Study networking chapter 4" />

            <label for="<%= ddlDuration.ClientID %>">Choose your focus time</label>
            <asp:DropDownList ID="ddlDuration" runat="server" CssClass="focus-input">
                <asp:ListItem Text="25 minutes" Value="25" />
                <asp:ListItem Text="45 minutes" Value="45" />
                <asp:ListItem Text="60 minutes" Value="60" />
            </asp:DropDownList>

            <asp:Button ID="btnStart" runat="server"
                Text="Start focusing"
                CssClass="focus-button"
                OnClick="btnStart_Click" />

        </asp:Panel>

        <asp:Panel ID="pnlTimer" runat="server" CssClass="focus-card timer"
            Visible="false">

            <h2>Stay present</h2>

            <asp:Label ID="lblGoal" runat="server" />

            <div id="timerDisplay" class="timer-display">25:00</div>

            <p id="timerStatus">Your session is ready.</p>

            <button type="button" id="btnPause" class="focus-button"
                onclick="togglePause()">Pause</button>

            <button type="button" id="btnReset" class="focus-button secondary-button"
                onclick="resetTimer()">Reset display</button>

            <asp:Button ID="btnFinish" runat="server"
                Text="Finish session"
                CssClass="focus-button"
                OnClick="btnFinish_Click"
                OnClientClick="return confirm('Finish this focus session?');" />

            <asp:HiddenField ID="hfEndTime" runat="server" />
            <asp:HiddenField ID="hfDurationSeconds" runat="server" />

        </asp:Panel>

        <asp:Panel ID="pnlTasks" runat="server" CssClass="focus-card"
            Visible="false">

            <h2>My study tasks</h2>
            <p>Add small tasks to help you reach your goal.</p>

            <asp:TextBox ID="txtTask" runat="server"
                CssClass="focus-input"
                MaxLength="200"
                placeholder="Enter a task..." />

            <asp:Button ID="btnAddTask" runat="server"
                Text="Add task"
                CssClass="focus-button"
                OnClick="btnAddTask_Click" />

            <asp:Repeater ID="rptTasks" runat="server"
                OnItemCommand="rptTasks_ItemCommand">

                <ItemTemplate>
                    <div class="task-row">
                        <span class='<%# Convert.ToBoolean(Eval("IsComplete")) ? "task-text task-complete" : "task-text" %>'>
                            <%#: Eval("TaskDescription") %>
                        </span>

                        <span>
                            <asp:Button ID="btnTaskComplete" runat="server"
                                Text='<%# Convert.ToBoolean(Eval("IsComplete")) ? "Completed" : "Complete" %>'
                                CommandName="CompleteTask"
                                CommandArgument='<%# Eval("TaskID") %>'
                                CssClass="focus-button small-button"
                                Enabled='<%# !Convert.ToBoolean(Eval("IsComplete")) %>' />

                            <asp:Button ID="btnTaskDelete" runat="server"
                                Text="Delete"
                                CommandName="DeleteTask"
                                CommandArgument='<%# Eval("TaskID") %>'
                                CssClass="focus-button secondary-button small-button"
                                OnClientClick="return confirm('Delete this task?');" />
                        </span>
                    </div>
                </ItemTemplate>

            </asp:Repeater>

            <asp:Label ID="lblTaskMessage" runat="server"
                CssClass="message" />

        </asp:Panel>

        <asp:HyperLink ID="lnkDashboard" runat="server"
            NavigateUrl="~/Dashboard.aspx" CssClass="back-link">
            ← Back to dashboard
        </asp:HyperLink>

    </main>

    <script>
        let timerInterval = null;
        let remainingSeconds = 0;
        let endTime = 0;
        let paused = false;
        let originalSeconds = 0;

        function displayTime() {
            const minutes = Math.floor(remainingSeconds / 60);
            const seconds = remainingSeconds % 60;

            document.getElementById("timerDisplay").textContent =
                String(minutes).padStart(2, "0") + ":" +
                String(seconds).padStart(2, "0");
        }

        function stopTimer() {
            if (timerInterval !== null) {
                clearInterval(timerInterval);
                timerInterval = null;
            }
        }

        function tick() {
            if (paused) return;

            remainingSeconds = Math.max(
                0, Math.ceil((endTime - Date.now()) / 1000)
            );

            displayTime();

            if (remainingSeconds <= 0) {
                stopTimer();
                document.getElementById("timerStatus").textContent =
                    "Time is up! Finish your session when you are ready.";
                document.getElementById("btnPause").disabled = true;
            }
        }

        function startClock() {
            stopTimer();
            paused = false;
            document.getElementById("btnPause").textContent = "Pause";
            document.getElementById("btnPause").disabled = false;

            endTime = Date.now() + remainingSeconds * 1000;

            document.getElementById("timerStatus").textContent =
                "You are focusing. Take it one step at a time.";

            tick();
            timerInterval = setInterval(tick, 250);
        }

        function togglePause() {
            if (remainingSeconds <= 0) return;

            if (!paused) {
                remainingSeconds = Math.max(
                    0, Math.ceil((endTime - Date.now()) / 1000)
                );
                paused = true;
                stopTimer();
                document.getElementById("btnPause").textContent = "Resume";
                document.getElementById("timerStatus").textContent =
                    "Timer paused. Take a breath.";
                displayTime();
            } else {
                startClock();
            }
        }

        function resetTimer() {
            stopTimer();
            remainingSeconds = originalSeconds;
            displayTime();
            document.getElementById("timerStatus").textContent =
                "Timer reset. Press Start on your session to begin again.";

            // Resetting the display does not change the saved database session.
            // Start the clock again using the remaining display time.
            startClock();
        }

        function initialiseTimer() {
            const durationField = document.getElementById(
                '<%= hfDurationSeconds.ClientID %>'
            );

            if (!durationField || !durationField.value) return;

            originalSeconds = parseInt(durationField.value, 10);
            remainingSeconds = originalSeconds;
            displayTime();
            startClock();
        }

        window.addEventListener("load", initialiseTimer);
    </script>

</asp:Content>
