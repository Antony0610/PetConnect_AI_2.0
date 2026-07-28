from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from apps.accounts.models import User
from apps.pets.models import Pet
from apps.rescue.models import RescueIncident, VolunteerProfile, CommunityPost

class RescueCommunityAPITests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.reporter = User.objects.create_user(
            username='reporter',
            email='reporter@petconnect.ai',
            password='Password123!',
            role='pet_owner'
        )
        self.volunteer = User.objects.create_user(
            username='volunteer',
            email='volunteer@petconnect.ai',
            password='Password123!',
            role='volunteer'
        )
        VolunteerProfile.objects.create(
            user=self.volunteer,
            is_available=True,
            current_latitude=40.7128,
            current_longitude=-74.0060,
            rescue_radius_km=30.0
        )

        self.client.force_authenticate(user=self.reporter)

        self.pet = Pet.objects.create(
            owner=self.reporter,
            name='Luna',
            species='canine',
            breed='Golden Retriever'
        )

        self.report_lost_url = reverse('rescue-report-lost')
        self.report_found_url = reverse('rescue-report-found')
        self.emergency_url = reverse('rescue-emergency-request')
        self.volunteers_url = reverse('rescue-volunteers')
        self.posts_url = reverse('community-post-list-create')

    def test_report_lost_pet_and_auto_dispatch(self):
        payload = {
            'pet_id': str(self.pet.id),
            'latitude': 40.7128,
            'longitude': -74.0060,
            'description': 'Luna ran toward Central Park East Gate.'
        }
        response = self.client.post(self.report_lost_url, payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(response.data['success'])

        incident = RescueIncident.objects.first()
        self.assertIsNotNone(incident)
        self.assertEqual(incident.status, 'DISPATCHED')
        self.assertEqual(incident.assigned_volunteer, self.volunteer)

    def test_nearby_volunteers_spatial_query(self):
        response = self.client.get(f"{self.volunteers_url}?lat=40.7128&lon=-74.0060&radius_km=25")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertEqual(len(response.data['data']), 1)

    def test_community_post_creation_and_auto_moderation_flag(self):
        post_payload = {
            'post_type': 'ADOPTION',
            'title': 'Puppy Looking for Loving Family',
            'body': '3-month-old vaccinated retriever puppy up for adoption.'
        }
        create_resp = self.client.post(self.posts_url, post_payload, format='json')
        self.assertEqual(create_resp.status_code, status.HTTP_201_CREATED)

        post_id = create_resp.data['data']['id']
        flag_url = reverse('community-post-flag', kwargs={'pk': post_id})

        # Flag 3 times to trigger auto-hide moderation
        self.client.post(flag_url)
        self.client.post(flag_url)
        self.client.post(flag_url)

        post = CommunityPost.objects.get(id=post_id)
        self.assertEqual(post.flags_count, 3)
        self.assertTrue(post.is_flagged)
