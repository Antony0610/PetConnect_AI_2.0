from django.urls import path
from .views import (
    DeviceRegisterView,
    DevicePairView,
    DeviceUnpairView,
    CollarListCreateView,
    CollarDetailView,
    TelemetryIngestView,
    CollarLocationView,
    CollarHistoryView,
)

urlpatterns = [
    path('register/', DeviceRegisterView.as_view(), name='collar-register'),
    path('pair/', DevicePairView.as_view(), name='collar-pair'),
    path('unpair/', DeviceUnpairView.as_view(), name='collar-unpair'),
    path('', CollarListCreateView.as_view(), name='collar-list-create'),
    path('<uuid:pk>/', CollarDetailView.as_view(), name='collar-detail'),
    path('<uuid:pk>/telemetry/', TelemetryIngestView.as_view(), name='collar-telemetry'),
    path('<uuid:pk>/location/', CollarLocationView.as_view(), name='collar-location'),
    path('<uuid:pk>/history/', CollarHistoryView.as_view(), name='collar-history'),
]
