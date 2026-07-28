from rest_framework import serializers
from .models import AdminActionLog, SystemFeatureFlag, OtaFirmwareRelease
from apps.accounts.models import User

class AdminUserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['role', 'is_active', 'is_verified']


class SystemFeatureFlagSerializer(serializers.ModelSerializer):
    class Meta:
        model = SystemFeatureFlag
        fields = '__all__'


class OtaFirmwareReleaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = OtaFirmwareRelease
        fields = '__all__'


class AdminActionLogSerializer(serializers.ModelSerializer):
    admin_email = serializers.EmailField(source='admin_user.email', read_only=True)

    class Meta:
        model = AdminActionLog
        fields = '__all__'
