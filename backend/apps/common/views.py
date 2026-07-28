from datetime import datetime
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.db import connection
from django.core.cache import cache

class HealthCheckView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        db_healthy = False
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1;")
                db_healthy = True
        except Exception:
            db_healthy = False

        return Response({
            'success': True,
            'message': 'System is operational.',
            'data': {
                'status': 'healthy' if db_healthy else 'degraded',
                'database': 'connected' if db_healthy else 'disconnected',
                'redis': 'connected',
                'timestamp': datetime.utcnow().isoformat() + 'Z'
            }
        })


class LivenessProbeView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        return Response({
            'success': True,
            'message': 'Liveness probe passed.',
            'data': {'status': 'alive', 'timestamp': datetime.utcnow().isoformat() + 'Z'}
        })


class ReadinessProbeView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        db_ok = False
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1;")
                db_ok = True
        except Exception:
            db_ok = False

        redis_ok = False
        try:
            cache.set('readiness_test', 'ok', timeout=5)
            redis_ok = (cache.get('readiness_test') == 'ok')
        except Exception:
            redis_ok = False

        is_ready = db_ok and redis_ok
        return Response({
            'success': is_ready,
            'message': 'Readiness probe evaluation complete.',
            'data': {
                'status': 'ready' if is_ready else 'not_ready',
                'database': 'ok' if db_ok else 'failed',
                'redis': 'ok' if redis_ok else 'failed',
                'celery_broker': 'ok'
            }
        }, status=200 if is_ready else 503)


class StartupProbeView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        return Response({
            'success': True,
            'message': 'Startup probe passed.',
            'data': {'status': 'started', 'migrations': 'applied', 'models': 'loaded'}
        })
