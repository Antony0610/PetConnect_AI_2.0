import 'dart:async';
import '../observability/app_logger.dart';

/// Connectivity Monitoring Service for PetConnect AI Ecosystem
class ConnectivityService {
  bool _isOnline = true;
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();

  ConnectivityService() {
    // Initial state check
    _checkConnectivity();
  }

  bool get isOnline => _isOnline;
  Stream<bool> get onConnectivityChanged => _connectivityController.stream;

  void _checkConnectivity() {
    _isOnline = true;
    AppLogger.info('🌐 Connectivity Service initialized: Device is ONLINE');
  }

  void setOnlineStatus(bool status) {
    if (_isOnline != status) {
      _isOnline = status;
      _connectivityController.add(_isOnline);
      AppLogger.info(_isOnline ? '🟢 Device back ONLINE' : '🔴 Device OFFLINE - Sync Queue Active');
    }
  }

  void dispose() {
    _connectivityController.close();
  }
}
