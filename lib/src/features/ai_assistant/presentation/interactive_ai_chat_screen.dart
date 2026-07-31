import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_drawer.dart';

class InteractiveAIChatScreen extends StatefulWidget {
  const InteractiveAIChatScreen({super.key});

  @override
  State<InteractiveAIChatScreen> createState() => _InteractiveAIChatScreenState();
}

class _InteractiveAIChatScreenState extends State<InteractiveAIChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  bool _isTyping = false;
  String _activeConversationTitle = 'Pet Health Consult';

  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'Hello! I am your PetConnect AI Clinical Assistant. I am ready to analyze your pet\'s health, collar telemetry, medical records, and diet. How can I assist with your pet\'s care today?'
    },
  ];

  final List<String> _suggestedPrompts = [
    'Calculate daily caloric intake target',
    'Check skin rash or allergy symptoms',
    'Vaccination booster schedule info',
    'First aid for insect sting',
    'Smart collar GPS geofence setup',
  ];

  final List<Map<String, String>> _conversations = [
    {'id': 'c1', 'title': 'Pet Health Consult', 'date': 'Today'},
    {'id': 'c2', 'title': 'Diet & Nutrition Plan', 'date': 'Yesterday'},
    {'id': 'c3', 'title': 'Post-Vaccine Monitoring', 'date': 'July 20'},
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage(String query) async {
    if (query.trim().isEmpty) return;

    final userMessage = query.trim();
    setState(() {
      _messages.add({'sender': 'user', 'text': userMessage});
      _isTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    String responseText;
    final lower = userMessage.toLowerCase();

    if (lower.contains('calor') || lower.contains('diet') || lower.contains('step')) {
      responseText = 'Based on your pet\'s registered breed profile and daily activity expenditure, the recommended daily caloric target will be dynamically calculated. Ensure balanced crude protein and fresh water access.';
    } else if (lower.contains('rash') || lower.contains('skin') || lower.contains('flea')) {
      responseText = 'Skin lesions or localized redness can indicate allergic dermatitis or flea bite hypersensitivity. Clean the area with mild antiseptic soap. If scratching continues over 24 hours, perform an AI Vision Scan.';
    } else if (lower.contains('vaccin') || lower.contains('booster')) {
      responseText = 'Your pet\'s DHPP and Rabies vaccinations can be registered and verified in the Health Passport. Check your active records for booster due dates.';
    } else if (lower.contains('sting') || lower.contains('first aid') || lower.contains('emergency')) {
      responseText = 'For insect or bee stings: 1) Safely scrape away any sting apparatus. 2) Apply a cold compress for 10 minutes. 3) Monitor for facial swelling or breathing distress. If lethargy occurs, tap Emergency SOS.';
    } else {
      responseText = 'I have logged this inquiry in your pet\'s care ledger. Based on veterinary guidelines for $userMessage, continue normal activity monitoring and consult your primary veterinarian if symptoms persist.';
    }

    setState(() {
      _messages.add({'sender': 'ai', 'text': responseText});
      _isTyping = false;
    });
    _scrollToBottom();
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

  void _openConversationHistory() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Conversation History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add_comment_outlined, color: AppColors.primaryTeal),
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _messages.clear();
                      _messages.add({
                        'sender': 'ai',
                        'text': 'Started new conversation session. How can I help you today?'
                      });
                    });
                  },
                ),
              ],
            ),
            AppSpacing.gapMd,
            ..._conversations.map((conv) {
              return ListTile(
                leading: const Icon(Icons.chat_bubble_outline, color: AppColors.primaryTeal),
                title: Text(conv['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(conv['date']!),
                trailing: PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'rename') {
                      Navigator.pop(ctx);
                      _showRenameModal(conv['id']!);
                    } else if (val == 'delete') {
                      Navigator.pop(ctx);
                      setState(() {
                        _conversations.removeWhere((c) => c['id'] == conv['id']);
                      });
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'rename', child: Text('Rename')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _activeConversationTitle = conv['title']!);
                },
              );
            }),
            AppSpacing.gapLg,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting full chat transcript as PDF...')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Export Chat Transcript'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameModal(String id) {
    final ctrl = TextEditingController(text: _activeConversationTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Conversation'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Conversation Title')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => _activeConversationTitle = ctrl.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.psychology, color: AppColors.primaryTeal, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI Clinical Assistant', style: TextStyle(fontSize: 16)),
                  Text(_activeConversationTitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Conversation History',
            onPressed: _openConversationHistory,
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/pet-owner/ai-chat'),
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
                        color: AppColors.primaryTeal.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryTeal),
                          ),
                          SizedBox(width: 10),
                          Text('PetConnect AI is formulating medical response...', style: TextStyle(fontSize: 12, color: AppColors.primaryTeal)),
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
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
                    child: Container(
                      padding: AppSpacing.paddingMd,
                      decoration: BoxDecoration(
                        color: isAi
                            ? (Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkSurfaceContainer
                                : Colors.grey.shade100)
                            : AppColors.primaryTeal,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isAi ? AppColors.primaryTeal.withOpacity(0.2) : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isAi ? Icons.psychology : Icons.person,
                                    size: 14,
                                    color: isAi ? AppColors.primaryTeal : Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isAi ? 'PetConnect AI' : 'You',
                                    style: TextStyle(
                                      color: isAi ? AppColors.primaryTeal : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 14, color: Colors.grey),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: msg['text']!));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Response copied to clipboard.')),
                                      );
                                    },
                                  ),
                                  if (isAi && index == _messages.length - 1) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.refresh, size: 14, color: Colors.grey),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        _sendMessage(_messages[_messages.length - 2]['text']!);
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            msg['text']!,
                            style: TextStyle(
                              color: isAi ? null : Colors.white,
                              fontSize: 14,
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
            height: 38,
            margin: const EdgeInsets.only(bottom: 4),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _suggestedPrompts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    backgroundColor: AppColors.primaryTeal.withOpacity(0.08),
                    side: const BorderSide(color: AppColors.primaryTeal, width: 0.8),
                    label: Text(_suggestedPrompts[index], style: const TextStyle(fontSize: 11, color: AppColors.primaryTeal, fontWeight: FontWeight.w600)),
                    onPressed: () => _sendMessage(_suggestedPrompts[index]),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryTeal),
                  tooltip: 'Attach Image Context',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Photo attached to AI context background.')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: AppColors.primaryTeal),
                  tooltip: 'Voice Command Input',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Listening... Speak your veterinary query.')),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (val) => _sendMessage(val),
                    decoration: const InputDecoration(
                      hintText: 'Ask AI veterinary assistant...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: AppColors.primaryTeal,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
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
