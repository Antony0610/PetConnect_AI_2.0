from django.db import transaction
from .models import Pet
from apps.accounts.models import AuthAuditLog

class PetService:
    @staticmethod
    @transaction.atomic
    def create_pet(owner, validated_data, request=None) -> Pet:
        pet = Pet.objects.create(owner=owner, **validated_data)
        if request:
            AuthAuditLog.objects.create(
                user=owner,
                event_type='PET_CREATED',
                ip_address=request.META.get('REMOTE_ADDR', ''),
                user_agent=request.META.get('HTTP_USER_AGENT', '')
            )
        return pet

    @staticmethod
    @transaction.atomic
    def update_pet(pet: Pet, validated_data, user, request=None) -> Pet:
        for key, value in validated_data.items():
            setattr(pet, key, value)
        pet.save()
        if request:
            AuthAuditLog.objects.create(
                user=user,
                event_type='PET_UPDATED',
                ip_address=request.META.get('REMOTE_ADDR', ''),
                user_agent=request.META.get('HTTP_USER_AGENT', '')
            )
        return pet

    @staticmethod
    @transaction.atomic
    def soft_delete_pet(pet: Pet, user, request=None) -> None:
        pet.is_deleted = True
        pet.is_active = False
        pet.save()
        if request:
            AuthAuditLog.objects.create(
                user=user,
                event_type='PET_DELETED',
                ip_address=request.META.get('REMOTE_ADDR', ''),
                user_agent=request.META.get('HTTP_USER_AGENT', '')
            )
