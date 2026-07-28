import 'dart:async';

/// Offline & Network Connectivity Monitor Service
class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();
  bool _isOnline = true;

  Stream<bool> get onConnectivityChanged => _controller.stream;
  bool get isOnline => _isOnline;

  void updateStatus(bool online) {
    if (_isOnline != online) {
      _isOnline = online;
      _controller.add(_isOnline);
    }
  }

  void dispose() {
    _controller.close();
  }
}
