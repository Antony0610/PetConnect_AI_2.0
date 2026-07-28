from django.db import transaction
from .models import AdminActionLog, SystemFeatureFlag, OtaFirmwareRelease
from apps.accounts.models import User, AuthAuditLog
from apps.smart_collar.models import SmartCollarDeviceStatus, DeviceStatusChoices
from apps.rescue.models import CommunityPost

class AdminService:

    @staticmethod
    @transaction.atomic
    def update_user_role_status(admin_user, target_user: User, validated_data, request=None) -> User:
        for key, value in validated_data.items():
            setattr(target_user, key, value)
        target_user.save()

        AdminActionLog.objects.create(
            admin_user=admin_user,
            action_type='ADMIN_USER_UPDATED',
            target_entity='User',
            target_id=str(target_user.id),
            details=f"Updated role/status: {validated_data}",
            ip_address=request.META.get('REMOTE_ADDR', '') if request else ''
        )
        return target_user

    @staticmethod
    @transaction.atomic
    def block_collar_device(admin_user, collar: SmartCollarDeviceStatus, request=None) -> SmartCollarDeviceStatus:
        sec_profile = collar.security_profile
        sec_profile.device_status = DeviceStatusChoices.BLOCKED
        sec_profile.save()

        collar.is_online = False
        collar.save()

        AdminActionLog.objects.create(
            admin_user=admin_user,
            action_type='ADMIN_COLLAR_BLOCKED',
            target_entity='SmartCollarDeviceStatus',
            target_id=str(collar.id),
            details=f"Blocked collar {collar.device_id}",
            ip_address=request.META.get('REMOTE_ADDR', '') if request else ''
        )
        return collar

    @staticmethod
    @transaction.atomic
    def release_ota_firmware(admin_user, version: str, hardware_revision: str, firmware_binary_url: str, is_mandatory=False, release_notes="", request=None) -> OtaFirmwareRelease:
        release = OtaFirmwareRelease.objects.create(
            version=version,
            hardware_revision=hardware_revision,
            firmware_binary_url=firmware_binary_url,
            is_mandatory=is_mandatory,
            release_notes=release_notes
        )
        AdminActionLog.objects.create(
            admin_user=admin_user,
            action_type='ADMIN_OTA_RELEASE',
            target_entity='OtaFirmwareRelease',
            target_id=str(release.id),
            details=f"Released OTA Firmware {version}",
            ip_address=request.META.get('REMOTE_ADDR', '') if request else ''
        )
        return release

    @staticmethod
    @transaction.atomic
    def moderate_community_post(admin_user, post: CommunityPost, action: str, request=None) -> CommunityPost:
        if action == 'APPROVE':
            post.is_flagged = False
            post.flags_count = 0
        elif action == 'DELETE':
            post.is_deleted = True
            post.is_active = False

        post.save()

        AdminActionLog.objects.create(
            admin_user=admin_user,
            action_type='ADMIN_MODERATION_ACTION',
            target_entity='CommunityPost',
            target_id=str(post.id),
            details=f"Moderation action: {action}",
            ip_address=request.META.get('REMOTE_ADDR', '') if request else ''
        )
        return post

    @staticmethod
    @transaction.atomic
    def set_feature_flag(admin_user, flag_name: str, is_enabled: bool, description="", request=None) -> SystemFeatureFlag:
        flag, _ = SystemFeatureFlag.objects.get_or_create(flag_name=flag_name)
        flag.is_enabled = is_enabled
        if description:
            flag.description = description
        flag.save()

        AdminActionLog.objects.create(
            admin_user=admin_user,
            action_type='ADMIN_FEATURE_FLAG_UPDATED',
            target_entity='SystemFeatureFlag',
            target_id=str(flag.id),
            details=f"Feature flag {flag_name} set to {is_enabled}",
            ip_address=request.META.get('REMOTE_ADDR', '') if request else ''
        )
        return flag
