from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema, OpenApiParameter

from .serializers import PetSerializer
from .selectors import PetSelector
from .services import PetService

class PetListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        parameters=[
            OpenApiParameter(name='q', description='Search by name, breed, microchip, noseprint', type=str),
            OpenApiParameter(name='species', description='Filter by species', type=str),
            OpenApiParameter(name='vaccination_status', description='Filter by vaccination status', type=str),
        ],
        responses={200: PetSerializer(many=True)}
    )
    def get(self, request, *args, **kwargs):
        search_query = request.query_params.get('q')
        species = request.query_params.get('species')
        vax_status = request.query_params.get('vaccination_status')

        pets = PetSelector.get_pets_for_user(
            user=request.user,
            search_query=search_query,
            species=species,
            vaccination_status=vax_status
        )
        serializer = PetSerializer(pets, many=True)
        return Response({
            'success': True,
            'message': 'Pets retrieved successfully.',
            'data': serializer.data
        })

    @extend_schema(request=PetSerializer, responses={201: PetSerializer})
    def post(self, request, *args, **kwargs):
        serializer = PetSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        pet = PetService.create_pet(
            owner=request.user,
            validated_data=serializer.validated_data,
            request=request
        )
        return Response({
            'success': True,
            'message': 'Pet created successfully.',
            'data': PetSerializer(pet).data
        }, status=status.HTTP_201_CREATED)


class PetDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, pk, *args, **kwargs):
        pet = PetSelector.get_pet_by_id(pk)
        if not pet:
            return Response({'success': False, 'message': 'Pet not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        return Response({
            'success': True,
            'message': 'Pet details retrieved.',
            'data': PetSerializer(pet).data
        })

    @extend_schema(request=PetSerializer, responses={200: PetSerializer})
    def patch(self, request, pk, *args, **kwargs):
        pet = PetSelector.get_pet_by_id(pk)
        if not pet:
            return Response({'success': False, 'message': 'Pet not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        serializer = PetSerializer(pet, data=request.data, partial=True)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        updated_pet = PetService.update_pet(pet, serializer.validated_data, request.user, request)
        return Response({
            'success': True,
            'message': 'Pet updated successfully.',
            'data': PetSerializer(updated_pet).data
        })

    def delete(self, request, pk, *args, **kwargs):
        pet = PetSelector.get_pet_by_id(pk)
        if not pet:
            return Response({'success': False, 'message': 'Pet not found.', 'errors': {'detail': 'Not found'}}, status=status.HTTP_404_NOT_FOUND)

        PetService.soft_delete_pet(pet, request.user, request)
        return Response({'success': True, 'message': 'Pet deleted successfully.', 'data': {}})
