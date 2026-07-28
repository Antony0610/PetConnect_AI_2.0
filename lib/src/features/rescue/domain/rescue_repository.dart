import 'rescue_incident_entity.dart';

abstract class RescueRepository {
  Future<List<RescueIncidentEntity>> getActiveIncidents();
  Future<void> acceptMission(String incidentId, String volunteerUid);
}
