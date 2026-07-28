import uuid
from django.db import models
from django.conf import settings

class AdminActionLog(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    admin_user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True)
    action_type = models.CharField(max_length=100, db_index=True) # e.g., 'SUSPEND_USER', 'BLOCK_COLLAR', 'OTA_RELEASE', 'MODERATION'
    target_entity = models.CharField(max_length=50)
    target_id = models.CharField(max_length=100, blank=True, default='')
    details = models.TextField(blank=True, default='')
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        ordering = ['-timestamp']


class SystemFeatureFlag(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    flag_name = models.CharField(max_length=100, unique=True, db_index=True)
    is_enabled = models.BooleanField(default=True, db_index=True)
    description = models.TextField(blank=True, default='')
    parameters = models.JSONField(default=dict, blank=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.flag_name}: {'ENABLED' if self.is_enabled else 'DISABLED'}"


class OtaFirmwareRelease(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    version = models.CharField(max_length=30, unique=True, db_index=True)
    hardware_revision = models.CharField(max_length=50, default='REV_B')
    firmware_binary_url = models.URLField(max_length=500)
    is_mandatory = models.BooleanField(default=False)
    release_notes = models.TextField(blank=True, default='')
    released_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Firmware Release {self.version} ({self.hardware_revision})"
