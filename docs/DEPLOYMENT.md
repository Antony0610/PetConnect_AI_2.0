# Production Deployment & Kubernetes Guide - PetConnect AI

Enterprise cloud-native deployment guide for **PetConnect AI Ecosystem** using Docker Compose and Kubernetes (`k8s/`).

---

## 🐋 Production Deployment via Docker Compose

```bash
cd backend
docker-compose -f docker-compose.prod.yml up -d --build
```

---

## ☸️ Production Deployment via Kubernetes

```bash
cd backend/k8s

# 1. Apply Namespace & Secrets
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml

# 2. Deploy Services & Deployments
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# 3. Configure Ingress & Auto-scaling
kubectl apply -f ingress.yaml
kubectl apply -f hpa.yaml
```
