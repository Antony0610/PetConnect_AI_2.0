enum MessageSender { user, ai, vet }

class ChatMessageEntity {
  final String id;
  final MessageSender sender;
  final String text;
  final DateTime timestamp;
  final String? ragSourceCitation;

  const ChatMessageEntity({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.ragSourceCitation,
  });
}
