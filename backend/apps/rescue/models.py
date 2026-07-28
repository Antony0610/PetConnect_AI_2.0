import uuid
from django.db import models
from django.conf import settings
from apps.common.models import BaseModel
from apps.pets.models import Pet

class IncidentTypeChoices(models.TextChoices):
    LOST_PET = 'LOST_PET', 'Lost Pet Report'
    FOUND_PET = 'FOUND_PET', 'Found Pet Report'
    EMERGENCY_RESCUE = 'EMERGENCY_RESCUE', 'Emergency Medical Rescue'
    STRAY_ALERT = 'STRAY_ALERT', 'Stray Animal Alert'

class IncidentPriorityChoices(models.TextChoices):
    LOW = 'LOW', 'Low Priority'
    MEDIUM = 'MEDIUM', 'Medium Priority'
    HIGH = 'HIGH', 'High Priority'
    CRITICAL = 'CRITICAL', 'Critical SOS'

class IncidentStatusChoices(models.TextChoices):
    REPORTED = 'REPORTED', 'Reported'
    DISPATCHED = 'DISPATCHED', 'Volunteer Dispatched'
    IN_PROGRESS = 'IN_PROGRESS', 'Rescue In Progress'
    PET_RECOVERED = 'PET_RECOVERED', 'Pet Recovered'
    RESOLVED = 'RESOLVED', 'Resolved & Closed'
    CANCELLED = 'CANCELLED', 'Cancelled'

class PostTypeChoices(models.TextChoices):
    LOST_FOUND = 'LOST_FOUND', 'Lost & Found'
    ADOPTION = 'ADOPTION', 'Pet Adoption'
    SUCCESS_STORY = 'SUCCESS_STORY', 'Rescue Success Story'
    COMMUNITY_EVENT = 'COMMUNITY_EVENT', 'Community Event'
    GENERAL = 'GENERAL', 'General Discussion'


class VolunteerProfile(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='volunteer_profile')
    is_available = models.BooleanField(default=True, db_index=True)

    current_latitude = models.FloatField(default=0.0)
    current_longitude = models.FloatField(default=0.0)
    rescue_radius_km = models.FloatField(default=15.0)
    skills = models.JSONField(default=list, blank=True)

    is_verified_volunteer = models.BooleanField(default=True, db_index=True)
    active_rescue_count = models.IntegerField(default=0)
    rating_score = models.FloatField(default=4.9)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Volunteer {self.user.email} (Active: {self.active_rescue_count})"


class RescueIncident(BaseModel):
    reporter = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='reported_incidents')
    pet = models.ForeignKey(Pet, on_delete=models.SET_NULL, null=True, blank=True, related_name='rescue_incidents')
    assigned_volunteer = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, related_name='assigned_rescues')

    incident_type = models.CharField(max_length=30, choices=IncidentTypeChoices.choices, default=IncidentTypeChoices.LOST_PET, db_index=True)
    priority = models.CharField(max_length=20, choices=IncidentPriorityChoices.choices, default=IncidentPriorityChoices.HIGH, db_index=True)
    title = models.CharField(max_length=200, db_index=True)
    description = models.TextField()

    latitude = models.FloatField()
    longitude = models.FloatField()
    address_location = models.CharField(max_length=255, blank=True, default='')

    evidence_image_url = models.URLField(max_length=500, blank=True, null=True)
    status = models.CharField(max_length=30, choices=IncidentStatusChoices.choices, default=IncidentStatusChoices.REPORTED, db_index=True)
    resolved_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['incident_type', 'status', 'is_deleted']),
            models.Index(fields=['latitude', 'longitude']),
        ]

    def __str__(self):
        return f"{self.title} [{self.status}]"


class RescueTimelineEvent(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    incident = models.ForeignKey(RescueIncident, on_delete=models.CASCADE, related_name='timeline_events')
    actor = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True)
    status_update = models.CharField(max_length=50)
    notes = models.TextField(blank=True, default='')
    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        ordering = ['timestamp']


class CommunityPost(BaseModel):
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='community_posts')
    post_type = models.CharField(max_length=30, choices=PostTypeChoices.choices, default=PostTypeChoices.GENERAL, db_index=True)
    title = models.CharField(max_length=200, db_index=True)
    body = models.TextField()
    media_url = models.URLField(max_length=500, blank=True, null=True)

    likes_count = models.IntegerField(default=0)
    comments_count = models.IntegerField(default=0)
    flags_count = models.IntegerField(default=0, db_index=True)
    is_flagged = models.BooleanField(default=False, db_index=True) # Auto-hidden if flags_count >= 3

    class Meta:
        ordering = ['-created_at']


class CommunityComment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    post = models.ForeignKey(CommunityPost, on_delete=models.CASCADE, related_name='comments')
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        ordering = ['created_at']
