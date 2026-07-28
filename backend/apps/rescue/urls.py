from django.urls import path
from .views import (
    ReportLostPetView,
    ReportFoundPetView,
    RequestEmergencyRescueView,
    RescueIncidentListCreateView,
    RescueIncidentDetailView,
    AcceptDispatchView,
    DeclineDispatchView,
    NearbyVolunteersView,
    CommunityPostListCreateView,
    FlagCommunityPostView,
)

urlpatterns = [
    path('lost/', ReportLostPetView.as_view(), name='rescue-report-lost'),
    path('found/', ReportFoundPetView.as_view(), name='rescue-report-found'),
    path('request/', RequestEmergencyRescueView.as_view(), name='rescue-emergency-request'),
    path('', RescueIncidentListCreateView.as_view(), name='rescue-list-create'),
    path('<uuid:pk>/', RescueIncidentDetailView.as_view(), name='rescue-detail'),
    path('<uuid:pk>/accept/', AcceptDispatchView.as_view(), name='rescue-accept'),
    path('<uuid:pk>/decline/', DeclineDispatchView.as_view(), name='rescue-decline'),
    path('volunteers/', NearbyVolunteersView.as_view(), name='rescue-volunteers'),
    path('community/posts/', CommunityPostListCreateView.as_view(), name='community-post-list-create'),
    path('community/posts/<uuid:pk>/flag/', FlagCommunityPostView.as_view(), name='community-post-flag'),
]
