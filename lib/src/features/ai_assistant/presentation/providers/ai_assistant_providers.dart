import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_ai_assistant_repository.dart';
import '../../domain/ai_assistant_repository.dart';
import '../../domain/chat_message_entity.dart';

final aiAssistantRepositoryProvider = Provider<AiAssistantRepository>((ref) {
  return MockAiAssistantRepository();
});

class AiChatNotifier extends StateNotifier<AsyncValue<List<ChatMessageEntity>>> {
  final AiAssistantRepository _repository;
  final String _petId;

  AiChatNotifier(this._repository, this._petId) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final messages = await _repository.getChatHistory(_petId);
      state = AsyncValue.data(messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendQuery(String text) async {
    try {
      await _repository.sendMessage(text, _petId);
      final messages = await _repository.getChatHistory(_petId);
      state = AsyncValue.data(List.from(messages));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final aiChatProvider = StateNotifierProvider.family<AiChatNotifier, AsyncValue<List<ChatMessageEntity>>, String>((ref, petId) {
  return AiChatNotifier(ref.watch(aiAssistantRepositoryProvider), petId);
});
