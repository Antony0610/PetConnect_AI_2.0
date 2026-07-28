from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from apps.accounts.models import User
from apps.pets.models import Pet
from apps.smart_collar.models import SmartCollarDeviceStatus
from apps.smart_collar.services import SmartCollarService
from apps.common.providers.ai_providers import AiProviderFactory
from apps.common.providers.storage_providers import StorageProviderFactory
from apps.common.providers.health import ProviderHealthMonitor
from apps.common.services import FcmNotificationService

class AcademicDemonstrationV114Tests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username='academicuser',
            email='academic@petconnect.ai',
            password='Password123!',
            role='pet_owner'
        )
        self.client.force_authenticate(user=self.user)
        self.pet = Pet.objects.create(
            owner=self.user,
            name='Max',
            species='canine',
            breed='Labrador Retriever'
        )

    def test_pure_engineering_ai_telemetry_without_cost_metrics(self):
        s3 = StorageProviderFactory.get_provider('s3')
        upload_url = s3.generate_signed_url(f"pets/{self.pet.id}/scan.jpg")

        gemini = AiProviderFactory.get_provider('gemini')
        ai_res = gemini.analyze_vision('skin_disease', upload_url)

        self.assertEqual(ai_res['provider'], 'Google Gemini API')
        self.assertEqual(ai_res['model'], 'Gemini Free Tier')
        self.assertIn('telemetry', ai_res)

        telemetry = ai_res['telemetry']
        self.assertIn('latency_ms', telemetry)
        self.assertIn('tokens_used', telemetry)
        self.assertIn('inference_status', telemetry)

        # Assert no monetary pricing keys exist anywhere in backend response
        self.assertNotIn('cost_usd', telemetry)
        self.assertNotIn('estimated_cost', telemetry)
        self.assertNotIn('estimated_cost_inr', telemetry)
        self.assertNotIn('token_price', telemetry)

    def test_e2e_academic_workflow(self):
        push_sent = FcmNotificationService.send_push_notification(
            user_id=str(self.user.id),
            title='AI Vision Scan Complete',
            body='Diagnostic result complete.'
        )
        self.assertTrue(push_sent)

        collar, prov_key = SmartCollarService.register_device(
            device_id='SC-ACADEMIC-E2E',
            mac_address='11:22:33:44:55:66',
            secret_key='DeviceSecret123!'
        )
        SmartCollarService.pair_device(collar, self.pet, self.user)
        telemetry = SmartCollarService.record_telemetry(
            collar=collar,
            data={
                'heart_rate_bpm': 88,
                'temperature_fahrenheit': 101.2,
                'steps_count': 1420,
                'sleep_hours': 7.5,
                'activity_level': 'Active',
                'battery_percentage': 95,
                'rssi_dbm': -62,
                'latitude': 37.7749,
                'longitude': -122.4194,
                'is_sos_triggered': False
            }
        )
        self.assertEqual(telemetry.heart_rate_bpm, 88)

        health = ProviderHealthMonitor.get_all_provider_statuses()
        self.assertEqual(health['gemini_api']['status'], 'ONLINE')
