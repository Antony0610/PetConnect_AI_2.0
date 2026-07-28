# JWT Token Refresh & Session Flow (v2.2.0) - PetConnect AI Ecosystem

Detailed technical breakdown of JWT Token Refresh logic, expiration handling, and auto-login session persistence.

---

## 🔄 Token Lifespan Specifications

- **Access Token Expiration**: 60 Minutes (Short-Lived for High Security).
- **Refresh Token Expiration**: 7 Days (Long-Lived for Auto-Login Convenience).
- **Token Rotation**: On each `/api/v1/auth/token/refresh/` call, a new refresh token is issued and the old token is blacklisted.

```json
{
  "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "u-9021",
    "email": "owner@petconnect.ai",
    "role": "pet_owner"
  }
}
```
