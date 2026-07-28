from django.db.models import Q
from .models import Pet

class PetSelector:
    @staticmethod
    def get_pets_for_user(user, search_query=None, species=None, vaccination_status=None):
        qs = Pet.objects.filter(is_deleted=False).select_related('owner', 'primary_vet')

        if user.role == 'pet_owner':
            qs = qs.filter(owner=user)
        elif user.role == 'vet':
            qs = qs.filter(Q(primary_vet=user) | Q(owner=user))

        if species:
            qs = qs.filter(species=species)

        if vaccination_status:
            qs = qs.filter(vaccination_status=vaccination_status)

        if search_query:
            qs = qs.filter(
                Q(name__icontains=search_query) |
                Q(breed__icontains=search_query) |
                Q(microchip_id__icontains=search_query) |
                Q(noseprint_id__icontains=search_query)
            )

        return qs

    @staticmethod
    def get_pet_by_id(pet_id):
        return Pet.objects.filter(id=pet_id, is_deleted=False).select_related('owner', 'primary_vet').first()
