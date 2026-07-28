import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Structured App Logger for PetConnect AI Ecosystem
class AppLogger {
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (AppConfig.instance.enableVerboseLogging) {
      debugPrint('🐛 [DEBUG] $message');
      if (error != null) debugPrint('Error: $error');
    }
  }

  static void info(String message) {
    debugPrint('ℹ️ [INFO] $message');
  }

  static void warning(String message, [Object? error]) {
    debugPrint('⚠️ [WARNING] $message');
    if (error != null) debugPrint('Warning Details: $error');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('❌ [ERROR] $message');
    if (error != null) debugPrint('Error details: $error');
    if (stackTrace != null) debugPrint(stackTrace.toString());
  }
}
