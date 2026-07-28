import uuid
import math
from django.db import transaction
from django.contrib.auth.hashers import make_password, check_password
from .models import (
    SmartCollarDeviceStatus,
    SmartCollarSecurityProfile,
    SmartCollarPairingHistory,
    SmartCollarTelemetryHistory,
    SmartCollarGeofenceEvent,
    DeviceStatusChoices,
)
from apps.pets.models import Pet
from apps.accounts.models import AuthAuditLog

class SmartCollarService:

    @staticmethod
    @transaction.atomic
    def register_device(device_id: str, mac_address: str, secret_key: str, firmware_version: str = 'v1.0.0'):
        collar = SmartCollarDeviceStatus.objects.create(
            device_id=device_id,
            mac_address=mac_address,
            firmware_version=firmware_version,
        )
        prov_key = f"PROV-{uuid.uuid4().hex[:12].upper()}"
        sec_profile = SmartCollarSecurityProfile.objects.create(
            collar=collar,
            device_uuid=uuid.uuid4(),
            device_secret_hash=make_password(secret_key),
            provisioning_key=prov_key,
            device_status=DeviceStatusChoices.REGISTERED
        )
        return collar, prov_key

    @staticmethod
    @transaction.atomic
    def pair_collar(user, collar: SmartCollarDeviceStatus, pet: Pet, method='BLE') -> SmartCollarPairingHistory:
        if collar.current_pet and collar.current_pet != pet:
            raise ValueError("This collar is already paired with another pet.")
        if hasattr(pet, 'smart_collar') and pet.smart_collar and pet.smart_collar != collar:
            raise ValueError("This pet is already assigned an active smart collar.")

        collar.current_pet = pet
        collar.save()

        sec_profile = collar.security_profile
        sec_profile.device_status = DeviceStatusChoices.ACTIVE
        sec_profile.save()

        history = SmartCollarPairingHistory.objects.create(
            collar=collar,
            pet=pet,
            paired_by=user,
            pairing_method=method,
            pairing_status='ACTIVE'
        )

        AuthAuditLog.objects.create(
            user=user,
            event_type='DEVICE_PAIRED',
            ip_address='', user_agent=''
        )
        return history

    @staticmethod
    @transaction.atomic
    def unpair_collar(user, collar: SmartCollarDeviceStatus) -> None:
        if not collar.current_pet:
            return

        active_history = SmartCollarPairingHistory.objects.filter(collar=collar, pairing_status='ACTIVE').first()
        if active_history:
            active_history.pairing_status = 'UNPAIRED'
            active_history.unpaired_at = transaction.now()
            active_history.save()

        collar.current_pet = None
        collar.save()

        sec_profile = collar.security_profile
        sec_profile.device_status = DeviceStatusChoices.REGISTERED
        sec_profile.save()

        AuthAuditLog.objects.create(
            user=user,
            event_type='DEVICE_UNPAIRED',
            ip_address='', user_agent=''
        )

    @staticmethod
    @transaction.atomic
    def ingest_telemetry(collar: SmartCollarDeviceStatus, data: dict, request=None) -> SmartCollarTelemetryHistory:
        sec_profile = collar.security_profile

        # 1. Device Security & Status Validation
        if sec_profile.device_status in [DeviceStatusChoices.BLOCKED, DeviceStatusChoices.RETIRED]:
            if request:
                AuthAuditLog.objects.create(
                    user=None,
                    event_type='UNAUTHORIZED_TELEMETRY_ATTEMPT',
                    ip_address=request.META.get('REMOTE_ADDR', ''),
                    user_agent=f"Collar {collar.device_id} is BLOCKED/RETIRED"
                )
            raise ValueError(f"Telemetry rejected: Device is in {sec_profile.device_status} state.")

        if not collar.current_pet:
            raise ValueError("Telemetry rejected: Device is not paired with an active pet.")

        if not check_password(data['device_secret'], sec_profile.device_secret_hash):
            raise ValueError("Telemetry rejected: Invalid device secret.")

        # 2. Update Live Device Status Cache
        collar.current_latitude = data['latitude']
        collar.current_longitude = data['longitude']
        collar.current_heart_rate = data['heart_rate_bpm']
        collar.current_temperature = data['temperature_fahrenheit']
        collar.battery_percentage = data['battery_percentage']
        collar.rssi_dbm = data['rssi_dbm']
        collar.is_online = True
        collar.save()

        # 3. Create Immutable Time-Series Record
        pet = collar.current_pet
        log = SmartCollarTelemetryHistory.objects.create(
            collar=collar,
            pet=pet,
            owner=pet.owner,
            latitude=data['latitude'],
            longitude=data['longitude'],
            heart_rate_bpm=data['heart_rate_bpm'],
            respiratory_rate=data.get('respiratory_rate', 24),
            temperature_fahrenheit=data['temperature_fahrenheit'],
            steps_count=data.get('steps_count', 0),
            sleep_hours=data.get('sleep_hours', 0.0),
            activity_level=data.get('activity_level', 'Resting'),
            battery_percentage=data['battery_percentage'],
            rssi_dbm=data['rssi_dbm'],
            is_sos_triggered=data.get('is_sos_triggered', False)
        )

        # 4. Geofence Distance Check
        if collar.is_geofence_active and collar.geofence_center_lat != 0.0:
            dist_meters = SmartCollarService.haversine_distance(
                collar.geofence_center_lat, collar.geofence_center_lon,
                data['latitude'], data['longitude']
            )
            if dist_meters > collar.geofence_radius_meters:
                SmartCollarGeofenceEvent.objects.create(
                    collar=collar, pet=pet, event_type='EXIT',
                    latitude=data['latitude'], longitude=data['longitude']
                )

        if data.get('is_sos_triggered'):
            SmartCollarGeofenceEvent.objects.create(
                collar=collar, pet=pet, event_type='SOS',
                latitude=data['latitude'], longitude=data['longitude']
            )

        return log

    @staticmethod
    def haversine_distance(lat1, lon1, lat2, lon2):
        R = 6371000  # radius of Earth in meters
        phi1 = math.radians(lat1)
        phi2 = math.radians(lat2)
        delta_phi = math.radians(lat2 - lat1)
        delta_lambda = math.radians(lon2 - lon1)
        a = math.sin(delta_phi / 2)**2 + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2)**2
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
        return R * c

    @staticmethod
    @transaction.atomic
    def trigger_ota_rollback(collar: SmartCollarDeviceStatus, attempted_version: str, previous_version: str, reason: str) -> SmartCollarOtaRollbackLog:
        collar.firmware_version = previous_version
        collar.save()

        rollback_log = SmartCollarOtaRollbackLog.objects.create(
            collar=collar,
            attempted_version=attempted_version,
            rolled_back_to_version=previous_version,
            rollback_reason=reason,
            rollback_status='SUCCESS'
        )

        AuthAuditLog.objects.create(
            user=None,
            event_type='OTA_ROLLBACK_EXECUTED',
            ip_address='',
            user_agent=f"Collar {collar.device_id} rolled back from {attempted_version} to {previous_version}"
        )
        return rollback_log

