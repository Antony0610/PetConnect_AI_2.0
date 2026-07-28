from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema, OpenApiParameter

from .serializers import HealthPassportRecordSerializer
from .selectors import HealthPassportSelector
from .services import HealthPassportService

class HealthPassportListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        parameters=[
            OpenApiParameter(name='pet_id', description='Filter records by pet UUID', type=str),
            OpenApiParameter(name='type', description='Filter by record type', type=str),
        ],
        responses={200: HealthPassportRecordSerializer(many=True)}
    )
    def get(self, request, *args, **kwargs):
        pet_id = request.query_params.get('pet_id')
        record_type = request.query_params.get('type')

        records = HealthPassportSelector.get_records(pet_id=pet_id, record_type=record_type)
        serializer = HealthPassportRecordSerializer(records, many=True)
        return Response({
            'success': True,
            'message': 'Health passport records retrieved.',
            'data': serializer.data
        })

    @extend_schema(request=HealthPassportRecordSerializer, responses={201: HealthPassportRecordSerializer})
    def post(self, request, *args, **kwargs):
        serializer = HealthPassportRecordSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        record = HealthPassportService.create_record(
            user=request.user,
            validated_data=serializer.validated_data,
            request=request
        )
        return Response({
            'success': True,
            'message': 'Health passport record created successfully.',
            'data': HealthPassportRecordSerializer(record).data
        }, status=status.HTTP_201_CREATED)


class HealthPassportDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, pk, *args, **kwargs):
        record = HealthPassportSelector.get_record_by_id(pk)
        if not record:
            return Response({'success': False, 'message': 'Record not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        return Response({
            'success': True,
            'message': 'Health record details retrieved.',
            'data': HealthPassportRecordSerializer(record).data
        })

    @extend_schema(request=HealthPassportRecordSerializer, responses={200: HealthPassportRecordSerializer})
    def patch(self, request, pk, *args, **kwargs):
        record = HealthPassportSelector.get_record_by_id(pk)
        if not record:
            return Response({'success': False, 'message': 'Record not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        serializer = HealthPassportRecordSerializer(record, data=request.data, partial=True)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        updated_record = HealthPassportService.update_record(record, serializer.validated_data, request.user, request)
        return Response({
            'success': True,
            'message': 'Health record updated successfully.',
            'data': HealthPassportRecordSerializer(updated_record).data
        })

    def delete(self, request, pk, *args, **kwargs):
        record = HealthPassportSelector.get_record_by_id(pk)
        if not record:
            return Response({'success': False, 'message': 'Record not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        HealthPassportService.soft_delete_record(record, request.user, request)
        return Response({'success': True, 'message': 'Health record deleted successfully.', 'data': {}})
