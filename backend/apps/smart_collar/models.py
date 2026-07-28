import uuid
from django.db import models
from django.conf import settings
from apps.common.models import BaseModel
from apps.pets.models import Pet

class DeviceStatusChoices(models.TextChoices):
    REGISTERED = 'REGISTERED', 'Registered'
    ACTIVE = 'ACTIVE', 'Active'
    BLOCKED = 'BLOCKED', 'Blocked'
    RETIRED = 'RETIRED', 'Retired'

class PairingMethodChoices(models.TextChoices):
    BLE = 'BLE', 'Bluetooth Low Energy'
    QR = 'QR', 'QR Code Scan'
    MANUAL = 'MANUAL', 'Manual Input'

class PairingStatusChoices(models.TextChoices):
    ACTIVE = 'ACTIVE', 'Active'
    UNPAIRED = 'UNPAIRED', 'Unpaired'
    REPLACED = 'REPLACED', 'Replaced'

class GeofenceEventType(models.TextChoices):
    ENTRY = 'ENTRY', 'Geofence Entry'
    EXIT = 'EXIT', 'Geofence Exit'
    SOS = 'SOS', 'Emergency SOS Triggered'


class SmartCollarDeviceStatus(BaseModel):
    current_pet = models.OneToOneField(
        Pet,
        on_delete=models.SET_NULL,
        null=True, blank=True,
        related_name='smart_collar',
        db_index=True
    )
    device_id = models.CharField(max_length=100, unique=True, db_index=True)
    mac_address = models.CharField(max_length=50, unique=True, db_index=True)
    firmware_version = models.CharField(max_length=30, default='v1.0.0')

    battery_percentage = models.IntegerField(default=100)
    current_latitude = models.FloatField(default=0.0)
    current_longitude = models.FloatField(default=0.0)
    current_heart_rate = models.IntegerField(default=0)
    current_temperature = models.FloatField(default=98.6)
    rssi_dbm = models.IntegerField(default=-65)

    is_online = models.BooleanField(default=True, db_index=True)
    connection_count = models.IntegerField(default=1)
    last_ip_address = models.GenericIPAddressField(null=True, blank=True)

    is_geofence_active = models.BooleanField(default=True)
    geofence_radius_meters = models.FloatField(default=150.0)
    geofence_center_lat = models.FloatField(default=0.0)
    geofence_center_lon = models.FloatField(default=0.0)

    last_seen_at = models.DateTimeField(auto_now=True, db_index=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Collar {self.device_id} ({self.mac_address})"


class SmartCollarSecurityProfile(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    collar = models.OneToOneField(
        SmartCollarDeviceStatus,
        on_delete=models.CASCADE,
        related_name='security_profile'
    )
    device_uuid = models.UUIDField(default=uuid.uuid4, unique=True, db_index=True)
    device_secret_hash = models.CharField(max_length=255)
    provisioning_key = models.CharField(max_length=100, unique=True, db_index=True)
    device_auth_token_hash = models.CharField(max_length=255, blank=True, default='')
    device_certificate_thumbprint = models.CharField(max_length=255, blank=True, default='')

    device_status = models.CharField(
        max_length=20,
        choices=DeviceStatusChoices.choices,
        default=DeviceStatusChoices.REGISTERED,
        db_index=True
    )
    registered_at = models.DateTimeField(auto_now_add=True)
    last_authenticated_at = models.DateTimeField(null=True, blank=True)
    secret_rotated_at = models.DateTimeField(null=True, blank=True)
    firmware_min_compat_version = models.CharField(max_length=30, default='v1.0.0')

    def __str__(self):
        return f"SecurityProfile {self.device_uuid} [{self.device_status}]"


class SmartCollarPairingHistory(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    collar = models.ForeignKey(SmartCollarDeviceStatus, on_delete=models.CASCADE, related_name='pairing_history')
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE, related_name='collar_history')
    paired_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True)

    pairing_method = models.CharField(max_length=20, choices=PairingMethodChoices.choices, default=PairingMethodChoices.BLE)
    pairing_status = models.CharField(max_length=20, choices=PairingStatusChoices.choices, default=PairingStatusChoices.ACTIVE)
    paired_at = models.DateTimeField(auto_now_add=True, db_index=True)
    unpaired_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ['-paired_at']


class SmartCollarTelemetryHistory(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    collar = models.ForeignKey(SmartCollarDeviceStatus, on_delete=models.CASCADE, related_name='telemetry_logs')
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE, related_name='telemetry_logs')
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='collar_telemetry')

    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)
    latitude = models.FloatField()
    longitude = models.FloatField()
    heart_rate_bpm = models.IntegerField()
    respiratory_rate = models.IntegerField(default=24)
    temperature_fahrenheit = models.FloatField()
    steps_count = models.IntegerField(default=0)
    sleep_hours = models.FloatField(default=0.0)
    activity_level = models.CharField(max_length=50, default='Resting')
    battery_percentage = models.IntegerField()
    rssi_dbm = models.IntegerField()
    is_sos_triggered = models.BooleanField(default=False, db_index=True)

    class Meta:
        ordering = ['-timestamp']
        indexes = [
            models.Index(fields=['pet', '-timestamp']),
            models.Index(fields=['collar', '-timestamp']),
            models.Index(fields=['owner', '-timestamp']),
            models.Index(fields=['is_sos_triggered', '-timestamp']),
        ]


class SmartCollarGeofenceEvent(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    collar = models.ForeignKey(SmartCollarDeviceStatus, on_delete=models.CASCADE, related_name='geofence_events')
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE, related_name='geofence_events')

    event_type = models.CharField(max_length=20, choices=GeofenceEventType.choices, db_index=True)
    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)
    latitude = models.FloatField()
    longitude = models.FloatField()

    class Meta:
        ordering = ['-timestamp']


class SmartCollarOtaRollbackLog(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    collar = models.ForeignKey(SmartCollarDeviceStatus, on_delete=models.CASCADE, related_name='ota_rollbacks')
    attempted_version = models.CharField(max_length=30)
    rolled_back_to_version = models.CharField(max_length=30)
    rollback_reason = models.TextField()
    rollback_status = models.CharField(max_length=20, default='SUCCESS') # 'SUCCESS', 'FAILED'
    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        ordering = ['-timestamp']

