# Cloud Deployment Guide (v2.0.0) - PetConnect AI Ecosystem

Step-by-step production cloud deployment guide for deploying **PetConnect AI Ecosystem v2.0.0** on **Render**, **Vercel**, Managed PostgreSQL, and Managed Redis.

---

## 🏗️ 1. Backend Deployment on Render

1. Log into your [Render Dashboard](https://dashboard.render.com).
2. Click **New +** and select **Blueprint**.
3. Connect your GitHub repository `Antony0610/PetConnect_AI_2.0`.
4. Render will automatically detect `backend/render.yaml` and provision:
   - `petconnect-backend-web`: Django Gunicorn REST Web Service.
   - `petconnect-backend-daphne`: Daphne ASGI WebSocket Service.
   - `petconnect-celery-worker`: Celery Task Worker.
   - `petconnect-postgres`: Managed PostgreSQL 16 DB.
   - `petconnect-redis`: Managed Redis Key-Value Cache & Broker.
5. Add Environment Variables in Render Dashboard (`GEMINI_API_KEY`, `OPENAI_API_KEY`, `FCM_CREDENTIALS_PATH`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).

---

## 🌐 2. Frontend Hosting on Vercel (Flutter Web)

1. Build Flutter Web locally:
   ```bash
   flutter build web --release
   ```
2. Log into your [Vercel Dashboard](https://vercel.com).
3. Import `Antony0610/PetConnect_AI_2.0`.
4. Vercel automatically detects `vercel.json` and publishes `build/web` to production URL (e.g., `https://petconnect-ai.vercel.app`).
