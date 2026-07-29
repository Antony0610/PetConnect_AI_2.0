# Screen Hierarchy & Mapping Document - PetConnect AI Ecosystem v2.3.0

Complete screen hierarchy mapping every route from Entry point to Child Pages, Detail Pages, Edit Modals, and Return Navigation paths.

---

## 🌳 Application Screen Hierarchy

```mermaid
graph TD
    Splash[SplashScreen '/'] --> Onboarding[OnboardingScreen '/onboarding']
    Onboarding --> RoleSelect[RoleSelectionScreen '/role-selection']
    RoleSelect --> Login[LoginScreen '/login']
    RoleSelect --> ProfileSetup[ProfileSetupScreen '/profile-setup']
    
    Login --> PetOwner[PetOwnerDashboardScreen '/pet-owner']
    Login --> Vet[ClinicalDashboardScreen '/vet']
    Login --> Volunteer[VolunteerDashboardScreen '/volunteer']
    Login --> Admin[AdminCommandCenterScreen '/admin']

    PetOwner --> Passport[HealthPassportScreen '/pet-owner/health-passport']
    PetOwner --> CollarSetup[SmartCollarSetupScreen '/pet-owner/smart-collar']
    PetOwner --> Tracking[LiveTrackingScreen '/pet-owner/live-tracking']
    PetOwner --> AIScan[AIScanScreen '/pet-owner/ai-scan']
    PetOwner --> AIChat[InteractiveAIChatScreen '/pet-owner/ai-chat']

    Volunteer --> RescueHub[RescueMissionsHubScreen '/volunteer/rescue']
    Volunteer --> RescueMap[LiveRescueMapScreen '/volunteer/rescue-map']
```
