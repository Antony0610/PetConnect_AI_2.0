# PetConnect AI Ecosystem 🐾🤖 (v3.0.0 Official Release Edition)

[![License: MIT](https://img.shields.io/badge/License-MIT-teal.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.22.0-02569B?logo=flutter)](https://flutter.dev)
[![Django](https://img.shields.io/badge/Django-5.0.0-092E20?logo=django)](https://djangoproject.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16.0-4169E1?logo=postgresql)](https://postgresql.org)
[![Redis](https://img.shields.io/badge/Redis-7.2-DC382D?logo=redis)](https://redis.io)
[![Status](https://img.shields.io/badge/Status-Production%20Release-success.svg)](#)

> **Enterprise-Grade, Cloud-Native, Medical PetCare Ecosystem & Smart IoT Telemetry Platform**

**PetConnect AI** is a state-of-the-art, full-stack pet healthcare, AI diagnostic vision scanner, smart IoT collar telemetry tracker, emergency stray rescue dispatch network, and clinical veterinary ecosystem. Built using an offline-first **Flutter 3.22 Mobile Application** paired with a high-concurrency **Django 5 / Celery / Channels Backend**.

---

## 📚 Essential Documentation

- 📄 [User Operating Manual](docs/USER_MANUAL.md)
- 🔌 [REST API Reference](docs/API_REFERENCE.md)
- 🏛️ [System Architecture & Diagrams](docs/ARCHITECTURE.md)
- 🛠️ [Installation Guide](docs/INSTALLATION.md)
- 🚀 [Deployment Guide](docs/DEPLOYMENT.md)
- 🎓 [B.Tech Thesis Paper](docs/THESIS_SUPPORT_DOCUMENT.md)
- 📋 [Viva Preparation Q&A](docs/PRESENTATION_VIVA_PREPARATION.md)
- 🎬 [Live Demonstration Script](docs/DEMONSTRATION_SCRIPT.md)

---

## 📸 Application Portals & Screenshots

| Pet Owner Portal | Veterinarian Clinical Portal | Volunteer Stray Rescue | Admin Command Center |
| :---: | :---: | :---: | :---: |
| *Pet Health Passport & Smart Collar* | *Electronic Health Records (EHR)* | *Spatial Volunteer Auto-Dispatch* | *Live System Telemetry* |

---

## 🌟 Key Features

* **Multi-Portal Architecture**: Dedicated portals for Pet Owners, Veterinarians, Rescuers/Volunteers, and System Administrators.
* **AI Vision Disease Triage**: 7 scan modes (`skin_disease`, `eye_disease`, `ear_infection`, `dental_disease`, `tick_detection`, `wound_detection`, `body_condition`) powered by **Google Gemini 1.5 Pro**, **OpenAI GPT-4o**, and **Local ONNX Runtime (YOLOv8)**.
* **Smart Collar IoT Telemetry Subsystem**: Hardware registration, 1-to-1 pairing locks, PBKDF2 device secret hashing, Haversine distance geofence breach detection, and time-series vitals tracking.
* **Emergency Rescue Dispatch**: Lost/found reporting, emergency SOS, and spatial volunteer squad auto-dispatch queue.
* **Enterprise Security & Observability**: SimpleJWT rotation, RBAC guards, OpenTelemetry distributed tracing, Prometheus metrics, and live health probes (`/liveness/`, `/readiness/`, `/startup/`).

---

## 🛠️ Technology Stack

* **Client**: Flutter 3.22.0, Riverpod 2.x, GoRouter 14.x, Responsive Framework, Material 3.
* **Backend**: Python 3.12, Django 5.0, Django REST Framework 3.15, Gunicorn, Daphne.
* **Database & Cache**: PostgreSQL 16, Redis 7.2.
* **Async Workers & Real-Time**: Celery 5.3, Django Channels 4.0 (WebSockets).
* **Cloud & DevOps**: Docker, Docker Compose, Kubernetes (`k8s/`), NGINX, GitHub Actions CI/CD.

---

## 🚀 Quick Start Guide

### Running Backend with Docker Compose

```bash
git clone https://github.com/Antony0610/PetConnect_AI_2.0.git
cd PetConnect_AI_2.0/backend
cp .env.example .env
docker-compose up -d --build
```

Access OpenAPI 3.0 Swagger UI: `http://localhost:8000/api/v1/docs/`

---

## 📜 Repository Structure

```
PetConnect_AI_2.0/
├── backend/                   # Django 5 REST Backend
│   ├── apps/                  # Modular Domain Apps
│   ├── config/                # Settings, ASGI, WSGI, Tracing
│   └── tests/                 # Complete Test Suite
├── lib/                       # Flutter 3.22 App Source
├── docs/                      # Essential Technical Documentation
├── README.md                  # Master README
├── LICENSE                    # MIT License
└── CHANGELOG.md               # Version History
```

---

## 📄 License & Community

Distributed under the **MIT License**. See `LICENSE` for more information.
