from django.db import transaction
from .models import HealthPassportRecord
from apps.accounts.models import AuthAuditLog

class HealthPassportService:
    @staticmethod
    @transaction.atomic
    def create_record(user, validated_data, request=None) -> HealthPassportRecord:
        record = HealthPassportRecord.objects.create(
            created_by=user,
            **validated_data
        )
        if request:
            AuthAuditLog.objects.create(
                user=user,
                event_type='HEALTH_PASSPORT_CREATED',
                ip_address=request.META.get('REMOTE_ADDR', ''),
                user_agent=request.META.get('HTTP_USER_AGENT', '')
            )
        return record

    @staticmethod
    @transaction.atomic
    def update_record(record: HealthPassportRecord, validated_data, user, request=None) -> HealthPassportRecord:
        for key, value in validated_data.items():
            setattr(record, key, value)
        record.updated_by = user
        record.save()
        if request:
            AuthAuditLog.objects.create(
                user=user,
                event_type='HEALTH_PASSPORT_UPDATED',
                ip_address=request.META.get('REMOTE_ADDR', ''),
                user_agent=request.META.get('HTTP_USER_AGENT', '')
            )
        return record

    @staticmethod
    @transaction.atomic
    def soft_delete_record(record: HealthPassportRecord, user, request=None) -> None:
        record.is_deleted = True
        record.is_active = False
        record.save()
        if request:
            AuthAuditLog.objects.create(
                user=user,
                event_type='HEALTH_PASSPORT_DELETED',
                ip_address=request.META.get('REMOTE_ADDR', ''),
                user_agent=request.META.get('HTTP_USER_AGENT', '')
            )
