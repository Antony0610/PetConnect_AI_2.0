import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'app_drawer.dart';
import 'offline_error_widget.dart';
import 'shared_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'reminder':
        return Icons.event_available;
      case 'rescue':
        return Icons.emergency;
      case 'system':
      default:
        return Icons.notifications_active_outlined;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'alert':
        return AppColors.tertiaryCoral;
      case 'reminder':
        return AppColors.primaryTeal;
      case 'rescue':
        return AppColors.errorRed;
      case 'system':
      default:
        return AppColors.secondaryCyan;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Hub'),
        actions: [
          if (notifications.any((n) => !n.isRead))
            TextButton.icon(
              onPressed: () {
                notifier.markAllAsRead();
                ref.read(unreadNotificationsCountProvider.notifier).state = 0;
              },
              icon: const Icon(Icons.done_all, size: 18),
              label: const Text('Mark all read'),
            ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/notifications'),
      body: notifications.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.notifications_off_outlined,
              title: 'No Notifications',
              description: 'You\'re all caught up! New smart collar alerts, AI scan reports, and vet updates will appear here.',
            )
          : ListView.separated(
              padding: AppSpacing.paddingLg,
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = notifications[index];
                final color = _getNotificationColor(item.type);

                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: AppColors.errorRed,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    notifier.removeNotification(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification removed')),
                    );
                  },
                  child: Container(
                    color: item.isRead
                        ? Colors.transparent
                        : AppColors.primaryTeal.withOpacity(0.06),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.15),
                        child: Icon(_getNotificationIcon(item.type), color: color),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!item.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryTeal,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(item.message),
                          const SizedBox(height: 6),
                          Text(
                            _formatTime(item.timestamp),
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (!item.isRead) {
                          notifier.markAsRead(item.id);
                          final count = ref.read(unreadNotificationsCountProvider);
                          if (count > 0) {
                            ref.read(unreadNotificationsCountProvider.notifier).state = count - 1;
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }
}
