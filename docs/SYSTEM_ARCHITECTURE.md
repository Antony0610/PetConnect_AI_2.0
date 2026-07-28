# System Architecture Guide - PetConnect AI Ecosystem

Comprehensive system architecture design for the **PetConnect AI Ecosystem**, detailing client presentation, backend microservices, data persistence, IoT streaming, and AI inference engines.

---

## 1. High-Level System Architecture

```mermaid
graph TD
    Client[Flutter Mobile Application] -->|HTTPS REST / WSS| Nginx[NGINX Reverse Proxy]
    
    subgraph "Application Compute Layer"
        Nginx --> Gunicorn[Gunicorn WSGI Application Server]
        Nginx --> Daphne[Daphne ASGI WebSocket Server]
        Gunicorn --> Django[Django 5.0 Core Engine]
        Daphne --> Django
    end

    subgraph "Asynchronous Worker Queue"
        Django --> Redis[(Redis 7.2 Cache & Broker)]
        CeleryWorker[Celery Background Workers] --> Redis
    end

    subgraph "Data Persistence & Storage"
        Django --> Postgres[(PostgreSQL 16 Primary Database)]
        CeleryWorker --> S3[(AWS S3 / Cloudflare R2 Media Bucket)]
    end

    subgraph "AI & Machine Learning Engine"
        CeleryWorker --> Gemini[Google Gemini 1.5 Pro API]
        CeleryWorker --> ONNX[Local ONNX Runtime / YOLOv8]
    end
```

---

## 2. Core Architectural Layers

1. **Flutter Mobile Application (`lib/src/`)**:
   - Built on Flutter 3.22.0 adhering to Clean Architecture (`presentation/`, `domain/`, `data/`).
   - Managed by Riverpod 2.x, GoRouter 14.x navigation, and Material 3 design systems.
2. **Django Backend Application (`backend/`)**:
   - Built on Django 5.0 & DRF 3.15, separated into 13 domain apps (`accounts`, `pets`, `health_passport`, `smart_collar`, `ai_scan`, `rescue`, `admin_dashboard`).
   - Implements strict Service-Repository-Selector patterns.
3. **Smart Collar IoT Subsystem**:
   - Dual-model architecture: `SmartCollarDeviceStatus` (live telemetry cache) and `SmartCollarTelemetryHistory` (immutable time-series history log).
   - Real-time Haversine distance geofence breach detection.
