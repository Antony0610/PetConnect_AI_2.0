# User Management & RBAC Governance Guide (v2.2.0) - PetConnect AI Ecosystem

Official user management guide detailing role-based permissions, registration policies, duplicate detection, and profile management.

---

## 👥 1. Supported User Roles & Permissions Matrix

| Role | Target Dashboard | Permitted Actions | Restrictions |
| :--- | :--- | :--- | :--- |
| `pet_owner` | Pet Owner Dashboard | Pet CRUD, Health Passport view, Smart Collar tracking, AI Scanner | Restricted from clinical vet notes & admin tools |
| `vet` | Clinical Dashboard | Patient EHR records, Verified medical notes, Telehealth triage | Restricted from admin system settings |
| `volunteer` | Volunteer Dashboard | Rescue mission auto-dispatch, SOS alerts, Lost pet reporting | Restricted from clinical prescription edits |
| `admin` | Admin Command Center | System telemetry, User directory moderation, Collar OTA queue | Full platform access |

---

## 🛡️ 2. Duplicate Detection & Account Safety

1. **Email Uniqueness**: Case-insensitive unique index enforced on `User.email`.
2. **Phone Uniqueness**: E.164 format unique validation on `User.phone`.
3. **PBKDF2 Hashing**: Passwords stored using PBKDF2 with SHA-256 and salt.
