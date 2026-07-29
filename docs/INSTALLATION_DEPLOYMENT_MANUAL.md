# Installation & Deployment Operating Manual - PetConnect AI Ecosystem v2.7.0

Complete guide for local environment setup, Docker deployment, backend Django setup, and Flutter APK compilation.

---

## 🛠️ 1. Local Environment Requirements
- **Flutter SDK**: 3.22.x or higher
- **Dart SDK**: 3.4.x or higher
- **Python**: 3.12.x
- **PostgreSQL**: 16.x

---

## 🚀 2. Docker Quickstart
```bash
cd backend
docker-compose -f docker-compose.prod.yml up -d
```
Access Swagger API Docs at `http://localhost:8000/api/v1/docs/`.

---

## 📱 3. Flutter Android Build
```bash
flutter clean
flutter pub get
flutter build apk --release
```
Artifact generated at `build/app/outputs/flutter-apk/app-release.apk`.
