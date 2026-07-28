import uuid
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.conf import settings

class TenantTypeChoices(models.TextChoices):
    VET_HOSPITAL = 'VET_HOSPITAL', 'Veterinary Hospital Chain'
    SHELTER = 'SHELTER', 'Animal Shelter & Rescue NGO'
    GOVT_AGENCY = 'GOVT_AGENCY', 'Government Animal Control Agency'
    ENTERPRISE = 'ENTERPRISE', 'Enterprise PetCare Corporation'

class TenantOrganization(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=150, unique=True, db_index=True)
    tenant_type = models.CharField(max_length=30, choices=TenantTypeChoices.choices, default=TenantTypeChoices.VET_HOSPITAL)
    slug = models.SlugField(max_length=100, unique=True, db_index=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name} ({self.get_tenant_type_display()})"

class UserRole(models.TextChoices):
    PET_OWNER = 'pet_owner', 'Pet Owner'
    VETERINARIAN = 'vet', 'Veterinarian'
    VOLUNTEER = 'volunteer', 'Volunteer / Rescuer'
    ADMINISTRATOR = 'admin', 'Administrator'

class User(AbstractUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True, db_index=True)
    tenant = models.ForeignKey(TenantOrganization, on_delete=models.SET_NULL, null=True, blank=True, related_name='members')
    role = models.CharField(
        max_length=20,
        choices=UserRole.choices,
        default=UserRole.PET_OWNER,
        db_index=True
    )
    phone_number = models.CharField(max_length=30, blank=True, default='')
    profile_photo_url = models.URLField(max_length=500, blank=True, null=True)
    is_verified = models.BooleanField(default=False, db_index=True)

    created_at = models.DateTimeField(auto_now_add=True, db_index=True)
    updated_at = models.DateTimeField(auto_now=True)


    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.email} ({self.get_role_display()})"


class EmailVerificationToken(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='email_tokens')
    token = models.CharField(max_length=100, unique=True, db_index=True)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()
    is_used = models.BooleanField(default=False)


class PasswordResetToken(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='password_tokens')
    token = models.CharField(max_length=100, unique=True, db_index=True)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()
    is_used = models.BooleanField(default=False)


class AuthAuditLog(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    event_type = models.CharField(max_length=50, db_index=True) # e.g., 'REGISTER', 'LOGIN', 'LOGOUT', 'TOKEN_REFRESH'
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.TextField(blank=True, default='')
    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        ordering = ['-timestamp']


class MfaDevice(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='mfa_devices')
    name = models.CharField(max_length=100)
    device_type = models.CharField(max_length=30, default='WEBAUTHN_PASSKEY') # 'WEBAUTHN_PASSKEY', 'TOTP'
    credential_id = models.CharField(max_length=255, unique=True, db_index=True)
    public_key = models.TextField()
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.email} - {self.name} ({self.device_type})"

