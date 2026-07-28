from django.urls import path
from .views import HealthCheckView, LivenessProbeView, ReadinessProbeView, StartupProbeView

urlpatterns = [
    path('', HealthCheckView.as_view(), name='health-check'),
    path('liveness/', LivenessProbeView.as_view(), name='health-liveness'),
    path('readiness/', ReadinessProbeView.as_view(), name='health-readiness'),
    path('startup/', StartupProbeView.as_view(), name='health-startup'),
]
