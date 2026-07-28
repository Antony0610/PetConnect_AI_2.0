from .models import HealthPassportRecord

class HealthPassportSelector:
    @staticmethod
    def get_records(pet_id=None, record_type=None):
        qs = HealthPassportRecord.objects.filter(is_deleted=False).select_related('pet', 'veterinarian')
        if pet_id:
            qs = qs.filter(pet_id=pet_id)
        if record_type:
            qs = qs.filter(type=record_type)
        return qs

    @staticmethod
    def get_record_by_id(record_id):
        return HealthPassportRecord.objects.filter(id=record_id, is_deleted=False).select_related('pet', 'veterinarian').first()
