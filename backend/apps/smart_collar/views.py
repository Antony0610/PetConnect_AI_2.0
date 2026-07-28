from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from drf_spectacular.utils import extend_schema

from .serializers import (
    SmartCollarDeviceStatusSerializer,
    DeviceRegistrationSerializer,
    DevicePairingSerializer,
    TelemetryIngestionSerializer,
    SmartCollarTelemetryHistorySerializer,
)
from .selectors import SmartCollarSelector
from .services import SmartCollarService
from apps.pets.selectors import PetSelector

class DeviceRegisterView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(request=DeviceRegistrationSerializer)
    def post(self, request, *args, **kwargs):
        serializer = DeviceRegistrationSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        collar, prov_key = SmartCollarService.register_device(
            device_id=serializer.validated_data['device_id'],
            mac_address=serializer.validated_data['mac_address'],
            secret_key=serializer.validated_data['secret_key'],
            firmware_version=serializer.validated_data.get('firmware_version', 'v1.0.0')
        )
        return Response({
            'success': True,
            'message': 'Smart Collar device registered in factory ledger.',
            'data': {
                'collar': SmartCollarDeviceStatusSerializer(collar).data,
                'provisioning_token': prov_key
            }
        }, status=status.HTTP_201_CREATED)


class DevicePairView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(request=DevicePairingSerializer)
    def post(self, request, *args, **kwargs):
        serializer = DevicePairingSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        collar = SmartCollarSelector.get_collar_by_id(serializer.validated_data['collar_id'])
        pet = PetSelector.get_pet_by_id(serializer.validated_data['pet_id'])

        if not collar or not pet:
            return Response({'success': False, 'message': 'Collar or Pet not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        try:
            history = SmartCollarService.pair_collar(
                user=request.user,
                collar=collar,
                pet=pet,
                method=serializer.validated_data.get('pairing_method', 'BLE')
            )
            return Response({
                'success': True,
                'message': 'Smart Collar paired with Pet successfully.',
                'data': SmartCollarDeviceStatusSerializer(collar).data
            })
        except ValueError as e:
            return Response({'success': False, 'message': str(e), 'errors': {'detail': str(e)}}, status=status.HTTP_400_BAD_REQUEST)


class DeviceUnpairView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        collar_id = request.data.get('collar_id')
        collar = SmartCollarSelector.get_collar_by_id(collar_id)
        if not collar:
            return Response({'success': False, 'message': 'Collar not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        SmartCollarService.unpair_collar(request.user, collar)
        return Response({'success': True, 'message': 'Smart Collar unpaired.', 'data': {}})


class CollarListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        collars = SmartCollarSelector.get_collars_for_user(request.user)
        serializer = SmartCollarDeviceStatusSerializer(collars, many=True)
        return Response({
            'success': True,
            'message': 'Smart Collars retrieved.',
            'data': serializer.data
        })


class CollarDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, pk, *args, **kwargs):
        collar = SmartCollarSelector.get_collar_by_id(pk)
        if not collar:
            return Response({'success': False, 'message': 'Collar not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        return Response({
            'success': True,
            'message': 'Collar details retrieved.',
            'data': SmartCollarDeviceStatusSerializer(collar).data
        })


class TelemetryIngestView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(request=TelemetryIngestionSerializer)
    def post(self, request, pk, *args, **kwargs):
        collar = SmartCollarSelector.get_collar_by_id(pk)
        if not collar:
            return Response({'success': False, 'message': 'Collar device not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        serializer = TelemetryIngestionSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        try:
            log = SmartCollarService.ingest_telemetry(collar, serializer.validated_data, request)
            return Response({
                'success': True,
                'message': 'Telemetry ingested successfully.',
                'data': {
                    'telemetry_id': str(log.id),
                    'is_online': True,
                    'timestamp': log.timestamp
                }
            })
        except ValueError as e:
            return Response({'success': False, 'message': str(e), 'errors': {'detail': str(e)}}, status=status.HTTP_403_FORBIDDEN)


class CollarLocationView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, pk, *args, **kwargs):
        collar = SmartCollarSelector.get_collar_by_id(pk)
        if not collar:
            return Response({'success': False, 'message': 'Collar not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        return Response({
            'success': True,
            'message': 'Live location retrieved.',
            'data': {
                'latitude': collar.current_latitude,
                'longitude': collar.current_longitude,
                'is_online': collar.is_online,
                'last_seen_at': collar.last_seen_at
            }
        })


class CollarHistoryView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, pk, *args, **kwargs):
        logs = SmartCollarSelector.get_telemetry_history(pk, limit=50)
        serializer = SmartCollarTelemetryHistorySerializer(logs, many=True)
        return Response({
            'success': True,
            'message': 'Telemetry logs retrieved.',
            'data': serializer.data
        })
