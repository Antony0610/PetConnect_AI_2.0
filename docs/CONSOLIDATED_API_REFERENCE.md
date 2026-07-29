# Consolidated API Reference - PetConnect AI Ecosystem v2.7.0

Production REST API reference documentation covering authentication, pet health records, Smart Collar telemetry, AI vision triage, emergency rescue, and admin endpoints.

---

## 📡 Live Base Endpoint
`https://antony06.pythonanywhere.com/api/v1/`

---

## 🔑 Authentication Endpoints

### 1. User Login
- **Endpoint**: `POST /auth/login/`
- **Request Body**:
  ```json
  {
    "email": "owner@petconnect.ai",
    "password": "SecurePassword123!"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "role": "pet_owner",
    "user_id": "usr_99812"
  }
  ```

---

## 🐶 Pet Management Endpoints

### 2. Fetch My Pets
- **Endpoint**: `GET /pets/`
- **Headers**: `Authorization: Bearer <access_token>`
- **Response (200 OK)**:
  ```json
  [
    {
      "id": "pet_001",
      "name": "Buddy",
      "species": "Canine",
      "breed": "Golden Retriever",
      "age": 3
    }
  ]
  ```
