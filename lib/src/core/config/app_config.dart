enum AppEnvironment { dev, staging, prod }

/// Environment Configuration Singleton for PetConnect AI Ecosystem
class AppConfig {
  final AppEnvironment environment;
  final String apiBaseUrl;
  final String mqttBrokerUrl;
  final String firebaseAppId;
  final bool enableCertPinning;
  final bool enableVerboseLogging;

  static AppConfig? _instance;

  AppConfig._internal({
    required this.environment,
    required this.apiBaseUrl,
    required this.mqttBrokerUrl,
    required this.firebaseAppId,
    required this.enableCertPinning,
    required this.enableVerboseLogging,
  });

  static void initialize({required AppEnvironment environment}) {
    switch (environment) {
      case AppEnvironment.dev:
        _instance = AppConfig._internal(
          environment: AppEnvironment.dev,
          apiBaseUrl: 'https://dev-api.petconnect.ai',
          mqttBrokerUrl: 'mqtt://dev.collar.petconnect.ai',
          firebaseAppId: 'petconnect-dev',
          enableCertPinning: false,
          enableVerboseLogging: true,
        );
        break;
      case AppEnvironment.staging:
        _instance = AppConfig._internal(
          environment: AppEnvironment.staging,
          apiBaseUrl: 'https://staging-api.petconnect.ai',
          mqttBrokerUrl: 'mqtt://staging.collar.petconnect.ai',
          firebaseAppId: 'petconnect-staging',
          enableCertPinning: true,
          enableVerboseLogging: true,
        );
        break;
      case AppEnvironment.prod:
        _instance = AppConfig._internal(
          environment: AppEnvironment.prod,
          apiBaseUrl: 'https://api.petconnect.ai',
          mqttBrokerUrl: 'ssl://collar.petconnect.ai:8883',
          firebaseAppId: 'petconnect-prod',
          enableCertPinning: true,
          enableVerboseLogging: false,
        );
        break;
    }
  }

  static AppConfig get instance {
    if (_instance == null) {
      initialize(environment: AppEnvironment.dev);
    }
    return _instance!;
  }
}
