# Network Architecture & Interceptor Specification - PetConnect AI Ecosystem v2.4.0

Technical specification for centralized HTTP networking (`ApiService`), Dio/HTTP client interceptors, JWT header injection, and retry policies.

---

## 🌐 Network Interceptor Stack

```mermaid
sequenceDiagram
    participant Screen as Flutter UI Screen
    participant Client as ApiService Client
    participant Interceptor as JWT Bearer Interceptor
    participant LiveBackend as PythonAnywhere DRF API

    Screen->>Client: ApiService.get('/pets/')
    Client->>Interceptor: Read access_token from SecureTokenStorage
    Interceptor->>Client: Inject 'Authorization: Bearer <token>'
    Client->>LiveBackend: GET https://antony06.pythonanywhere.com/api/v1/pets/
    LiveBackend-->>Client: HTTP 200 OK [Pet Data JSON]
    Client-->>Screen: Return Parsed Models
```
