from rest_framework import serializers
from .models import Pet, PetSpecies, PetGender, VaccinationStatus

class PetSerializer(serializers.ModelSerializer):
    owner_email = serializers.EmailField(source='owner.email', read_only=True)

    class Meta:
        model = Pet
        fields = [
            'id', 'owner', 'owner_email', 'primary_vet', 'name', 'species', 'breed',
            'gender', 'date_of_birth', 'weight_kg', 'color', 'noseprint_id',
            'microchip_id', 'adoption_status', 'vaccination_status', 'is_sterilized',
            'blood_group', 'allergies', 'medical_notes', 'emergency_contact',
            'profile_photo_url', 'qr_code_id', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'owner', 'created_at', 'updated_at']

    def validate_microchip_id(self, value):
        if value:
            query = Pet.objects.filter(microchip_id__iexact=value, is_deleted=False)
            if self.instance:
                query = query.exclude(id=self.instance.id)
            if query.exists():
                raise serializers.ValidationError("A pet with this microchip ID already exists.")
        return value

    def validate_noseprint_id(self, value):
        if value:
            query = Pet.objects.filter(noseprint_id__iexact=value, is_deleted=False)
            if self.instance:
                query = query.exclude(id=self.instance.id)
            if query.exists():
                raise serializers.ValidationError("A pet with this noseprint biometric ID already exists.")
        return value

    def validate_weight_kg(self, value):
        if value < 0 or value > 300:
            raise serializers.ValidationError("Weight must be a realistic positive value (0 to 300 kg).")
        return value
