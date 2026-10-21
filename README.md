# Stillroom

Stillroom is a calm, distraction-free study space. Users create an account, set a goal for a focus session, pick a timer length, and work through a task list, while the app keeps track of how much time they have spent studying.

**Author:** RC Rikhotso

## Features

- **Accounts:** register and log in. Passwords are hashed with PBKDF2 (210,000 iterations and a random salt per user) and are never stored in plain text.
- **Focus Room:** start a focus session with a goal and a duration, then mark it finished when you are done.
- **Study tasks:** add, complete and delete tasks for each session.
- **Dashboard:** a personal greeting and your total study time.
- **Settings:** per-user timer length (25, 45 or 60 minutes), ambient sound (rain, cafe, forest or off) and volume.
- **Contact page:** messages are saved to the database.

## Tech stack

| Layer | Technology |
| --- | --- |
| Frontend | ASP.NET Web Forms (.NET Framework 4.7.2), Bootstrap 5, jQuery |
| Backend | WCF service (`Stillroom.svc`) with LINQ to SQL |
| Database | SQL Server (LocalDB) |

## Project structure

```
├── SQLQuery1.sql            Database creation script
├── Stillroom_Backend/       WCF service: business logic and data access
│   └── Stillroom_Backend/
│       ├── IStillroom.cs        Service contract
│       ├── Stillroom.svc.cs     Service implementation
│       ├── SecrecyHash.cs       Password hashing and verification
│       └── Stillroom.dbml       LINQ to SQL data model
└── Stillroom_Frontend/      ASP.NET Web Forms website
    └── Stillroom_Frontend/
        ├── Default.aspx, About.aspx, Contact.aspx
        ├── Register.aspx, Login.aspx
        ├── Dashboard.aspx
        └── FocusRoom.aspx
```

## Database

The script `SQLQuery1.sql` creates a database called `StillroomDB` with these tables:

- `USERS`: accounts and password hashes
- `FOCUS_SESSION`: a user's focus sessions (goal, duration, start and completion times)
- `SESSION_TASK`: tasks that belong to a session
- `APP_SETTINGS`: one row of settings per user
- `ContactMessage`: messages sent from the contact page

> **Warning:** the script begins by dropping the existing tables. Only run it on a database where you are happy to start fresh.

## Getting started

### Requirements

- Windows with **Visual Studio 2022 or later** and the **ASP.NET and web development** workload
- **.NET Framework 4.7.2** developer pack
- **SQL Server LocalDB**, which is included with Visual Studio

### Setup

1. Clone the repository:
   ```
   git clone https://github.com/RipfumeloRikhotso-11/stillroom.git
   ```
2. Open `SQLQuery1.sql` in Visual Studio or SQL Server Management Studio, connect to `(localdb)\MSSQLLocalDB`, and run it to create `StillroomDB`.
3. Open `Stillroom_Backend/Stillroom_Backend.slnx` and run the project to start the WCF service. Visual Studio restores the NuGet packages automatically.
4. Open `Stillroom_Frontend/Stillroom_Frontend.slnx`. If the service address differs from the one the project was built with, update the service reference under **Connected Services** (right-click, then **Update Service Reference**).
5. Run the frontend project and register a new account to get started.

The backend connects to `(localdb)\MSSQLLocalDB` using Windows Integrated Security. The connection string is in `Stillroom_Backend/Stillroom_Backend/Web.config` if you need to point it at a different server.

## Service operations

The WCF service exposes these operations:

| Area | Operations |
| --- | --- |
| Account | `Register`, `Login` |
| Focus sessions | `StartSession`, `CompleteSession`, `GetSessionHistory`, `GetTotalStudyMinutes` |
| Tasks | `AddTask`, `GetSessionTasks`, `CompleteTask`, `DeleteTask` |
| Settings | `GetSettings`, `UpdateSettings` |
| Contact | `SendContactMessage` |

## Author

Created by **RC Rikhotso**.
