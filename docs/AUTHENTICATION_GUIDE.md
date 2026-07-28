# Authentication Architecture & Security Guide (v2.2.0) - PetConnect AI Ecosystem

Comprehensive guide covering **JWT Token Authentication**, **Role-Based Access Control (RBAC)**, **Secure Token Storage**, and **API Endpoints**.

---

## 🔐 1. Authentication Architecture

The **PetConnect AI Ecosystem** utilizes Stateless JSON Web Tokens (JWT) powered by `djangorestframework-simplejwt`.

```mermaid
sequenceDiagram
    participant Client as Flutter Client App
    participant Storage as SecureTokenStorage
    participant DRF as Django REST API
    participant DB as PostgreSQL Database

    Client->>DRF: POST /api/v1/auth/login/ {email, password}
    DRF->>DB: Validate User Credentials & PBKDF2 Password Hashing
    DB-->>DRF: User Authenticated (Role: pet_owner/vet/volunteer/admin)
    DRF-->>Client: HTTP 200 OK {access_token, refresh_token, role}
    Client->>Storage: Store access_token & refresh_token securely
    Client->>Client: Redirect to Role-Specific Dashboard (RBAC)
```

---

## 🔑 2. JWT API Endpoints

| Endpoint URL | HTTP Method | Request Body | Description |
| :--- | :---: | :--- | :--- |
| `/api/v1/auth/login/` | `POST` | `{email, password}` | Authenticates user & returns JWT tokens + user role |
| `/api/v1/auth/register/` | `POST` | `{full_name, email, phone, password, role}` | Registers new account & sends verification OTP |
| `/api/v1/auth/token/refresh/` | `POST` | `{refresh}` | Issues new short-lived access token |
| `/api/v1/auth/verify-otp/` | `POST` | `{email, otp}` | Activates unverified accounts |
| `/api/v1/auth/forgot-password/` | `POST` | `{email}` | Sends password reset OTP to email |
