from rest_framework import serializers
from .models import AiChatSession, AiChatMessage

class AiChatMessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = AiChatMessage
        fields = '__all__'


class ChatRequestSerializer(serializers.Serializer):
    session_id = serializers.UUIDField(required=False, allow_null=True)
    pet_id = serializers.UUIDField(required=False, allow_null=True)
    message = serializers.CharField()
    provider = serializers.ChoiceField(choices=['gemini', 'openai', 'local_llm'], default='gemini')
