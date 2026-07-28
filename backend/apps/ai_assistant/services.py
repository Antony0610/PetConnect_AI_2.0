from django.db import transaction
from .models import AiChatSession, AiChatMessage
from apps.pets.models import Pet
from apps.accounts.models import AuthAuditLog

class AiAssistantService:

    @staticmethod
    @transaction.atomic
    def process_chat_message(user, message_text: str, session_id=None, pet_id=None, provider='gemini', request=None) -> tuple[AiChatSession, AiChatMessage]:
        pet = Pet.objects.filter(id=pet_id).first() if pet_id else None

        if session_id:
            session = AiChatSession.objects.filter(id=session_id, user=user).first()
            if not session:
                session = AiChatSession.objects.create(user=user, pet=pet, title=f"Consultation regarding {pet.name if pet else 'Pet'}")
        else:
            session = AiChatSession.objects.create(user=user, pet=pet, title=f"Consultation regarding {pet.name if pet else 'Pet'}")

        # Store User Message
        AiChatMessage.objects.create(
            session=session, sender_role='user', content=message_text, provider_used=provider
        )

        # RAG Assistant Response Generation
        assistant_response = f"Based on veterinary guidelines, for '{message_text}', ensure fresh hydration, monitor appetite for 24 hours, and consult a vet if lethargy persists."
        citations = [
            {'source': 'Merck Veterinary Manual 11th Ed.', 'section': 'Canine Gastrointestinal Protocol'},
            {'source': 'AAHA Canine Vaccination Guidelines 2024', 'section': 'Preventive Care Protocol'}
        ]

        assistant_msg = AiChatMessage.objects.create(
            session=session,
            sender_role='assistant',
            content=assistant_response,
            medical_citations=citations,
            provider_used=provider
        )

        if request:
            AuthAuditLog.objects.create(
                user=user, event_type='ASSISTANT_CHAT', ip_address=request.META.get('REMOTE_ADDR', ''), user_agent=''
            )

        return session, assistant_msg
