import uuid
from django.db import models
from django.conf import settings
from apps.common.models import BaseModel
from apps.pets.models import Pet

class AiChatSession(BaseModel):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='ai_chat_sessions')
    pet = models.ForeignKey(Pet, on_delete=models.SET_NULL, null=True, blank=True, related_name='ai_chat_sessions')
    title = models.CharField(max_length=200, default='Pet Health Consultation')

    class Meta:
        ordering = ['-created_at']


class AiChatMessage(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    session = models.ForeignKey(AiChatSession, on_delete=models.CASCADE, related_name='messages')
    sender_role = models.CharField(max_length=20) # 'user' or 'assistant'
    content = models.TextField()

    medical_citations = models.JSONField(default=list, blank=True)
    provider_used = models.CharField(max_length=50, default='Gemini-Pro-Vision')
    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        ordering = ['timestamp']
