# Android Release Build & Play Store Deployment Guide (v2.2.0)

Step-by-step guide for generating signed **Release APK** and **Android App Bundle (AAB)**.

---

## 🛠️ 1. Build Signed APK

```bash
flutter build apk --release
```
Output artifact: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📦 2. Build Android App Bundle (AAB)

```bash
flutter build appbundle --release
```
Output artifact: `build/app/outputs/bundle/release/app-release.aab`
