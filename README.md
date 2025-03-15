 Task Management App

 Overview
Task Management is a Flutter-based mobile application designed to help users organize their tasks efficiently. It features an offline-first design, leveraging ObjectBox for local data storage while also supporting data export and import via SQLite. The app also includes Firebase synchronization for fetching and adding tasks across multiple devices.

 Features
- Add, edit, delete, and manage tasks.
- Offline-first architecture using ObjectBox.
- Firebase sync for fetching and adding tasks.
- Export and import tasks via an SQLite database file.
- Task categorization and filtering.
- User-friendly UI with dark and light themes.
- Overdue tasks are highlighted with a red border and a "Due" symbol.
- Online/offline status indicator:
    - Green switch (On): Online mode.
    - Red switch (Off): Offline mode.
- Priority-based task indicators using a wave animation:
    - Red wave: High-priority tasks.
    - Blue wave: Medium-priority tasks.
    - Green wave: Low-priority tasks.



 Steps to Run the App Locally

 Prerequisites
- Flutter installed ([Flutter installation guide](https://flutter.dev/docs/get-started/install)).
- Android Studio or VS Code with Flutter and Dart plugins.
- A physical or virtual (emulator/simulator) device.

 Installation Steps
1. Clone the repository:
2. git clone https://github.com/your-repository/task-management-app.git
   cd task-management-app
   
3. Install dependencies:
   
   flutter pub get
   
4. Run the app on an emulator or connected device:
   
   flutter run
   



 Architecture
The app follows an MVVM (Model-View-ViewModel) architecture for better separation of concerns and maintainability.

- Model: Represents the task data and business logic.
- View: UI components built using Flutter widgets.
- ViewModel: Manages state and business logic using GetX for reactivity.



 Libraries Used
- State Management: Provider
- Local Database: ObjectBox (for fast, efficient local storage)
- Cloud Sync: Firebase Firestore for syncing tasks
- Data Export/Import: SQLite integration for interoperability
- UI: Material Design with custom themes
- Animations: Flutter animation framework for wave effects



 Offline-First Design
- The app operates fully offline using ObjectBox as the primary local database.
- Users can export task data to an SQLite database file for backup or sharing.
- Import functionality allows restoring tasks from an SQLite file.
- Firebase synchronization ensures that tasks can be accessed and updated across multiple devices.



 Future Enhancements
- Cloud sync for task backup and multi-device access.
- Task reminders and notifications.
- Improved task sharing features.

For any issues or contributions, feel free to open a pull request or create an issue in the repository.


