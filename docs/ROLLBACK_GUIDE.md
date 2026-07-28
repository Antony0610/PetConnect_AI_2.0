# Production Rollback Guide - PetConnect AI Ecosystem v2.0.0

Emergency rollback procedures for Render backend deployments and Vercel frontend deployments.

---

## ⏪ 1. Render Backend Rollback

1. Go to [Render Dashboard](https://dashboard.render.com).
2. Select `petconnect-backend-web` service.
3. Click on the **Deploys** tab.
4. Locate the last known healthy deployment commit.
5. Click **Rollback to this deploy**.

---

## ⏪ 2. Vercel Frontend Rollback

1. Go to [Vercel Dashboard](https://vercel.com).
2. Select `petconnect-ai` project.
3. Click on **Deployments**.
4. Find the previous stable production release.
5. Click the `...` menu and select **Instant Rollback**.
