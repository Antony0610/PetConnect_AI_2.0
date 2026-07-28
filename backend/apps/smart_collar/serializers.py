from rest_framework import serializers
from .models import (
    SmartCollarDeviceStatus,
    SmartCollarSecurityProfile,
    SmartCollarPairingHistory,
    SmartCollarTelemetryHistory,
    SmartCollarGeofenceEvent,
)

class SmartCollarDeviceStatusSerializer(serializers.ModelSerializer):
    pet_name = serializers.CharField(source='current_pet.name', read_only=True)
    device_status = serializers.CharField(source='security_profile.device_status', read_only=True)

    class Meta:
        model = SmartCollarDeviceStatus
        fields = [
            'id', 'current_pet', 'pet_name', 'device_id', 'mac_address', 'firmware_version',
            'battery_percentage', 'current_latitude', 'current_longitude', 'current_heart_rate',
            'current_temperature', 'rssi_dbm', 'is_online', 'is_geofence_active',
            'geofence_radius_meters', 'geofence_center_lat', 'geofence_center_lon',
            'device_status', 'last_seen_at'
        ]
        read_only_fields = ['id', 'last_seen_at']


class DeviceRegistrationSerializer(serializers.Serializer):
    device_id = serializers.CharField(max_length=100)
    mac_address = serializers.CharField(max_length=50)
    secret_key = serializers.CharField(write_only=True, min_length=8)
    firmware_version = serializers.CharField(default='v1.0.0')


class DevicePairingSerializer(serializers.Serializer):
    collar_id = serializers.UUIDField()
    pet_id = serializers.UUIDField()
    pairing_method = serializers.ChoiceField(choices=['BLE', 'QR', 'MANUAL'], default='BLE')


class TelemetryIngestionSerializer(serializers.Serializer):
    latitude = serializers.FloatField()
    longitude = serializers.FloatField()
    heart_rate_bpm = serializers.IntegerField()
    respiratory_rate = serializers.IntegerField(default=24)
    temperature_fahrenheit = serializers.FloatField()
    steps_count = serializers.IntegerField(default=0)
    sleep_hours = serializers.FloatField(default=0.0)
    activity_level = serializers.CharField(default='Resting')
    battery_percentage = serializers.IntegerField()
    rssi_dbm = serializers.IntegerField()
    is_sos_triggered = serializers.BooleanField(default=False)
    device_secret = serializers.CharField(write_only=True)


class SmartCollarTelemetryHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = SmartCollarTelemetryHistory
        fields = '__all__'


class SmartCollarGeofenceEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = SmartCollarGeofenceEvent
        fields = '__all__'
