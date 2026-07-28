import '../domain/rescue_incident_entity.dart';
import '../domain/rescue_repository.dart';

class MockRescueRepository implements RescueRepository {
  final List<RescueIncidentEntity> _incidents = [
    RescueIncidentEntity(
      id: 'RS-9921',
      title: 'Injured Stray Dog Reported near Highway Exit 4',
      locationAddress: 'Central Park East Gate (0.8 km away)',
      latitude: 40.7128,
      longitude: -74.0060,
      priority: 'CRITICAL',
      reportedAt: DateTime.now().subtract(const Duration(minutes: 12)),
      status: 'Reported',
    ),
    RescueIncidentEntity(
      id: 'RS-9922',
      title: 'Lost Tabby Cat (Microchipped Match)',
      locationAddress: '5th Avenue Transit (1.4 km away)',
      latitude: 40.7140,
      longitude: -74.0080,
      priority: 'URGENT',
      reportedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      status: 'Dispatched',
    ),
  ];

  @override
  Future<List<RescueIncidentEntity>> getActiveIncidents() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _incidents;
  }

  @override
  Future<void> acceptMission(String incidentId, String volunteerUid) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
