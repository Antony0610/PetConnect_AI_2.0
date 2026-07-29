# User Journey & Interactive Flow Specification - PetConnect AI Ecosystem v2.3.0

Complete documentation of user journeys across all 4 system portals.

---

## 🔄 Core User Flow Sequence

1. **Onboarding & Role Selection**:
   User opens app $\rightarrow$ Splash $\rightarrow$ Onboarding $\rightarrow$ Chooses Role (`pet_owner`, `vet`, `volunteer`, `admin`).
2. **JWT Authentication & RBAC Routing**:
   User enters credentials $\rightarrow$ `AuthRepository.login()` $\rightarrow$ Token stored securely $\rightarrow$ Redirected to assigned portal dashboard.
3. **Pet Healthcare & Smart Telemetry**:
   Pet Owner manages pets $\rightarrow$ Views Health Passport EHR $\rightarrow$ Monitors live Smart Collar GPS & vitals $\rightarrow$ Scans symptoms using AI Vision Triage.
4. **Emergency SOS & Volunteer Rescue**:
   Emergency lost pet report triggered $\rightarrow$ Geofence breach broadcasted $\rightarrow$ Nearby Volunteers dispatched via live GPS map.
