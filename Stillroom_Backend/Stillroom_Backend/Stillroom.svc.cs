using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace Stillroom_Backend
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select Service1.svc or Service1.svc.cs at the Solution Explorer and start debugging.
    public class Service1 : IStillroom
    {
        // Create a LINQ to SQL database connection.
        private StillroomDataContext GetDatabase()
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings[
                    "StillroomConnection"
                ].ConnectionString;

            return new StillroomDataContext(connectionString);
        }

        // ==========================================
        // 1. REGISTER
        // ==========================================
        public string Register(
            string fullName,
            string email,
            string password)
        {
            if (string.IsNullOrWhiteSpace(fullName) ||
                string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(password))
            {
                return "Please complete all fields.";
            }

            if (password.Length < 8)
            {
                return "Password must contain at least 8 characters.";
            }

            fullName = fullName.Trim();
            email = email.Trim();

            try
            {
                using (StillroomDataContext db = GetDatabase())
                {
                    bool emailExists = db.USERs.Any(
                        u => u.Email == email
                    );

                    if (emailExists)
                    {
                        return "An account with this email already exists.";
                    }

                    USER newUser = new USER();

                    newUser.FullName = fullName;
                    newUser.Email = email;

                    // Store a password hash, not the original password.
                    newUser.PasswordHash =
                        SecrecyHash.hashFunction(password);

                    newUser.CreatedAt = DateTime.Now;
                    newUser.IsActive = true;

                    db.USERs.InsertOnSubmit(newUser);
                    db.SubmitChanges();

                    // Create default settings for the new user.
                    APP_SETTING settings = new APP_SETTING();

                    settings.UserID = newUser.UserID;
                    settings.TimerMinutes = 25;
                    settings.AmbientSound = "rain";
                    settings.Volume = 30;

                    db.APP_SETTINGs.InsertOnSubmit(settings);
                    db.SubmitChanges();

                    return "Registration successful.";
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2601 || ex.Number == 2627)
                {
                    return "An account with this email already exists.";
                }

                return "Registration failed. Please try again.";
            }
        }

        // ==========================================
        // 2. LOGIN
        // ==========================================
        public LoginResult Login(string email, string password)
        {
            LoginResult result = new LoginResult();

            result.Success = false;
            result.UserID = 0;
            result.FullName = "";
            result.Message = "Invalid email or password.";

            if (string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(password))
            {
                result.Message = "Please enter your email and password.";
                return result;
            }

            using (StillroomDataContext db = GetDatabase())
            {
                USER user = db.USERs.SingleOrDefault(
                    u => u.Email == email.Trim()
                );

                if (user == null || !user.IsActive)
                {
                    return result;
                }

                bool passwordCorrect =
                    SecrecyHash.verifyPassword(
                        password,
                        user.PasswordHash
                    );

                if (passwordCorrect)
                {
                    result.Success = true;
                    result.UserID = user.UserID;
                    result.FullName = user.FullName;
                    result.Message = "Login successful.";
                }

                return result;
            }
        }

        // ==========================================
        // 3. START A FOCUS SESSION
        // ==========================================
        public int StartSession(
            int userID,
            string goal,
            int durationMinutes)
        {
            if (userID <= 0 ||
                string.IsNullOrWhiteSpace(goal) ||
                durationMinutes <= 0 ||
                durationMinutes > 480)
            {
                return -1;
            }

            using (StillroomDataContext db = GetDatabase())
            {
                bool userExists = db.USERs.Any(
                    u => u.UserID == userID && u.IsActive
                );

                if (!userExists)
                {
                    return -1;
                }

                FOCUS_SESSION session = new FOCUS_SESSION();

                session.UserID = userID;
                session.SessionGoal = goal.Trim();
                session.DurationMinutes = durationMinutes;
                session.StartedAt = DateTime.Now;
                session.CompletedAt = null;

                db.FOCUS_SESSIONs.InsertOnSubmit(session);
                db.SubmitChanges();

                // Return the new session's ID.
                return session.SessionID;
            }
        }

        // ==========================================
        // 4. COMPLETE A FOCUS SESSION
        // ==========================================
        public bool CompleteSession(int userID, int sessionID)
        {
            using (StillroomDataContext db = GetDatabase())
            {
                FOCUS_SESSION session =
                    db.FOCUS_SESSIONs.SingleOrDefault(
                        s => s.SessionID == sessionID &&
                             s.UserID == userID &&
                             s.CompletedAt == null
                    );

                if (session == null)
                {
                    return false;
                }

                session.CompletedAt = DateTime.Now;

                db.SubmitChanges();

                return true;
            }
        }

        // ==========================================
        // 5. GET SESSION HISTORY
        // ==========================================
        public List<FocusSession> GetSessionHistory(int userID)
        {
            using (StillroomDataContext db = GetDatabase())
            {
                return db.FOCUS_SESSIONs
                    .Where(s => s.UserID == userID)
                    .OrderByDescending(s => s.StartedAt)
                    .Select(s => new FocusSession
                    {
                        SessionID = s.SessionID,
                        SessionGoal = s.SessionGoal,
                        DurationMinutes = s.DurationMinutes,
                        StartedAt = s.StartedAt,
                        CompletedAt = s.CompletedAt
                    })
                    .ToList();
            }
        }

        // ==========================================
        // 6. GET TOTAL COMPLETED STUDY MINUTES
        // ==========================================
        public int GetTotalStudyMinutes(int userID)
        {
            using (StillroomDataContext db = GetDatabase())
            {
                int total = db.FOCUS_SESSIONs
                    .Where(s => s.UserID == userID &&
                                s.CompletedAt != null)
                    .Select(s => (int?)s.DurationMinutes)
                    .Sum() ?? 0;

                return total;
            }
        }

        // ==========================================
        // 7. ADD A TASK
        // ==========================================
        public int AddTask(
            int userID,
            int sessionID,
            string description)
        {
            if (string.IsNullOrWhiteSpace(description) ||
                description.Trim().Length > 200)
            {
                return -1;
            }

            using (StillroomDataContext db = GetDatabase())
            {
                FOCUS_SESSION session =
                    db.FOCUS_SESSIONs.SingleOrDefault(
                        s => s.SessionID == sessionID &&
                             s.UserID == userID &&
                             s.CompletedAt == null
                    );

                if (session == null)
                {
                    return -1;
                }

                int lastPosition = db.SESSION_TASKs
                    .Where(t => t.SessionID == sessionID)
                    .Select(t => (int?)t.TaskPosition)
                    .Max() ?? 0;

                SESSION_TASK task = new SESSION_TASK();

                task.SessionID = sessionID;
                task.TaskDescription = description.Trim();
                task.IsComplete = false;
                task.TaskPosition = lastPosition + 1;

                db.SESSION_TASKs.InsertOnSubmit(task);
                db.SubmitChanges();

                return task.TaskID;
            }
        }

        // ==========================================
        // 8. GET TASKS FOR A SESSION
        // ==========================================
        public List<StudyTask> GetSessionTasks(
            int userID,
            int sessionID)
        {
            using (StillroomDataContext db = GetDatabase())
            {
                bool ownsSession = db.FOCUS_SESSIONs.Any(
                    s => s.SessionID == sessionID &&
                         s.UserID == userID
                );

                if (!ownsSession)
                {
                    return new List<StudyTask>();
                }

                return db.SESSION_TASKs
                    .Where(t => t.SessionID == sessionID)
                    .OrderBy(t => t.TaskPosition)
                    .Select(t => new StudyTask
                    {
                        TaskID = t.TaskID,
                        SessionID = t.SessionID,
                        TaskDescription = t.TaskDescription,
                        IsComplete = t.IsComplete,
                        TaskPosition = t.TaskPosition
                    })
                    .ToList();
            }
        }

        // ==========================================
        // 9. COMPLETE A TASK
        // ==========================================
        public bool CompleteTask(int userID, int taskID)
        {
            using (StillroomDataContext db = GetDatabase())
            {
                SESSION_TASK task = db.SESSION_TASKs
                    .SingleOrDefault(
                        t => t.TaskID == taskID &&
                             t.FOCUS_SESSION.UserID == userID &&
                             t.FOCUS_SESSION.CompletedAt == null
                    );

                if (task == null)
                {
                    return false;
                }

                task.IsComplete = true;

                db.SubmitChanges();

                return true;
            }
        }

        // ==========================================
        // 10. DELETE A TASK
        // ==========================================
        public bool DeleteTask(int userID, int taskID)
        {
            using (StillroomDataContext db = GetDatabase())
            {
                SESSION_TASK task = db.SESSION_TASKs
                    .SingleOrDefault(
                        t => t.TaskID == taskID &&
                             t.FOCUS_SESSION.UserID == userID
                    );

                if (task == null)
                {
                    return false;
                }

                db.SESSION_TASKs.DeleteOnSubmit(task);
                db.SubmitChanges();

                return true;
            }
        }

        // ==========================================
        // 11. GET USER SETTINGS
        // ==========================================
        public AppSettings GetSettings(int userID)
        {
            using (StillroomDataContext db = GetDatabase())
            {
                APP_SETTING settings = db.APP_SETTINGs
                    .SingleOrDefault(s => s.UserID == userID);

                if (settings == null)
                {
                    return null;
                }

                return new AppSettings
                {
                    TimerMinutes = settings.TimerMinutes,
                    AmbientSound = settings.AmbientSound,
                    Volume = settings.Volume
                };
            }
        }

        // ==========================================
        // 12. UPDATE USER SETTINGS
        // ==========================================
        public bool UpdateSettings(
            int userID,
            int timerMinutes,
            string ambientSound,
            int volume)
        {
            if (timerMinutes != 25 &&
                timerMinutes != 45 &&
                timerMinutes != 60)
            {
                return false;
            }

            if (ambientSound != "rain" &&
                ambientSound != "cafe" &&
                ambientSound != "forest" &&
                ambientSound != "off")
            {
                return false;
            }

            if (volume < 0 || volume > 100)
            {
                return false;
            }

            using (StillroomDataContext db = GetDatabase())
            {
                APP_SETTING settings = db.APP_SETTINGs
                    .SingleOrDefault(s => s.UserID == userID);

                if (settings == null)
                {
                    return false;
                }

                settings.TimerMinutes = timerMinutes;
                settings.AmbientSound = ambientSound;
                settings.Volume = volume;

                db.SubmitChanges();

                return true;
            }
        }

        // ==========================================
        // 13. SENDING A MESSAGE
        // ==========================================
        public bool SendContactMessage(
    string fullName,
    string email,
    string subject,
    string message)
        {
            if (string.IsNullOrWhiteSpace(fullName) ||
                string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(subject) ||
                string.IsNullOrWhiteSpace(message))
            {
                return false;
            }

            if (fullName.Length > 100 ||
                email.Length > 254 ||
                subject.Length > 150 ||
                message.Length > 2000)
            {
                return false;
            }

            string connectionString =
                System.Configuration.ConfigurationManager
                .ConnectionStrings["StillroomConnection"]
                .ConnectionString;

            using (SqlConnection connection =
                new SqlConnection(connectionString))
            {
                string query = @"
            INSERT INTO ContactMessage
                (FullName, Email, Subject, MessageText)
            VALUES
                (@FullName, @Email, @Subject, @MessageText)";

                using (SqlCommand command =
                    new SqlCommand(query, connection))
                {
                    command.Parameters.Add(
                        "@FullName", SqlDbType.NVarChar, 100).Value = fullName;

                    command.Parameters.Add(
                        "@Email", SqlDbType.NVarChar, 254).Value = email;

                    command.Parameters.Add(
                        "@Subject", SqlDbType.NVarChar, 150).Value = subject;

                    command.Parameters.Add(
                        "@MessageText", SqlDbType.NVarChar, 2000).Value = message;

                    try
                    {
                        connection.Open();
                        return command.ExecuteNonQuery() == 1;
                    }
                    catch (SqlException)
                    {
                        return false;
                    }
                }
            }
        }
    }
}