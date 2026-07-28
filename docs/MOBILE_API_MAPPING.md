# Mobile UI to Backend API Mapping Matrix (v2.3.0)

Complete mapping connecting Flutter UI screens directly to live Django REST Framework endpoints.

---

## 🗺️ Screen to API Mapping Table

| Flutter Screen | Target DRF API Endpoint | Repository Method |
| :--- | :--- | :--- |
| `LoginScreen` | `POST /api/v1/auth/login/` | `AuthRepository.login()` |
| `RoleSelectionScreen` | `POST /api/v1/auth/register/` | `AuthRepository.register()` |
| `PetOwnerDashboardScreen` | `GET /api/v1/pets/` | `PetsRepository.getMyPets()` |
| `HealthPassportScreen` | `GET /api/v1/pets/:id/health-passport/` | `PetsRepository.getHealthPassport()` |
| `AIScanScreen` | `POST /api/v1/ai-scan/analyze/` | `AIRepository.analyzeImage()` |
| `InteractiveAIChatScreen` | `POST /api/v1/ai-scan/chat/` | `AIRepository.queryMedicalAssistant()` |
| `SmartCollarSetupScreen` | `POST /api/v1/smart-collar/pair/` | `CollarRepository.pairDevice()` |
| `LiveTrackingScreen` | `GET /api/v1/smart-collar/devices/:id/telemetry/` | `CollarRepository.getCollarTelemetry()` |
| `RescueMissionsHubScreen` | `GET /api/v1/rescue/missions/` | `RescueRepository.getActiveMissions()` |
| `AdminCommandCenterScreen` | `GET /api/v1/admin/telemetry/` | `ApiService.get('/admin/telemetry/')` |
