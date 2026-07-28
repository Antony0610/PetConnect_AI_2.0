from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from apps.accounts.models import User
from apps.pets.models import Pet
from apps.smart_collar.models import SmartCollarDeviceStatus
from apps.smart_collar.services import SmartCollarService

class SmartCollarAPITests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username='collarowner',
            email='collar.owner@petconnect.ai',
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

        self.collar, self.prov_key = SmartCollarService.register_device(
            device_id='SC-9821-BLE',
            mac_address='71:A2:88:CF:99:00',
            secret_key='DeviceSecret123!'
        )

    def test_register_device_success(self):
        self.assertIsNotNone(self.collar)
        self.assertEqual(SmartCollarDeviceStatus.objects.count(), 1)
        self.assertIn('PROV-', self.prov_key)

    def test_pair_collar_success(self):
        pair_url = reverse('collar-pair')
        pair_data = {
            'collar_id': str(self.collar.id),
            'pet_id': str(self.pet.id),
            'pairing_method': 'BLE'
        }
        response = self.client.post(pair_url, pair_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])

        self.collar.refresh_from_db()
        self.assertEqual(self.collar.current_pet, self.pet)

    def test_telemetry_ingestion_success(self):
        SmartCollarService.pair_collar(self.user, self.collar, self.pet)

        telemetry_url = reverse('collar-telemetry', kwargs={'pk': self.collar.id})
        telemetry_payload = {
            'latitude': 40.7128,
            'longitude': -74.0060,
            'heart_rate_bpm': 78,
            'respiratory_rate': 22,
            'temperature_fahrenheit': 101.4,
            'battery_percentage': 95,
            'rssi_dbm': -62,
            'device_secret': 'DeviceSecret123!'
        }
        response = self.client.post(telemetry_url, telemetry_payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])

        self.collar.refresh_from_db()
        self.assertEqual(self.collar.current_heart_rate, 78)

    def test_telemetry_rejected_for_unpaired_device(self):
        telemetry_url = reverse('collar-telemetry', kwargs={'pk': self.collar.id})
        telemetry_payload = {
            'latitude': 40.7128,
            'longitude': -74.0060,
            'heart_rate_bpm': 78,
            'temperature_fahrenheit': 101.4,
            'battery_percentage': 95,
            'rssi_dbm': -62,
            'device_secret': 'DeviceSecret123!'
        }
        response = self.client.post(telemetry_url, telemetry_payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertFalse(response.data['success'])
