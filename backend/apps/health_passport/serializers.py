from rest_framework import serializers
from .models import HealthPassportRecord, RecordType

class HealthPassportRecordSerializer(serializers.ModelSerializer):
    pet_name = serializers.CharField(source='pet.name', read_only=True)
    vet_name = serializers.CharField(source='veterinarian.get_full_name', read_only=True)

    class Meta:
        model = HealthPassportRecord
        fields = [
            'id', 'pet', 'pet_name', 'veterinarian', 'vet_name', 'title', 'type',
            'description', 'clinic_name', 'date_administered', 'date_expiration',
            'is_verified_ehr', 'document_url', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'is_verified_ehr', 'created_at', 'updated_at']
