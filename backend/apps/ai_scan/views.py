from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema

from .serializers import (
    VisionAnalyzeSerializer,
    PetIdentifySerializer,
    RiskAnalysisSerializer,
    RecommendationRequestSerializer,
    AiScanResultSerializer,
    AiHealthRiskAssessmentSerializer,
)
from .services import AiService

class VisionAnalyzeView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(request=VisionAnalyzeSerializer, responses={200: AiScanResultSerializer})
    def post(self, request, *args, **kwargs):
        serializer = VisionAnalyzeSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        scan_result = AiService.process_vision_analysis(
            user=request.user,
            scan_mode=serializer.validated_data['scan_mode'],
            image_url=serializer.validated_data['image_url'],
            pet_id=serializer.validated_data.get('pet_id'),
            request=request
        )
        return Response({
            'success': True,
            'message': 'AI Vision analysis complete.',
            'data': AiScanResultSerializer(scan_result).data
        })


class PetIdentifyView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(request=PetIdentifySerializer)
    def post(self, request, *args, **kwargs):
        serializer = PetIdentifySerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        match_data = AiService.identify_pet(
            user=request.user,
            method=serializer.validated_data['method'],
            biometric_data=serializer.validated_data['biometric_data'],
            request=request
        )
        return Response({
            'success': True,
            'message': 'Biometric identification complete.',
            'data': match_data
        })


class HealthRiskAnalysisView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(request=RiskAnalysisSerializer, responses={200: AiHealthRiskAssessmentSerializer})
    def post(self, request, *args, **kwargs):
        serializer = RiskAnalysisSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        assessment = AiService.analyze_health_risk(
            user=request.user,
            pet_id=serializer.validated_data['pet_id'],
            request=request
        )
        return Response({
            'success': True,
            'message': 'Health risk assessment complete.',
            'data': AiHealthRiskAssessmentSerializer(assessment).data
        })


class RecommendationEngineView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(request=RecommendationRequestSerializer)
    def post(self, request, *args, **kwargs):
        serializer = RecommendationRequestSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        recs = AiService.generate_recommendations(
            user=request.user,
            pet_id=serializer.validated_data['pet_id'],
            request=request
        )
        return Response({
            'success': True,
            'message': 'AI Recommendations generated.',
            'data': recs
        })
