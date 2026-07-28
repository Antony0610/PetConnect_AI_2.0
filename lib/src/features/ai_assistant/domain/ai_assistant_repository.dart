import 'chat_message_entity.dart';

abstract class AiAssistantRepository {
  Future<ChatMessageEntity> sendMessage(String userQuery, String petId);
  Future<List<ChatMessageEntity>> getChatHistory(String petId);
}
