import 'dart:async';
import '../observability/app_logger.dart';

class PendingTransaction {
  final String id;
  final String endpoint;
  final String method;
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  PendingTransaction({
    required this.id,
    required this.endpoint,
    required this.method,
    required this.payload,
    required this.timestamp,
  });
}

/// Offline-First Pending Synchronization Queue Service
class SyncQueueService {
  final List<PendingTransaction> _queue = [];

  List<PendingTransaction> get pendingTransactions => List.unmodifiable(_queue);

  void enqueueTransaction({
    required String endpoint,
    required String method,
    required Map<String, dynamic> payload,
  }) {
    final tx = PendingTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      endpoint: endpoint,
      method: method,
      payload: payload,
      timestamp: DateTime.now(),
    );
    _queue.add(tx);
    AppLogger.info('📦 Offline Transaction Enqueued: [$method] $endpoint (Queue size: ${_queue.length})');
  }

  Future<void> processQueue(Future<bool> Function(PendingTransaction tx) syncHandler) async {
    if (_queue.isEmpty) return;

    AppLogger.info('🔄 Draining Offline Sync Queue (${_queue.length} pending operations)...');
    final List<PendingTransaction> completed = [];

    for (final tx in _queue) {
      final success = await syncHandler(tx);
      if (success) {
        completed.add(tx);
      } else {
        AppLogger.warning('Failed to process offline tx ${tx.id}, keeping in queue.');
        break;
      }
    }

    _queue.removeWhere((tx) => completed.contains(tx));
    AppLogger.info('✅ Offline Sync Complete. Remaining in queue: ${_queue.length}');
  }
}
