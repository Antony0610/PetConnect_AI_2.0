from django.db import transaction
from .models import (
    RescueIncident,
    RescueTimelineEvent,
    VolunteerProfile,
    CommunityPost,
    CommunityComment,
    IncidentStatusChoices,
)
from .selectors import RescueSelector
from .events import EventBus
from apps.pets.models import Pet
from apps.accounts.models import AuthAuditLog

class RescueService:

    @staticmethod
    @transaction.atomic
    def report_lost_pet(reporter, pet_id: str, latitude: float, longitude: float, description: str, evidence_image_url=None, request=None) -> RescueIncident:
        pet = Pet.objects.filter(id=pet_id).first()
        incident = RescueIncident.objects.create(
            reporter=reporter,
            pet=pet,
            incident_type='LOST_PET',
            priority='HIGH',
            title=f"Lost Pet: {pet.name if pet else 'Pet'}",
            description=description,
            latitude=latitude,
            longitude=longitude,
            evidence_image_url=evidence_image_url,
            status=IncidentStatusChoices.REPORTED
        )
        RescueTimelineEvent.objects.create(
            incident=incident, actor=reporter, status_update='LOST_REPORTED', notes='Lost pet report filed.'
        )

        # Trigger Event Bus
        EventBus.dispatch('LOST_PET_REPORTED', {'incident_id': str(incident.id), 'pet_id': str(pet.id) if pet else None})

        # Auto-assign nearest available volunteer
        volunteers = RescueSelector.find_nearby_volunteers(latitude, longitude, radius_km=25.0)
        if volunteers:
            top_vol = volunteers[0]
            incident.assigned_volunteer = top_vol.user
            incident.status = IncidentStatusChoices.DISPATCHED
            incident.save()

            top_vol.active_rescue_count += 1
            top_vol.save()

            RescueTimelineEvent.objects.create(
                incident=incident, actor=top_vol.user, status_update='VOLUNTEER_ASSIGNED', notes=f"Dispatched to volunteer {top_vol.user.email}"
            )
            EventBus.dispatch('VOLUNTEER_ASSIGNED', {'incident_id': str(incident.id), 'volunteer_id': str(top_vol.user.id)})

        if request:
            AuthAuditLog.objects.create(
                user=reporter, event_type='LOST_PET_REPORTED', ip_address=request.META.get('REMOTE_ADDR', ''), user_agent=''
            )
        return incident

    @staticmethod
    @transaction.atomic
    def report_found_pet(reporter, title: str, description: str, latitude: float, longitude: float, evidence_image_url=None, request=None) -> RescueIncident:
        incident = RescueIncident.objects.create(
            reporter=reporter,
            incident_type='FOUND_PET',
            priority='MEDIUM',
            title=title,
            description=description,
            latitude=latitude,
            longitude=longitude,
            evidence_image_url=evidence_image_url,
            status=IncidentStatusChoices.REPORTED
        )
        RescueTimelineEvent.objects.create(
            incident=incident, actor=reporter, status_update='FOUND_REPORTED', notes='Found pet report filed.'
        )
        EventBus.dispatch('FOUND_PET_REPORTED', {'incident_id': str(incident.id), 'latitude': latitude, 'longitude': longitude})

        if request:
            AuthAuditLog.objects.create(
                user=reporter, event_type='FOUND_PET_REPORTED', ip_address=request.META.get('REMOTE_ADDR', ''), user_agent=''
            )
        return incident

    @staticmethod
    @transaction.atomic
    def create_emergency_rescue(reporter, title: str, description: str, latitude: float, longitude: float, request=None) -> RescueIncident:
        incident = RescueIncident.objects.create(
            reporter=reporter,
            incident_type='EMERGENCY_RESCUE',
            priority='CRITICAL',
            title=title,
            description=description,
            latitude=latitude,
            longitude=longitude,
            status=IncidentStatusChoices.REPORTED
        )
        RescueTimelineEvent.objects.create(
            incident=incident, actor=reporter, status_update='SOS_TRIGGERED', notes='Critical emergency SOS rescue requested.'
        )
        EventBus.dispatch('SOS_TRIGGERED', {'incident_id': str(incident.id), 'latitude': latitude, 'longitude': longitude})

        if request:
            AuthAuditLog.objects.create(
                user=reporter, event_type='SOS_TRIGGERED', ip_address=request.META.get('REMOTE_ADDR', ''), user_agent=''
            )
        return incident

    @staticmethod
    @transaction.atomic
    def accept_dispatch(volunteer_user, incident: RescueIncident, request=None) -> RescueIncident:
        incident.assigned_volunteer = volunteer_user
        incident.status = IncidentStatusChoices.IN_PROGRESS
        incident.save()

        RescueTimelineEvent.objects.create(
            incident=incident, actor=volunteer_user, status_update='VOLUNTEER_ACCEPTED', notes='Volunteer accepted rescue dispatch.'
        )
        EventBus.dispatch('VOLUNTEER_ACCEPTED', {'incident_id': str(incident.id), 'volunteer_id': str(volunteer_user.id)})
        return incident

    @staticmethod
    @transaction.atomic
    def decline_dispatch_reassign(volunteer_user, incident: RescueIncident, request=None) -> RescueIncident:
        RescueTimelineEvent.objects.create(
            incident=incident, actor=volunteer_user, status_update='VOLUNTEER_DECLINED', notes='Volunteer declined dispatch. Reassigning...'
        )
        EventBus.dispatch('VOLUNTEER_DECLINED', {'incident_id': str(incident.id), 'volunteer_id': str(volunteer_user.id)})

        # Reassign to next available volunteer
        volunteers = RescueSelector.find_nearby_volunteers(incident.latitude, incident.longitude, radius_km=25.0)
        next_vol = [v for v in volunteers if v.user != volunteer_user]

        if next_vol:
            new_vol = next_vol[0]
            incident.assigned_volunteer = new_vol.user
            incident.status = IncidentStatusChoices.DISPATCHED
            incident.save()

            RescueTimelineEvent.objects.create(
                incident=incident, actor=new_vol.user, status_update='VOLUNTEER_REASSIGNED', notes=f"Reassigned to volunteer {new_vol.user.email}"
            )
        else:
            incident.assigned_volunteer = None
            incident.status = IncidentStatusChoices.REPORTED
            incident.save()

        return incident

    @staticmethod
    @transaction.atomic
    def create_community_post(author, post_type: str, title: str, body: str, media_url=None, request=None) -> CommunityPost:
        post = CommunityPost.objects.create(
            author=author, post_type=post_type, title=title, body=body, media_url=media_url
        )
        EventBus.dispatch('COMMUNITY_POST_CREATED', {'post_id': str(post.id), 'author_id': str(author.id)})
        return post

    @staticmethod
    @transaction.atomic
    def flag_community_post(user, post: CommunityPost, request=None) -> CommunityPost:
        post.flags_count += 1
        if post.flags_count >= 3:
            post.is_flagged = True
            EventBus.dispatch('POST_FLAGGED', {'post_id': str(post.id), 'flags_count': post.flags_count})
        post.save()

        if request:
            AuthAuditLog.objects.create(
                user=user, event_type='COMMUNITY_POST_FLAGGED', ip_address=request.META.get('REMOTE_ADDR', ''), user_agent=''
            )
        return post
