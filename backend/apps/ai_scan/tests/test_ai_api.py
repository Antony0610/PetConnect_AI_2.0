from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from apps.accounts.models import User
from apps.pets.models import Pet
from apps.ai_scan.models import AiScanResult, AiHealthRiskAssessment

class AIServicesAPITests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username='aiuser',
            email='ai.user@petconnect.ai',
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

        self.vision_url = reverse('ai-vision-analyze')
        self.identify_url = reverse('ai-identify')
        self.risk_url = reverse('ai-risk-analysis')
        self.recommendations_url = reverse('ai-recommendations')
        self.chat_url = reverse('ai-assistant-chat')

    def test_vision_analyze_skin_disease(self):
        payload = {
            'scan_mode': 'skin_disease',
            'image_url': 'https://storage.petconnect.ai/scans/skin_sample.jpg',
            'pet_id': str(self.pet.id)
        }
        response = self.client.post(self.vision_url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertIn('Benign Allergic Dermatitis', response.data['data']['primary_diagnosis'])
        self.assertEqual(AiScanResult.objects.count(), 1)

    def test_pet_biometric_identification(self):
        payload = {
            'method': 'noseprint',
            'biometric_data': 'NOSEPRINT-EMBEDDING-RAW-HASH'
        }
        response = self.client.post(self.identify_url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertTrue(response.data['data']['matched'])

    def test_health_risk_analysis(self):
        payload = {'pet_id': str(self.pet.id)}
        response = self.client.post(self.risk_url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertEqual(AiHealthRiskAssessment.objects.count(), 1)

    def test_rag_assistant_chat(self):
        payload = {
            'pet_id': str(self.pet.id),
            'message': 'My dog seems slightly lethargic today, what should I check?',
            'provider': 'gemini'
        }
        response = self.client.post(self.chat_url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertIn('session_id', response.data['data'])
