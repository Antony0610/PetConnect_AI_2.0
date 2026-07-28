from django.urls import path
from .views import HealthPassportListCreateView, HealthPassportDetailView

urlpatterns = [
    path('', HealthPassportListCreateView.as_view(), name='health-passport-list-create'),
    path('<uuid:pk>/', HealthPassportDetailView.as_view(), name='health-passport-detail'),
]
