# Campus Clinic Visit Log

**Name:** Cortez

**Workstation Number:** L12X16W30

A focused Flutter demo for logging clinic visits and showing a simple waiting queue.

## Features

- **Create:** student enters a name, student ID, and symptom; visit time is recorded automatically (server timestamp).
- **Read:** nurse view shows a live, real-time queue (Firestore stream).
- **Update:** nurse can edit a visit's details or mark it as attended.
- **Delete:** nurse can delete a visit (with confirmation).
- Firebase Cloud Firestore support with an in-app demo-mode fallback (same CRUD API, in-memory).
- Errors from the backend are shown to the user instead of failing silently.

## Run

```bash
flutter pub get
flutter run
```

## Firebase setup

1. Create a Firebase project.
2. Run `flutterfire configure` and select this app.
3. Generate platform options with FlutterFire.
4. Add a Firestore database and use demo-friendly rules.
5. Re-run `flutter pub get` and `flutter run`.

Until configuration is added, the app clearly displays **Demo mode** and uses seeded in-memory visits.

## Demo flow

1. Enter a student name, student ID, and symptom.
2. Tap **Join clinic queue**.
3. Tap the hospital icon in the top-right to open the hidden nurse queue.
4. Tap **Attend** to mark a visit as attended, or the ⋮ menu to **Edit** or **Delete** it.

## Tests

```bash
flutter test
```

## Scope

This demo intentionally excludes login/authentication, medical records, medicine inventory, and data-entry administration.
