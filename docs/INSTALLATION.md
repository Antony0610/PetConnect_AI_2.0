# Local Installation & Setup Guide - PetConnect AI

Step-by-step developer setup guide for running the **PetConnect AI Ecosystem** locally on Linux, macOS, or Windows.

---

## 📋 Prerequisites

- **Python**: 3.12+
- **Flutter SDK**: 3.22.0+
- **Docker & Docker Compose**: 24.0+
- **PostgreSQL**: 16.0+ (Optional if using Docker)
- **Redis**: 7.2+ (Optional if using Docker)

---

## 🛠️ Step-by-Step Setup

### 1. Clone Repository

```bash
git clone https://github.com/Antony0610/PetConnect_AI_2.0.git
cd PetConnect_AI_2.0
```

### 2. Configure Environment Variables

```bash
cp .env.example backend/.env
```

Edit `backend/.env` to configure your database and API keys.

### 3. Run Backend via Docker Compose

```bash
cd backend
docker-compose up -d --build
```

Access Swagger Documentation: `http://localhost:8000/api/v1/docs/`

### 4. Run Flutter Mobile Client

```bash
cd ..
flutter pub get
flutter run
```
