class RescueIncidentEntity {
  final String id;
  final String title;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final String priority; // 'CRITICAL', 'URGENT', 'ROUTINE'
  final DateTime reportedAt;
  final String status; // 'Reported', 'Dispatched', 'Resolved'

  const RescueIncidentEntity({
    required this.id,
    required this.title,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.priority,
    required this.reportedAt,
    required this.status,
  });
}
