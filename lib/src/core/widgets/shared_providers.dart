import 'package:flutter_riverpod/flutter_riverpod.dart';

final unreadNotificationsCountProvider = StateProvider<int>((ref) => 3);

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // 'alert', 'reminder', 'system', 'rescue'
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationsNotifier() : super([]);

  void markAsRead(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          NotificationItem(
            id: item.id,
            title: item.title,
            message: item.message,
            timestamp: item.timestamp,
            type: item.type,
            isRead: true,
          )
        else
          item
    ];
  }

  void markAllAsRead() {
    state = [
      for (final item in state)
        NotificationItem(
          id: item.id,
          title: item.title,
          message: item.message,
          timestamp: item.timestamp,
          type: item.type,
          isRead: true,
        )
    ];
  }

  void removeNotification(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
  return NotificationsNotifier();
});
