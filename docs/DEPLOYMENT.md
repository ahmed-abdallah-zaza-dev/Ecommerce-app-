# Deployment Guide 📦

This guide covers building the production bundles, configuring app credentials, setting up CI/CD pipelines, and enabling telemetry checks.

---

## 🏷️ Versioning Configuration

The app version is configured inside [pubspec.yaml](file:///c:/Users/DELL/Desktop/desktop/Flutter/Ecommerce%20App/pubspec.yaml) using the `version` key:
```yaml
version: 1.0.0+1
```
*   `1.0.0`: The semantic version representation (`versionName` on Android, `CFBundleShortVersionString` on iOS).
*   `1`: The build number configuration (`versionCode` on Android, `CFBundleVersion` on iOS). Increment this number with every production release.

---

## 🤖 Android Production Build

To deploy to Google Play Store, you must generate a signed Android App Bundle (AAB).

### Step 1: Create a keystore file
Run the following tool command to generate a keystore file:
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### Step 2: Configure signing properties
Create a private properties file named `key.properties` inside the `android/` directory (ensure this file is ignored in git):
```properties
storePassword=<keystore_password>
keyPassword=<alias_password>
keyAlias=upload
storeFile=../upload-keystore.jks
```

### Step 3: Configure build.gradle
Ensure `android/app/build.gradle` loads `key.properties` and hooks up the credentials within release configurations:
```gradle
def signingPropertiesFile = rootProject.file('key.properties')
def signingProperties = new Properties()
if (signingPropertiesFile.exists()) {
    signingProperties.load(new FileInputStream(signingPropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            if (signingPropertiesFile.exists()) {
                storeFile file(signingProperties['storeFile'])
                storePassword signingProperties['storePassword']
                keyAlias signingProperties['keyAlias']
                keyPassword signingProperties['keyPassword']
            }
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Step 4: Build Bundle
Run the Flutter compiler:
```bash
flutter build appbundle --release
```
The output bundle will be located at:
`build/app/outputs/bundle/release/app-release.aab`

---

## 🍏 iOS Production Build

### Step 1: Xcode Signing Configurations
1. Open the `/ios` project directory in Xcode.
2. Select the `Runner` target, navigate to **Signing & Capabilities**.
3. Choose your registered Developer Team account and check **Automatically manage signing**.
4. Set the Bundle Identifier to match your App Store Connect app entry.

### Step 2: Build IPA
Run the build tool command:
```bash
flutter build ipa --release
```
This prepares the archive and outputs build targets under `build/ios/archive/` and creates a package folder at `build/ios/ipa/`.

### Step 3: Distribute to App Store Connect
Upload the generated bundle IPA directly to App Store Connect using Apple Transporter or Xcode Organizer to start TestFlight external reviews.

---

## ♾️ CI/CD Pipeline Automation (GitHub Actions)

Create a workflow file at `.github/workflows/ci_cd.yml` to automate testing and production building on every push to your main branches:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, release/* ]
  pull_request:
    branches: [ main ]

jobs:
  analyze_and_test:
    name: Code Analysis & Unit Testing
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Generate Localizations
        run: flutter gen-l10n

      - name: Analyze Code
        run: flutter analyze

      - name: Run Tests
        run: flutter test

  build_android:
    name: Build Android Production Bundle
    needs: analyze_and_test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
      - name: Decrypt Keystore and build
        run: |
          flutter pub get
          flutter gen-l10n
          flutter build appbundle --release
```

---

## 🚨 Sentry Telemetry Integration

The project has `sentry_flutter` installed. To capture exceptions in production:
1. Initialize Sentry inside `main.dart`:
```dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://<your_sentry_public_key>@sentry.io/<project_id>';
      options.tracesSampleRate = 1.0; // Sample rate for performance logging
    },
    appRunner: () => runApp(const AppInitWrapper()),
  );
}
```
2. Any unhandled UI or async exceptions will automatically be captured and pushed to your Sentry dashboard with full stack traces mapped via Android Proguard and iOS dSYM symbols.
