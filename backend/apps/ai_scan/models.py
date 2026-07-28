import uuid
from django.db import models
from django.conf import settings
from apps.common.models import BaseModel
from apps.pets.models import Pet

class ScanModeChoices(models.TextChoices):
    SKIN = 'skin_disease', 'Skin Disease Detection'
    EYE = 'eye_disease', 'Eye Disease Detection'
    EAR = 'ear_infection', 'Ear Infection Detection'
    DENTAL = 'dental_disease', 'Dental Disease Detection'
    TICK = 'tick_detection', 'Tick Detection'
    WOUND = 'wound_detection', 'Wound Detection'
    BODY_CONDITION = 'body_condition', 'Body Condition Score'

class RiskLevelChoices(models.TextChoices):
    LOW = 'LOW', 'Low Risk'
    MEDIUM = 'MEDIUM', 'Medium Risk'
    HIGH = 'HIGH', 'High Risk'
    CRITICAL = 'CRITICAL', 'Critical Risk'


class AiModelRegistry(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    model_name = models.CharField(max_length=100, unique=True, db_index=True)
    model_type = models.CharField(max_length=50) # e.g., 'vision', 'rag', 'biometric', 'risk'
    version = models.CharField(max_length=20, default='v1.0.0')
    framework = models.CharField(max_length=50, default='ONNX') # e.g., 'YOLOv8', 'ONNX', 'PyTorch'
    weights_file_url = models.URLField(max_length=500, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.model_name} ({self.version} - {self.framework})"


class AiScanResult(BaseModel):
    pet = models.ForeignKey(Pet, on_delete=models.SET_NULL, null=True, blank=True, related_name='ai_scans')
    scan_mode = models.CharField(max_length=30, choices=ScanModeChoices.choices, default=ScanModeChoices.SKIN, db_index=True)
    image_url = models.URLField(max_length=500)
    annotated_image_url = models.URLField(max_length=500, blank=True, null=True)

    primary_diagnosis = models.CharField(max_length=200, db_index=True)
    confidence_score = models.FloatField(default=0.0)
    severity_level = models.CharField(max_length=20, choices=RiskLevelChoices.choices, default=RiskLevelChoices.LOW)
    diagnostic_summary = models.TextField()
    medical_disclaimer = models.TextField(default="AI diagnosis is for triage guidance only. Consult a licensed veterinarian.")

    bounding_boxes = models.JSONField(default=list, blank=True)
    processing_time_ms = models.IntegerField(default=120)

    class Meta:
        ordering = ['-created_at']


class AiHealthRiskAssessment(BaseModel):
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE, related_name='risk_assessments')
    overall_risk = models.CharField(max_length=20, choices=RiskLevelChoices.choices, default=RiskLevelChoices.LOW, db_index=True)
    overall_risk_score = models.FloatField(default=0.15)

    disease_risk_score = models.FloatField(default=0.10)
    obesity_risk_score = models.FloatField(default=0.20)
    activity_risk_score = models.FloatField(default=0.12)

    risk_factors = models.JSONField(default=list)
    recommendations = models.JSONField(default=list)

    class Meta:
        ordering = ['-created_at']


class AiInferenceLog(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    model = models.ForeignKey(AiModelRegistry, on_delete=models.SET_NULL, null=True, blank=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True)
    input_type = models.CharField(max_length=50)
    execution_time_ms = models.IntegerField()
    status = models.CharField(max_length=20, default='SUCCESS')
    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)


class AiModelAbTestConfig(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    test_name = models.CharField(max_length=100, unique=True)
    control_model = models.ForeignKey(AiModelRegistry, on_delete=models.CASCADE, related_name='control_ab_tests')
    candidate_model = models.ForeignKey(AiModelRegistry, on_delete=models.CASCADE, related_name='candidate_ab_tests')
    candidate_traffic_percentage = models.IntegerField(default=20) # 20% traffic routed to candidate
    is_shadow_mode = models.BooleanField(default=True) # Shadow inference mode
    is_active = models.BooleanField(default=True)

    accuracy_control = models.FloatField(default=0.92)
    accuracy_candidate = models.FloatField(default=0.95)
    latency_avg_ms_control = models.IntegerField(default=115)
    latency_avg_ms_candidate = models.IntegerField(default=85)

    created_at = models.DateTimeField(auto_now_add=True)

