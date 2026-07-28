from django.urls import path
from .views import RAGAssistantChatView

urlpatterns = [
    path('chat/', RAGAssistantChatView.as_view(), name='ai-assistant-chat'),
]
