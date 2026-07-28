from rest_framework import serializers
from .models import AiScanResult, AiHealthRiskAssessment, AiModelRegistry

class VisionAnalyzeSerializer(serializers.Serializer):
    scan_mode = serializers.ChoiceField(choices=[
        ('skin_disease', 'Skin Disease'),
        ('eye_disease', 'Eye Disease'),
        ('ear_infection', 'Ear Infection'),
        ('dental_disease', 'Dental Disease'),
        ('tick_detection', 'Tick Detection'),
        ('wound_detection', 'Wound Detection'),
        ('body_condition', 'Body Condition')
    ], default='skin_disease')
    image_url = serializers.URLField()
    pet_id = serializers.UUIDField(required=False, allow_null=True)


class PetIdentifySerializer(serializers.Serializer):
    method = serializers.ChoiceField(choices=['noseprint', 'face', 'microchip', 'qr'], default='noseprint')
    biometric_data = serializers.CharField()


class RiskAnalysisSerializer(serializers.Serializer):
    pet_id = serializers.UUIDField()


class RecommendationRequestSerializer(serializers.Serializer):
    pet_id = serializers.UUIDField()


class AiScanResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = AiScanResult
        fields = '__all__'


class AiHealthRiskAssessmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = AiHealthRiskAssessment
        fields = '__all__'
