from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema, OpenApiParameter

from .serializers import (
    RescueIncidentSerializer,
    VolunteerProfileSerializer,
    CommunityPostSerializer,
)
from .selectors import RescueSelector
from .services import RescueService

class ReportLostPetView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        pet_id = request.data.get('pet_id')
        lat = float(request.data.get('latitude', 0.0))
        lon = float(request.data.get('longitude', 0.0))
        desc = request.data.get('description', 'Lost pet report.')
        evidence_url = request.data.get('evidence_image_url')

        incident = RescueService.report_lost_pet(
            reporter=request.user, pet_id=pet_id, latitude=lat, longitude=lon,
            description=desc, evidence_image_url=evidence_url, request=request
        )
        return Response({
            'success': True,
            'message': 'Lost pet incident reported and dispatched to nearby volunteer squad.',
            'data': RescueIncidentSerializer(incident).data
        }, status=status.HTTP_201_CREATED)


class ReportFoundPetView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        title = request.data.get('title', 'Found Stray Animal')
        desc = request.data.get('description', 'Found pet details.')
        lat = float(request.data.get('latitude', 0.0))
        lon = float(request.data.get('longitude', 0.0))
        evidence_url = request.data.get('evidence_image_url')

        incident = RescueService.report_found_pet(
            reporter=request.user, title=title, description=desc, latitude=lat, longitude=lon,
            evidence_image_url=evidence_url, request=request
        )
        return Response({
            'success': True,
            'message': 'Found pet incident reported successfully.',
            'data': RescueIncidentSerializer(incident).data
        }, status=status.HTTP_201_CREATED)


class RequestEmergencyRescueView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        title = request.data.get('title', 'CRITICAL SOS RESCUE')
        desc = request.data.get('description', 'Emergency rescue needed immediately.')
        lat = float(request.data.get('latitude', 0.0))
        lon = float(request.data.get('longitude', 0.0))

        incident = RescueService.create_emergency_rescue(
            reporter=request.user, title=title, description=desc, latitude=lat, longitude=lon, request=request
        )
        return Response({
            'success': True,
            'message': 'Critical emergency SOS rescue request broadcasted.',
            'data': RescueIncidentSerializer(incident).data
        }, status=status.HTTP_201_CREATED)


class RescueIncidentListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        parameters=[
            OpenApiParameter(name='status', description='Filter by status', type=str),
            OpenApiParameter(name='incident_type', description='Filter by type', type=str),
        ],
        responses={200: RescueIncidentSerializer(many=True)}
    )
    def get(self, request, *args, **kwargs):
        status_filter = request.query_params.get('status')
        type_filter = request.query_params.get('incident_type')

        incidents = RescueSelector.get_incidents(status=status_filter, incident_type=type_filter)
        return Response({
            'success': True,
            'message': 'Rescue incidents retrieved.',
            'data': RescueIncidentSerializer(incidents, many=True).data
        })


class RescueIncidentDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, pk, *args, **kwargs):
        incident = RescueSelector.get_incident_by_id(pk)
        if not incident:
            return Response({'success': False, 'message': 'Incident not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        return Response({
            'success': True,
            'message': 'Incident details retrieved.',
            'data': RescueIncidentSerializer(incident).data
        })


class AcceptDispatchView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk, *args, **kwargs):
        incident = RescueSelector.get_incident_by_id(pk)
        if not incident:
            return Response({'success': False, 'message': 'Incident not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        updated_incident = RescueService.accept_dispatch(request.user, incident, request)
        return Response({
            'success': True,
            'message': 'Volunteer accepted rescue dispatch.',
            'data': RescueIncidentSerializer(updated_incident).data
        })


class DeclineDispatchView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk, *args, **kwargs):
        incident = RescueSelector.get_incident_by_id(pk)
        if not incident:
            return Response({'success': False, 'message': 'Incident not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        updated_incident = RescueService.decline_dispatch_reassign(request.user, incident, request)
        return Response({
            'success': True,
            'message': 'Dispatch declined. Reassigned to next available volunteer.',
            'data': RescueIncidentSerializer(updated_incident).data
        })


class NearbyVolunteersView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        lat = float(request.query_params.get('lat', 40.7128))
        lon = float(request.query_params.get('lon', -74.0060))
        radius = float(request.query_params.get('radius_km', 25.0))

        volunteers = RescueSelector.find_nearby_volunteers(lat, lon, radius)
        return Response({
            'success': True,
            'message': 'Nearby volunteers retrieved via spatial query.',
            'data': VolunteerProfileSerializer(volunteers, many=True).data
        })


class CommunityPostListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        post_type = request.query_params.get('post_type')
        posts = RescueSelector.get_community_posts(post_type)
        return Response({
            'success': True,
            'message': 'Community posts retrieved.',
            'data': CommunityPostSerializer(posts, many=True).data
        })

    def post(self, request, *args, **kwargs):
        post_type = request.data.get('post_type', 'GENERAL')
        title = request.data.get('title')
        body = request.data.get('body')
        media_url = request.data.get('media_url')

        post = RescueService.create_community_post(
            author=request.user, post_type=post_type, title=title, body=body, media_url=media_url, request=request
        )
        return Response({
            'success': True,
            'message': 'Community post created.',
            'data': CommunityPostSerializer(post).data
        }, status=status.HTTP_201_CREATED)


class FlagCommunityPostView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk, *args, **kwargs):
        post = CommunityPost.objects.filter(id=pk, is_deleted=False).first()
        if not post:
            return Response({'success': False, 'message': 'Post not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        updated_post = RescueService.flag_community_post(request.user, post, request)
        return Response({
            'success': True,
            'message': 'Post flagged for moderation.',
            'data': CommunityPostSerializer(updated_post).data
        })
