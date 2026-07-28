from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from apps.accounts.models import User
from apps.admin_dashboard.models import AdminActionLog

class AdminDashboardAPITests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.admin = User.objects.create_user(
            username='adminuser',
            email='admin@petconnect.ai',
            password='Password123!',
            role='admin'
        )
        self.regular_user = User.objects.create_user(
            username='regularuser',
            email='regular@petconnect.ai',
            password='Password123!',
            role='pet_owner'
        )

        self.telemetry_url = reverse('admin-telemetry')
        self.users_url = reverse('admin-users-list')

    def test_admin_telemetry_access_success(self):
        self.client.force_authenticate(user=self.admin)
        response = self.client.get(self.telemetry_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertIn('users', response.data['data'])

    def test_admin_telemetry_access_denied_for_pet_owner(self):
        self.client.force_authenticate(user=self.regular_user)
        response = self.client.get(self.telemetry_url)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_admin_update_user_role(self):
        self.client.force_authenticate(user=self.admin)
        update_url = reverse('admin-users-detail', kwargs={'pk': self.regular_user.id})
        payload = {'role': 'vet', 'is_verified': True}

        response = self.client.patch(update_url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])

        self.regular_user.refresh_from_db()
        self.assertEqual(self.regular_user.role, 'vet')
        self.assertTrue(self.regular_user.is_verified)
        self.assertEqual(AdminActionLog.objects.count(), 1)
