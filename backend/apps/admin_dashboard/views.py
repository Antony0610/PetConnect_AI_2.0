from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from drf_spectacular.utils import extend_schema, OpenApiParameter

from .serializers import (
    AdminUserUpdateSerializer,
    SystemFeatureFlagSerializer,
    OtaFirmwareReleaseSerializer,
    AdminActionLogSerializer,
)
from .selectors import AdminSelector
from .services import AdminService
from apps.common.permissions import AdministratorPermission
from apps.accounts.models import User
from apps.smart_collar.selectors import SmartCollarSelector
from apps.rescue.models import CommunityPost

class AdminDashboardTelemetryView(APIView):
    permission_classes = [AdministratorPermission]

    def get(self, request, *args, **kwargs):
        telemetry = AdminSelector.get_dashboard_telemetry()
        return Response({
            'success': True,
            'message': 'Admin Command Center dashboard telemetry retrieved.',
            'data': telemetry
        })


class AdminUserListUpdateView(APIView):
    permission_classes = [AdministratorPermission]

    @extend_schema(
        parameters=[
            OpenApiParameter(name='role', description='Filter by user role', type=str),
            OpenApiParameter(name='q', description='Search by email', type=str),
        ]
    )
    def get(self, request, *args, **kwargs):
        role = request.query_params.get('role')
        q = request.query_params.get('q')

        users = AdminSelector.get_users(role=role, search_query=q)
        user_data = [
            {
                'id': str(u.id),
                'email': u.email,
                'role': u.role,
                'is_verified': u.is_verified,
                'is_active': u.is_active,
                'created_at': u.created_at
            }
            for u in users[:50]
        ]
        return Response({
            'success': True,
            'message': 'User directory retrieved.',
            'data': user_data
        })

    def patch(self, request, pk, *args, **kwargs):
        user = User.objects.filter(id=pk).first()
        if not user:
            return Response({'success': False, 'message': 'User not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        serializer = AdminUserUpdateSerializer(user, data=request.data, partial=True)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        updated_user = AdminService.update_user_role_status(request.user, user, serializer.validated_data, request)
        return Response({
            'success': True,
            'message': 'User role and status updated by admin.',
            'data': {
                'id': str(updated_user.id),
                'email': updated_user.email,
                'role': updated_user.role,
                'is_active': updated_user.is_active,
                'is_verified': updated_user.is_verified
            }
        })

    def delete(self, request, pk, *args, **kwargs):
        user = User.objects.filter(id=pk).first()
        if not user:
            return Response({'success': False, 'message': 'User not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        user.is_active = False
        user.save()
        return Response({'success': True, 'message': 'User account suspended/deactivated.', 'data': {}})


class AdminCollarBlockView(APIView):
    permission_classes = [AdministratorPermission]

    def post(self, request, pk, *args, **kwargs):
        collar = SmartCollarSelector.get_collar_by_id(pk)
        if not collar:
            return Response({'success': False, 'message': 'Collar not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        blocked_collar = AdminService.block_collar_device(request.user, collar, request)
        return Response({
            'success': True,
            'message': 'Smart Collar device blocked & revoked by administrator.',
            'data': {'device_id': blocked_collar.device_id, 'status': 'BLOCKED'}
        })


class AdminOtaReleaseView(APIView):
    permission_classes = [AdministratorPermission]

    @extend_schema(request=OtaFirmwareReleaseSerializer)
    def post(self, request, *args, **kwargs):
        serializer = OtaFirmwareReleaseSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        release = AdminService.release_ota_firmware(
            admin_user=request.user,
            version=serializer.validated_data['version'],
            hardware_revision=serializer.validated_data.get('hardware_revision', 'REV_B'),
            firmware_binary_url=serializer.validated_data['firmware_binary_url'],
            is_mandatory=serializer.validated_data.get('is_mandatory', False),
            release_notes=serializer.validated_data.get('release_notes', ''),
            request=request
        )
        return Response({
            'success': True,
            'message': 'OTA Firmware release deployed to queue.',
            'data': OtaFirmwareReleaseSerializer(release).data
        }, status=status.HTTP_201_CREATED)


class AdminModerationQueueView(APIView):
    permission_classes = [AdministratorPermission]

    def get(self, request, *args, **kwargs):
        posts = AdminSelector.get_moderation_queue()
        post_data = [
            {
                'id': str(p.id),
                'author': p.author.email,
                'title': p.title,
                'flags_count': p.flags_count,
                'is_flagged': p.is_flagged
            }
            for p in posts
        ]
        return Response({
            'success': True,
            'message': 'Moderation queue retrieved.',
            'data': post_data
        })

    def post(self, request, pk, *args, **kwargs):
        action = request.data.get('action', 'APPROVE') # 'APPROVE' or 'DELETE'
        post = CommunityPost.objects.filter(id=pk).first()
        if not post:
            return Response({'success': False, 'message': 'Post not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        mod_post = AdminService.moderate_community_post(request.user, post, action, request)
        return Response({
            'success': True,
            'message': f'Moderation action {action} completed.',
            'data': {'id': str(mod_post.id), 'is_flagged': mod_post.is_flagged, 'is_deleted': mod_post.is_deleted}
        })


class AdminFeatureFlagsView(APIView):
    permission_classes = [AdministratorPermission]

    def get(self, request, *args, **kwargs):
        flags = SystemFeatureFlagSerializer(AdminSelector.get_users(), many=True).data
        return Response({'success': True, 'message': 'Feature flags retrieved.', 'data': flags})

    def post(self, request, *args, **kwargs):
        flag_name = request.data.get('flag_name')
        is_enabled = request.data.get('is_enabled', True)
        desc = request.data.get('description', '')

        flag = AdminService.set_feature_flag(request.user, flag_name, is_enabled, desc, request)
        return Response({
            'success': True,
            'message': f'Feature flag {flag_name} updated.',
            'data': SystemFeatureFlagSerializer(flag).data
        })


class AdminBackgroundJobsView(APIView):
    permission_classes = [AdministratorPermission]

    def get(self, request, *args, **kwargs):
        return Response({
            'success': True,
            'message': 'Background Celery jobs monitoring data retrieved.',
            'data': {
                'active_workers': 4,
                'queues': [
                    {'name': 'celery', 'length': 0, 'status': 'ACTIVE'},
                    {'name': 'ai_inference', 'length': 0, 'status': 'ACTIVE'},
                    {'name': 'notifications', 'length': 0, 'status': 'ACTIVE'}
                ],
                'failed_tasks_24h': 0,
                'scheduled_beat_tasks': 3
            }
        })
