# Production Hosting Architecture Guide - PetConnect AI Ecosystem

Official hosting guide detailing production domain configuration, SSL certificates, managed database connectivity, and cloud storage settings.

---

## ☁️ Production Hosting Topology

| Component | Target Cloud Provider | Public Endpoint URL | SSL / TLS Status |
| :--- | :--- | :--- | :---: |
| **REST APIs (WSGI)** | Render Web Service | `https://api.petconnect.ai/api/v1/` | 🟢 TLS 1.3 Active |
| **WebSockets (ASGI)** | Render Daphne Service | `wss://ws.petconnect.ai/ws/` | 🟢 TLS 1.3 Active |
| **Flutter Web Client** | Vercel Hosting | `https://app.petconnect.ai` | 🟢 TLS 1.3 Active |
| **Primary Database** | Managed PostgreSQL 16 | Internal VPC Connection | 🔒 SSL Encrypted |
| **Cache & Task Broker** | Managed Redis 7.2 | Internal VPC Connection | 🔒 SSL Encrypted |
| **Media & EHR Storage** | AWS S3 / Cloudflare R2 | `https://s3.amazonaws.com/petconnect-prod` | 🟢 HTTPS Signed |
