from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from apps.accounts.models import User, TenantOrganization, MfaDevice
from apps.smart_collar.models import SmartCollarDeviceStatus, SmartCollarOtaRollbackLog
from apps.smart_collar.services import SmartCollarService
from apps.ai_scan.models import AiModelRegistry, AiModelAbTestConfig
from apps.common.services import FcmNotificationService

class EnterpriseV11Tests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.tenant = TenantOrganization.objects.create(
            name='Central Veterinary Hospital Network',
            tenant_type='VET_HOSPITAL',
            slug='central-vet'
        )
        self.user = User.objects.create_user(
            username='enterpriseuser',
            email='enterprise@centralvet.com',
            password='Password123!',
            tenant=self.tenant,
            role='vet'
        )
        self.client.force_authenticate(user=self.user)

    def test_multi_tenancy_organization_assignment(self):
        self.assertEqual(self.user.tenant.name, 'Central Veterinary Hospital Network')
        self.assertEqual(self.tenant.members.count(), 1)

    def test_smart_collar_ota_rollback_execution(self):
        collar, prov_key = SmartCollarService.register_device(
            device_id='SC-9999-ROLLBACK',
            mac_address='AA:BB:CC:DD:EE:FF',
            secret_key='DeviceSecret123!'
        )
        collar.firmware_version = 'v2.0.0-FAULTY'
        collar.save()

        rollback_log = SmartCollarService.trigger_ota_rollback(
            collar=collar,
            attempted_version='v2.0.0-FAULTY',
            previous_version='v1.9.4-STABLE',
            reason='Checksum failure after update'
        )
        collar.refresh_from_db()
        self.assertEqual(collar.firmware_version, 'v1.9.4-STABLE')
        self.assertEqual(SmartCollarOtaRollbackLog.objects.count(), 1)
        self.assertEqual(rollback_log.rollback_status, 'SUCCESS')

    def test_ai_model_ab_testing_configuration(self):
        control = AiModelRegistry.objects.create(
            model_name='YOLOv8-Control', model_type='vision', version='v1.0'
        )
        candidate = AiModelRegistry.objects.create(
            model_name='YOLOv8-Candidate-v2', model_type='vision', version='v2.0'
        )
        ab_config = AiModelAbTestConfig.objects.create(
            test_name='Vision Accuracy Benchmark',
            control_model=control,
            candidate_model=candidate,
            candidate_traffic_percentage=25,
            is_shadow_mode=True
        )
        self.assertEqual(ab_config.candidate_traffic_percentage, 25)
        self.assertTrue(ab_config.is_shadow_mode)

    def test_fcm_notification_dispatch(self):
        success = FcmNotificationService.send_push_notification(
            user_id=str(self.user.id),
            title='Emergency SOS Alert',
            body='Stray rescue assigned near Central Park',
            data_payload={'incident_id': 'INC-100'}
        )
        self.assertTrue(success)

    def test_opentelemetry_tracing_middleware_headers(self):
        health_url = reverse('health-liveness')
        response = self.client.get(health_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('X-Trace-ID', response.headers)
        self.assertIn('X-Span-ID', response.headers)
        self.assertIn('X-Correlation-ID', response.headers)
