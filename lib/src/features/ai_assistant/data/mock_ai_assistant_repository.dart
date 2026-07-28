import '../domain/ai_assistant_repository.dart';
import '../domain/chat_message_entity.dart';

class MockAiAssistantRepository implements AiAssistantRepository {
  final List<ChatMessageEntity> _messages = [
    ChatMessageEntity(
      id: 'msg-1',
      sender: MessageSender.ai,
      text: 'Hello! I am your PetConnect AI Care Assistant. How can I assist with Luna\'s health or nutrition today?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  Future<List<ChatMessageEntity>> getChatHistory(String petId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _messages;
  }

  @override
  Future<ChatMessageEntity> sendMessage(String userQuery, String petId) async {
    final userMsg = ChatMessageEntity(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      sender: MessageSender.user,
      text: userQuery,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);

    await Future.delayed(const Duration(milliseconds: 700));

    final aiResponse = ChatMessageEntity(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch + 1}',
      sender: MessageSender.ai,
      text: 'Based on veterinary medical guidelines for Golden Retrievers, $userQuery requires maintaining 1,280 kcal/day and regular hydration.',
      timestamp: DateTime.now(),
      ragSourceCitation: 'AAHA Canine Nutrition Guidelines (2024)',
    );
    _messages.add(aiResponse);

    return aiResponse;
  }
}
