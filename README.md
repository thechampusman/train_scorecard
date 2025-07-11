# Train Coach Score Card App

A Flutter app for scoring and reviewing train coaches, supporting offline data entry, auto-save, and robust data restoration.

---

## 🚀 Project Setup

1. **Clone the repository**
   ```sh
   git clone <your-repo-url>
   cd <your-project-folder>
   ```

2. **Install dependencies**
   ```sh
   flutter pub get
   ```

3. **Required packages**
   - provider
   - shared_preferences
   - connectivity_plus
   - http
   - google_fonts

   These are already listed in `pubspec.yaml`.

4. **Run the app**
   ```sh
   flutter run
   ```

---

## ✨ Key Features

- **Auto-save & Restore:**  
  All form data (intro and coach forms) is auto-saved to device storage as you type or select. If the app is closed or killed, your progress is restored on next launch.

- **Offline Data Entry & Deferred Upload:**  
  You can fill and submit forms even when offline. If submission fails due to no internet, your data is saved locally and automatically uploaded when the device reconnects.

- **Coach Matrix & Remarks:**  
  Supports scoring for 13 coaches (C1–C13) and 8 areas per coach, with remarks. Preview page shows all data in a table and remarks section.

- **Dummy Data Button:**  
  For quick testing, a button fills all forms and coach data with sample values.

- **Modern UI:**  
  Uses glassmorphism, responsive layouts, and Google Fonts for a clean look.

---

## ⚠️ Assumptions & Known Limitations

- **Assumptions:**
  - The app is single-user and does not require authentication.
  - All coach and form data is stored locally using `shared_preferences`.
  - The webhook endpoint (e.g., [webhook.site](https://webhook.site)) is used for demo/mock submission.

- **Known Limitations:**
  - No backend or cloud sync; data is only stored locally and sent to a mock endpoint.
  - Only one pending submission is stored for offline upload (new offline submissions overwrite the previous one).
  - No validation for date/time formats beyond required fields.
  - The "Fill Dummy Data" button is for development/testing and should be removed or hidden in production.
  - No advanced error handling for corrupted local storage or partial data.

---

## 📝 How Offline & Restore Works

- **Auto-save:**  
  Every field change triggers a save to the provider and `shared_preferences`.

- **Restore:**  
  On app start, all saved data is loaded and controllers are populated.

- **Offline Submission:**  
  If submission fails (e.g., no internet), data is saved as a pending submission.  
  When connectivity is restored, the app automatically uploads the pending data.

---

## 📋 Testing

- Fill forms, close the app, and reopen to verify data restoration.
- Submit while offline to test deferred upload.
- Use the "Fill Dummy Data" button for fast testing.

---

## 📧 Contact

For issues or feature requests, please open an issue on
