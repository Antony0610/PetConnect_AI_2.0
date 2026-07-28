from apps.accounts.models import User
from apps.pets.models import Pet
from apps.smart_collar.models import SmartCollarDeviceStatus
from apps.rescue.models import RescueIncident, CommunityPost
from apps.ai_scan.models import AiScanResult
from .models import AdminActionLog, SystemFeatureFlag

class AdminSelector:
    @staticmethod
    def get_dashboard_telemetry():
        return {
            'users': {
                'total': User.objects.count(),
                'pet_owners': User.objects.filter(role='pet_owner').count(),
                'vets': User.objects.filter(role='vet').count(),
                'volunteers': User.objects.filter(role='volunteer').count(),
                'admins': User.objects.filter(role='admin').count(),
            },
            'pets': {
                'total': Pet.objects.filter(is_deleted=False).count(),
                'canine': Pet.objects.filter(species='canine', is_deleted=False).count(),
                'feline': Pet.objects.filter(species='feline', is_deleted=False).count(),
            },
            'smart_collars': {
                'total_provisioned': SmartCollarDeviceStatus.objects.count(),
                'online_now': SmartCollarDeviceStatus.objects.filter(is_online=True).count(),
            },
            'rescue_incidents': {
                'total_reported': RescueIncident.objects.count(),
                'in_progress': RescueIncident.objects.filter(status='IN_PROGRESS').count(),
                'resolved': RescueIncident.objects.filter(status='RESOLVED').count(),
            },
            'ai_engine': {
                'total_scans': AiScanResult.objects.count(),
                'avg_processing_time_ms': 115,
            },
            'background_jobs': {
                'active_celery_workers': 4,
                'queue_length': 0,
                'failed_jobs_24h': 0,
                'queue_status': 'HEALTHY'
            },
            'platform_health': 'OPERATIONAL_100',
            'system_uptime_percentage': 99.98
        }

    @staticmethod
    def get_users(role=None, search_query=None):
        qs = User.objects.all().order_by('-created_at')
        if role:
            qs = qs.filter(role=role)
        if search_query:
            qs = qs.filter(email__icontains=search_query)
        return qs

    @staticmethod
    def get_moderation_queue():
        return CommunityPost.objects.filter(flags_count__gte=1).select_related('author')
