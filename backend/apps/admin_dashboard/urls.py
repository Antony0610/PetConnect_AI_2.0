from django.urls import path
from .views import (
    AdminDashboardTelemetryView,
    AdminUserListUpdateView,
    AdminCollarBlockView,
    AdminOtaReleaseView,
    AdminModerationQueueView,
    AdminFeatureFlagsView,
    AdminBackgroundJobsView,
)

urlpatterns = [
    path('dashboard/', AdminDashboardTelemetryView.as_view(), name='admin-dashboard'),
    path('telemetry/', AdminDashboardTelemetryView.as_view(), name='admin-telemetry'),
    path('users/', AdminUserListUpdateView.as_view(), name='admin-users-list'),
    path('users/<uuid:pk>/', AdminUserListUpdateView.as_view(), name='admin-users-detail'),
    path('collars/<uuid:pk>/block/', AdminCollarBlockView.as_view(), name='admin-collar-block'),
    path('collars/ota/release/', AdminOtaReleaseView.as_view(), name='admin-ota-release'),
    path('moderation/', AdminModerationQueueView.as_view(), name='admin-moderation-queue'),
    path('moderation/<uuid:pk>/action/', AdminModerationQueueView.as_view(), name='admin-moderation-action'),
    path('system/flags/', AdminFeatureFlagsView.as_view(), name='admin-feature-flags'),
    path('background-jobs/', AdminBackgroundJobsView.as_view(), name='admin-background-jobs'),
]
