from django.urls import path
from .views import VisionAnalyzeView, PetIdentifyView, HealthRiskAnalysisView, RecommendationEngineView

urlpatterns = [
    path('vision/analyze/', VisionAnalyzeView.as_view(), name='ai-vision-analyze'),
    path('identify/', PetIdentifyView.as_view(), name='ai-identify'),
    path('risk-analysis/', HealthRiskAnalysisView.as_view(), name='ai-risk-analysis'),
    path('recommendations/', RecommendationEngineView.as_view(), name='ai-recommendations'),
]
