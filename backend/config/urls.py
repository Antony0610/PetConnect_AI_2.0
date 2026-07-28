from django.contrib import admin
from django.urls import path, include
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/common/', include('apps.common.urls')),
    path('api/v1/health/', include('apps.common.urls')),
    path('api/v1/auth/', include('apps.accounts.urls')),
    path('api/v1/pets/', include('apps.pets.urls')),
    path('api/v1/health-passport/', include('apps.health_passport.urls')),
    path('api/v1/collars/', include('apps.smart_collar.urls')),
    path('api/v1/ai/', include('apps.ai_scan.urls')),
    path('api/v1/ai/assistant/', include('apps.ai_assistant.urls')),
    path('api/v1/rescue/', include('apps.rescue.urls')),
    path('api/v1/admin/', include('apps.admin_dashboard.urls')),

    # OpenAPI 3.0 Documentation
    path('api/v1/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/v1/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
]
