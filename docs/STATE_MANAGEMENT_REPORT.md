# State Management & Repository Architecture Report - PetConnect AI Ecosystem v2.4.0

Architecture report detailing state management, domain repositories, and clean architecture separation.

---

## 🏛️ Clean Architecture Layers

1. **Presentation Layer**: Material 3 screens & custom widgets (`lib/src/features/`, `lib/src/core/widgets/`).
2. **Domain & Repositories Layer**: Clean data contracts (`PetsRepository`, `AIRepository`, `CollarRepository`, `RescueRepository`).
3. **Data Layer**: Centralized network client (`ApiService`) & token storage (`SecureTokenStorage`).
