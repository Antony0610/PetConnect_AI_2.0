from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from apps.accounts.models import User
from apps.pets.models import Pet

class PetsAPITests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username='testowner',
            email='owner@petconnect.ai',
            password='Password123!',
            role='pet_owner'
        )
        self.client.force_authenticate(user=self.user)
        self.list_create_url = reverse('pet-list-create')

        self.pet_data = {
            'name': 'Luna',
            'species': 'canine',
            'breed': 'Golden Retriever',
            'gender': 'female',
            'weight_kg': '31.50',
            'microchip_id': '985141002938102',
            'noseprint_id': 'NOSE-9921-X',
        }

    def test_create_pet_success(self):
        response = self.client.post(self.list_create_url, self.pet_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(response.data['success'])
        self.assertEqual(Pet.objects.count(), 1)
        self.assertEqual(Pet.objects.first().owner, self.user)

    def test_create_pet_duplicate_microchip(self):
        self.client.post(self.list_create_url, self.pet_data, format='json')
        duplicate_data = self.pet_data.copy()
        duplicate_data['name'] = 'Max'

        response = self.client.post(self.list_create_url, duplicate_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(response.data['success'])

    def test_list_pets_for_owner(self):
        self.client.post(self.list_create_url, self.pet_data, format='json')
        response = self.client.get(self.list_create_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['data']), 1)
