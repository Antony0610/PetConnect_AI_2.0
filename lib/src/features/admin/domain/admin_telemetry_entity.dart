class AdminTelemetryEntity {
  final int totalActiveUsers;
  final int smartCollarsOnline;
  final int aiScansProcessed24h;
  final double systemUptimePercentage;

  const AdminTelemetryEntity({
    required this.totalActiveUsers,
    required this.smartCollarsOnline,
    required this.aiScansProcessed24h,
    required this.systemUptimePercentage,
  });
}
