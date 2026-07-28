import math
from .models import RescueIncident, VolunteerProfile, CommunityPost

class RescueSelector:
    @staticmethod
    def get_incidents(status=None, incident_type=None):
        qs = RescueIncident.objects.filter(is_deleted=False).select_related('reporter', 'pet', 'assigned_volunteer')
        if status:
            qs = qs.filter(status=status)
        if incident_type:
            qs = qs.filter(incident_type=incident_type)
        return qs

    @staticmethod
    def get_incident_by_id(incident_id):
        return RescueIncident.objects.filter(id=incident_id, is_deleted=False).select_related('reporter', 'pet', 'assigned_volunteer').first()

    @staticmethod
    def find_nearby_volunteers(latitude: float, longitude: float, radius_km: float = 25.0):
        available_volunteers = VolunteerProfile.objects.filter(is_available=True, is_verified_volunteer=True).select_related('user')
        nearby = []

        for vol in available_volunteers:
            dist = RescueSelector.haversine_km(latitude, longitude, vol.current_latitude, vol.current_longitude)
            if dist <= min(radius_km, vol.rescue_radius_km):
                nearby.append((vol, dist))

        # Sort by distance
        nearby.sort(key=lambda x: x[1])
        return [vol for vol, dist in nearby]

    @staticmethod
    def get_community_posts(post_type=None):
        qs = CommunityPost.objects.filter(is_deleted=False, is_flagged=False).select_related('author')
        if post_type:
            qs = qs.filter(post_type=post_type)
        return qs

    @staticmethod
    def haversine_km(lat1, lon1, lat2, lon2):
        R = 6371.0  # Earth radius in kilometers
        phi1 = math.radians(lat1)
        phi2 = math.radians(lat2)
        delta_phi = math.radians(lat2 - lat1)
        delta_lambda = math.radians(lon2 - lon1)
        a = math.sin(delta_phi / 2)**2 + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2)**2
        return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
