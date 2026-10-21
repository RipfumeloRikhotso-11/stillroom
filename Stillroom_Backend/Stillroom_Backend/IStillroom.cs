using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace Stillroom_Backend
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IStillroom
    {

        // ACCOUNT
        [OperationContract]
        string Register(string fullName, string email, string password);

        [OperationContract]
        LoginResult Login(string email, string password);

        // FOCUS SESSIONS
        [OperationContract]
        int StartSession(int userID, string goal, int durationMinutes);

        [OperationContract]
        bool CompleteSession(int userID, int sessionID);

        [OperationContract]
        List<FocusSession> GetSessionHistory(int userID);

        [OperationContract]
        int GetTotalStudyMinutes(int userID);

        // TASKS
        [OperationContract]
        int AddTask(int userID, int sessionID, string description);

        [OperationContract]
        List<StudyTask> GetSessionTasks(int userID, int sessionID);

        [OperationContract]
        bool CompleteTask(int userID, int taskID);

        [OperationContract]
        bool DeleteTask(int userID, int taskID);

        // SETTINGS
        [OperationContract]
        AppSettings GetSettings(int userID);

        [OperationContract]
        bool UpdateSettings(
            int userID,
            int timerMinutes,
            string ambientSound,
            int volume);

        [OperationContract]
        bool SendContactMessage(
    string fullName,
    string email,
    string subject,
    string message);
    }

    [DataContract]
    public class LoginResult
    {
        [DataMember]
        public bool Success { get; set; }

        [DataMember]
        public int UserID { get; set; }

        [DataMember]
        public string FullName { get; set; }

        [DataMember]
        public string Message { get; set; }
    }

    [DataContract]
    public class FocusSession
    {
        [DataMember]
        public int SessionID { get; set; }

        [DataMember]
        public string SessionGoal { get; set; }

        [DataMember]
        public int DurationMinutes { get; set; }

        [DataMember]
        public DateTime StartedAt { get; set; }

        [DataMember]
        public DateTime? CompletedAt { get; set; }
    }

    [DataContract]
    public class StudyTask
    {
        [DataMember]
        public int TaskID { get; set; }

        [DataMember]
        public int SessionID { get; set; }

        [DataMember]
        public string TaskDescription { get; set; }

        [DataMember]
        public bool IsComplete { get; set; }

        [DataMember]
        public int TaskPosition { get; set; }
    }

    [DataContract]
    public class AppSettings
    {
        [DataMember]
        public int TimerMinutes { get; set; }

        [DataMember]
        public string AmbientSound { get; set; }

        [DataMember]
        public int Volume { get; set; }
    }
}