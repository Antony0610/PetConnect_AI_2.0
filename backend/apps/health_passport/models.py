import uuid
from django.db import models
from django.conf import settings
from apps.common.models import BaseModel
from apps.pets.models import Pet

class RecordType(models.TextChoices):
    VACCINATION = 'vaccination', 'Vaccination Record'
    MEDICAL_HISTORY = 'medical_history', 'Medical History'
    DIAGNOSIS = 'diagnosis', 'Diagnosis'
    TREATMENT = 'treatment', 'Treatment'
    PRESCRIPTION = 'prescription', 'Prescription'
    SURGERY = 'surgery', 'Surgery'
    ALLERGY = 'allergy', 'Allergy'
    LAB_REPORT = 'lab_report', 'Lab Report'
    DEWORMING = 'deworming', 'Deworming'
    TICK_PREVENTION = 'tick_prevention', 'Tick & Flea Prevention'
    VET_NOTE = 'vet_note', 'Veterinarian Note'

class HealthPassportRecord(BaseModel):
    pet = models.ForeignKey(
        Pet,
        on_delete=models.CASCADE,
        related_name='health_records',
        db_index=True
    )
    veterinarian = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True, blank=True,
        related_name='signed_records'
    )
    title = models.CharField(max_length=200, db_index=True)
    type = models.CharField(max_length=30, choices=RecordType.choices, default=RecordType.VACCINATION, db_index=True)
    description = models.TextField(blank=True, default='')
    clinic_name = models.CharField(max_length=150, blank=True, default='')

    date_administered = models.DateField(db_index=True)
    date_expiration = models.DateField(null=True, blank=True)

    is_verified_ehr = models.BooleanField(default=True, db_index=True)
    document_url = models.URLField(max_length=500, blank=True, null=True)

    class Meta:
        ordering = ['-date_administered']
        indexes = [
            models.Index(fields=['pet', 'type', 'is_deleted']),
        ]

    def __str__(self):
        return f"{self.title} - {self.pet.name} ({self.get_type_display()})"
