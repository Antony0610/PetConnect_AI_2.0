from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema

from .serializers import ChatRequestSerializer, AiChatMessageSerializer
from .services import AiAssistantService

class RAGAssistantChatView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(request=ChatRequestSerializer)
    def post(self, request, *args, **kwargs):
        serializer = ChatRequestSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        session, message = AiAssistantService.process_chat_message(
            user=request.user,
            message_text=serializer.validated_data['message'],
            session_id=serializer.validated_data.get('session_id'),
            pet_id=serializer.validated_data.get('pet_id'),
            provider=serializer.validated_data.get('provider', 'gemini'),
            request=request
        )
        return Response({
            'success': True,
            'message': 'RAG Assistant query answered.',
            'data': {
                'session_id': str(session.id),
                'session_title': session.title,
                'message': AiChatMessageSerializer(message).data
            }
        })
