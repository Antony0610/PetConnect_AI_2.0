import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/ai_repository.dart';
import '../../../core/widgets/glass_container.dart';

class InteractiveAIChatScreen extends StatefulWidget {
  const InteractiveAIChatScreen({super.key});

  @override
  State<InteractiveAIChatScreen> createState() => _InteractiveAIChatScreenState();
}

class _InteractiveAIChatScreenState extends State<InteractiveAIChatScreen> {
  final AIRepository _aiRepository = AIRepository();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  
  bool _isTyping = false;
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'Hello! I am your PetConnect AI Veterinary Assistant. How can I assist with Luna\'s health or nutrition today?'
    },
    {
      'sender': 'user',
      'text': 'What is Luna\'s optimal caloric intake based on her 8,420 steps today?'
    },
    {
      'sender': 'ai',
      'text': 'Based on Luna\'s weight (32 kg), age (3 yrs), and active expenditure of 8,420 steps today, her recommended caloric target is 1,280 kcal. Ensure 24% crude protein intake.'
    },
  ];

  final List<String> _suggestedPrompts = [
    'Canine diet recommendations',
    'Vaccination schedule check',
    'Heart rate telemetry analysis',
    'Tick & flea prevention tips',
  ];

  Future<void> _sendMessage(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': query});
      _isTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    final response = await _aiRepository.askAssistant(query);
    if (mounted) {
      setState(() {
        final responseText = response['response']?.toString() ?? 'Based on clinical guidelines, monitor hydration levels.';
        _messages.add({'sender': 'ai', 'text': responseText});
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.secondaryCyan, size: 24),
            SizedBox(width: 8),
            Text('AI Medical Assistant'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Clear Chat',
            onPressed: () {
              setState(() => _messages.clear());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: AppSpacing.paddingLg,
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondaryCyan),
                          ),
                          SizedBox(width: 10),
                          Text('AI Care Assistant is typing...', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                }

                final msg = _messages[index];
                final isAi = msg['sender'] == 'ai';
                return Align(
                  alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    child: GlassContainer(
                      padding: AppSpacing.paddingMd,
                      borderRadius: AppSpacing.radiusLg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isAi ? Icons.auto_awesome : Icons.person,
                                    size: 14,
                                    color: isAi ? AppColors.secondaryCyan : AppColors.primaryTeal,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isAi ? 'PetConnect RAG Model' : 'You',
                                    style: AppTypography.labelLarge(context).copyWith(
                                      color: isAi ? AppColors.secondaryCyan : AppColors.primaryTeal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 14, color: Colors.white54),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: msg['text']!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Message copied to clipboard')),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            msg['text']!,
                            style: AppTypography.bodyMedium(context).copyWith(
                              color: isAi ? null : Colors.white,
                              fontWeight: isAi ? FontWeight.normal : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _suggestedPrompts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    backgroundColor: Colors.white10,
                    label: Text(_suggestedPrompts[index], style: const TextStyle(fontSize: 12, color: AppColors.secondaryCyan)),
                    onPressed: () => _sendMessage(_suggestedPrompts[index]),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (val) => _sendMessage(val),
                    decoration: InputDecoration(
                      hintText: 'Ask AI medical assistant...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      fillColor: Colors.black26,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: AppColors.primaryTeal),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primaryTeal,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () {
                      if (_textController.text.trim().isNotEmpty) {
                        _sendMessage(_textController.text.trim());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
