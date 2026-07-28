import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/glass_container.dart';

class InteractiveAIChatScreen extends StatefulWidget {
  const InteractiveAIChatScreen({super.key});

  @override
  State<InteractiveAIChatScreen> createState() => _InteractiveAIChatScreenState();
}

class _InteractiveAIChatScreenState extends State<InteractiveAIChatScreen> {
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'Hello! I am your PetConnect AI Care Assistant. How can I assist with Luna\'s health or nutrition today?'
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

  final _textController = TextEditingController();

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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: AppSpacing.paddingLg,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isAi = msg['sender'] == 'ai';
                return Align(
                  alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    child: GlassContainer(
                      padding: AppSpacing.paddingMd,
                      borderRadius: AppSpacing.radiusLg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isAi)
                            Row(
                              children: [
                                const Icon(Icons.auto_awesome, size: 14, color: AppColors.secondaryCyan),
                                const SizedBox(width: 4),
                                Text('PetConnect RAG Model', style: AppTypography.labelLarge(context)),
                              ],
                            ),
                          if (isAi) const SizedBox(height: 4),
                          Text(
                            msg['text']!,
                            style: AppTypography.bodyMedium(context).copyWith(
                              color: isAi ? null : AppColors.primaryTeal,
                              fontWeight: isAi ? FontWeight.normal : FontWeight.bold,
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
          Padding(
            padding: AppSpacing.paddingLg,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Ask AI medical assistant...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(999)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
                AppSpacing.gapSm,
                CircleAvatar(
                  backgroundColor: AppColors.primaryTeal,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        setState(() {
                          _messages.add({'sender': 'user', 'text': _textController.text});
                          _textController.clear();
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
