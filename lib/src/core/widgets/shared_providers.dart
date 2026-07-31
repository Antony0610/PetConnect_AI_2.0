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
  NotificationsNotifier()
      : super([
          NotificationItem(
            id: 'n1',
            title: 'Vaccination Due Soon',
            message: 'Luna\'s Rabies Booster is scheduled for next Tuesday.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            type: 'reminder',
            isRead: false,
          ),
          NotificationItem(
            id: 'n2',
            title: 'Geofence Exit Alert',
            message: 'Luna crossed the Home Safe Zone geofence 15 mins ago.',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            type: 'alert',
            isRead: false,
          ),
          NotificationItem(
            id: 'n3',
            title: 'AI Scan Diagnostic Ready',
            message: 'Your recent skin vision diagnostic scan report is processed.',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            type: 'system',
            isRead: false,
          ),
        ]);

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
