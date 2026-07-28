from .models import (
    SmartCollarDeviceStatus,
    SmartCollarTelemetryHistory,
    SmartCollarGeofenceEvent,
)

class SmartCollarSelector:
    @staticmethod
    def get_collars_for_user(user):
        qs = SmartCollarDeviceStatus.objects.filter(is_deleted=False).select_related('current_pet', 'security_profile')
        if user.role == 'pet_owner':
            qs = qs.filter(current_pet__owner=user)
        return qs

    @staticmethod
    def get_collar_by_id(collar_id):
        return SmartCollarDeviceStatus.objects.filter(id=collar_id, is_deleted=False).select_related('current_pet', 'security_profile').first()

    @staticmethod
    def get_telemetry_history(collar_id, limit=50):
        return SmartCollarTelemetryHistory.objects.filter(collar_id=collar_id).select_related('pet', 'owner')[:limit]
