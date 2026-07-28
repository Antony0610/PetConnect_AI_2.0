from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from apps.accounts.models import User
from apps.pets.models import Pet
from apps.ai_scan.services import AiService

class PerformanceAndQualityV111Tests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username='v111user',
            email='v111@petconnect.ai',
            password='Password123!',
            role='pet_owner'
        )
        self.client.force_authenticate(user=self.user)
        self.pet = Pet.objects.create(
            owner=self.user,
            name='Luna',
            species='canine',
            breed='Golden Retriever'
        )

    def test_calibrated_ai_vision_confidence(self):
        scan_result = AiService.process_vision_analysis(
            user=self.user,
            scan_mode='skin_disease',
            image_url='https://storage.petconnect.ai/skin.jpg',
            pet_id=str(self.pet.id)
        )
        self.assertGreater(scan_result.confidence_score, 0.940)
        self.assertEqual(scan_result.processing_time_ms, 78)
        self.assertIn('Ensemble Model', scan_result.diagnostic_summary)

    def test_health_check_probes_latency(self):
        liveness_url = reverse('health-liveness')
        readiness_url = reverse('health-readiness')

        response_live = self.client.get(liveness_url)
        self.assertEqual(response_live.status_code, status.HTTP_200_OK)

        response_ready = self.client.get(readiness_url)
        self.assertEqual(response_ready.status_code, status.HTTP_200_OK)
