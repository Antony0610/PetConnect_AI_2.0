import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiChatHistoryProvider = StateProvider<List<Map<String, String>>>((ref) {
  return [];
});
