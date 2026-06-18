# Installation Guide 🚀

Follow this comprehensive guide to set up the Flutter E-Commerce Application on your local development machine.

---

## 📋 Prerequisites

Before starting, ensure you have the following installed on your system:

| Tool | Version | Purpose |
| :--- | :--- | :--- |
| **Flutter SDK** | `^3.22.0` or higher | Core framework SDK |
| **Dart SDK** | `^3.4.0` or higher | Underlying programming language |
| **Android Studio** | Latest version | Android SDK, emulator, and build tools |
| **Xcode** | Latest version (macOS only) | iOS/macOS simulators and SDK |
| **CocoaPods** | `^1.12.0` or higher (macOS only) | iOS dependency manager |
| **Git** | Latest version | Source control management |

---

## ⚙️ Step-by-Step Setup

### Step 1: Clone the Repository
Clone the codebase to your local working workspace:
```bash
git clone <repository_url>
cd "Ecommerce App"
```

### Step 2: Fetch Dependencies
Resolve all package dependencies specified in the project:
```bash
flutter pub get
```

### Step 3: Configure Environment Variables
Create a `.env` file in the root directory of the project. A template `.env.example` should look like this:
```env
BASE_URL=https://dummyjson.com
PRODUCT_LOAD_LIMIT=20
APP_TITLE="Flutter E-Commerce Premium"
```

The app loads this `.env` file during startup:
*   `BASE_URL`: The core URL target for API requests.
*   `PRODUCT_LOAD_LIMIT`: Default limit for product pagination list checks.

---

## 🔥 Firebase Setup

The application uses Firebase for user authentication. To configure it for Android and iOS:

### For Android:
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new Firebase project and add an Android app.
3. Use the package name found in `android/app/build.gradle` (typically `com.example.flutter_application_1` or custom).
4. Download the `google-services.json` file.
5. Place the file inside the project directory at:
   `android/app/google-services.json`

### For iOS (on macOS):
1. Add an iOS app inside your Firebase project console.
2. Use the Bundle Identifier found in Xcode under target runner settings (or `ios/Runner.xcodeproj`).
3. Download the `GoogleService-Info.plist` file.
4. Open the `ios/` folder in Xcode, right-click the `Runner` folder, choose **Add Files to "Runner"**, and select `GoogleService-Info.plist`.
5. Ensure the file is placed at:
   `ios/Runner/GoogleService-Info.plist`

---

## 🌐 Localization Compilation

The project uses ARB (Application Resource Bundle) files for localizations (English and Arabic). You must run the code generation tool to compile the arb files into concrete Dart classes:

```bash
flutter gen-l10n
```
This reads configurations in [l10n.yaml](file:///c:/Users/DELL/Desktop/desktop/Flutter/Ecommerce%20App/l10n.yaml) and generates:
*   `AppLocalizations` delegates.
*   Translations mapping in `lib/l10n/app_localizations_en.dart` and `lib/l10n/app_localizations_ar.dart`.

---

## 🧪 Verification & Running

### Step 1: Code Verification
Ensure the codebase is free of syntax and formatting errors:
```bash
flutter analyze
```

### Step 2: Run Unit Tests
Verify all logic and widget test suites pass:
```bash
flutter test
```

### Step 3: Start the Emulator/Simulator
Ensure an active emulator is running, or list available devices:
```bash
flutter devices
```

### Step 4: Run the Application
Start the development server:
```bash
flutter run
```
To run in release mode for production performance checks:
```bash
flutter run --release
```
