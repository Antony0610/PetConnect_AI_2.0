# Android Production APK & App Bundle Build Guide (v2.3.0)

Official guide for compiling, signing, and packaging the production **Android APK** and **Android App Bundle (AAB)**.

---

## 🛠️ Step-by-Step Release Compilation

1. Clean previous build cache:
   ```bash
   flutter clean
   flutter pub get
   ```
2. Build Production Release APK:
   ```bash
   flutter build apk --release
   ```
   Artifact output: `build/app/outputs/flutter-apk/app-release.apk`

3. Build Production Android App Bundle (AAB):
   ```bash
   flutter build appbundle --release
   ```
   Artifact output: `build/app/outputs/bundle/release/app-release.aab`
