# Email & OTP Verification Guide (v2.2.0) - PetConnect AI Ecosystem

Official guide detailing account activation policies, verification email payloads, and OTP resend logic.

---

## ✉️ Verification Lifecycle

1. **User Registration**: New account created with `is_verified = False`.
2. **Email Dispatch**: SendGrid / AWS SES sends 6-digit OTP code to registered email.
3. **Account Activation**: User enters OTP in app $\rightarrow$ `POST /api/v1/auth/verify-otp/` $\rightarrow$ `is_verified = True`.
