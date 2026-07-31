import 'package:flutter_riverpod/flutter_riverpod.dart';

final smartCollarStateProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'is_connected': false,
    'device_name': 'No Smart Collar Connected',
    'battery_level': 0,
    'gps_status': 'Disconnected',
  };
});
