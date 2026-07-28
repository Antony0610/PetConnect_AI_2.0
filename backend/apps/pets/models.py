import uuid
from django.db import models
from django.conf import settings
from apps.common.models import BaseModel

class PetSpecies(models.TextChoices):
    CANINE = 'canine', 'Canine (Dog)'
    FELINE = 'feline', 'Feline (Cat)'
    AVIAN = 'avian', 'Avian (Bird)'
    OTHER = 'other', 'Other'

class PetGender(models.TextChoices):
    MALE = 'male', 'Male'
    FEMALE = 'female', 'Female'

class VaccinationStatus(models.TextChoices):
    UP_TO_DATE = 'up_to_date', 'Up to Date'
    DUE_SOON = 'due_soon', 'Due Soon'
    OVERDUE = 'overdue', 'Overdue'
    UNKNOWN = 'unknown', 'Unknown'

class Pet(BaseModel):
    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='pets',
        db_index=True
    )
    primary_vet = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True, blank=True,
        related_name='assigned_patients',
        db_index=True
    )
    name = models.CharField(max_length=100, db_index=True)
    species = models.CharField(max_length=20, choices=PetSpecies.choices, default=PetSpecies.CANINE, db_index=True)
    breed = models.CharField(max_length=100, db_index=True)
    gender = models.CharField(max_length=10, choices=PetGender.choices, default=PetGender.MALE)
    date_of_birth = models.DateField(null=True, blank=True)
    weight_kg = models.DecimalField(max_digits=5, decimal_places=2, default=0.0)
    color = models.CharField(max_length=50, blank=True, default='')

    noseprint_id = models.CharField(max_length=100, unique=True, null=True, blank=True, db_index=True)
    microchip_id = models.CharField(max_length=100, unique=True, null=True, blank=True, db_index=True)

    adoption_status = models.CharField(max_length=50, default='Owned')
    vaccination_status = models.CharField(
        max_length=20,
        choices=VaccinationStatus.choices,
        default=VaccinationStatus.UP_TO_DATE,
        db_index=True
    )
    is_sterilized = models.BooleanField(default=True)
    blood_group = models.CharField(max_length=20, blank=True, default='')
    allergies = models.TextField(blank=True, default='')
    medical_notes = models.TextField(blank=True, default='')
    emergency_contact = models.CharField(max_length=100, blank=True, default='')

    profile_photo_url = models.URLField(max_length=500, blank=True, null=True)
    qr_code_id = models.CharField(max_length=100, unique=True, null=True, blank=True)

    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['owner', 'is_active', 'is_deleted']),
            models.Index(fields=['species', 'breed']),
        ]

    def __str__(self):
        return f"{self.name} ({self.get_species_display()} - {self.breed})"
