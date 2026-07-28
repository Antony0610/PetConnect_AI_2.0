from rest_framework import serializers
from .models import (
    RescueIncident,
    RescueTimelineEvent,
    VolunteerProfile,
    CommunityPost,
    CommunityComment,
)

class RescueIncidentSerializer(serializers.ModelSerializer):
    reporter_email = serializers.EmailField(source='reporter.email', read_only=True)
    volunteer_email = serializers.EmailField(source='assigned_volunteer.email', read_only=True, allow_null=True)
    pet_name = serializers.CharField(source='pet.name', read_only=True, allow_null=True)

    class Meta:
        model = RescueIncident
        fields = [
            'id', 'reporter', 'reporter_email', 'pet', 'pet_name', 'assigned_volunteer',
            'volunteer_email', 'incident_type', 'priority', 'title', 'description',
            'latitude', 'longitude', 'address_location', 'evidence_image_url',
            'status', 'resolved_at', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'reporter', 'assigned_volunteer', 'resolved_at', 'created_at', 'updated_at']


class RescueTimelineEventSerializer(serializers.ModelSerializer):
    actor_email = serializers.EmailField(source='actor.email', read_only=True)

    class Meta:
        model = RescueTimelineEvent
        fields = '__all__'


class VolunteerProfileSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(source='user.email', read_only=True)
    display_name = serializers.CharField(source='user.get_full_name', read_only=True)

    class Meta:
        model = VolunteerProfile
        fields = '__all__'


class CommunityPostSerializer(serializers.ModelSerializer):
    author_name = serializers.CharField(source='author.get_full_name', read_only=True)

    class Meta:
        model = CommunityPost
        fields = [
            'id', 'author', 'author_name', 'post_type', 'title', 'body',
            'media_url', 'likes_count', 'comments_count', 'flags_count', 'is_flagged', 'created_at'
        ]
        read_only_fields = ['id', 'author', 'likes_count', 'comments_count', 'flags_count', 'is_flagged', 'created_at']


class CommunityCommentSerializer(serializers.ModelSerializer):
    author_name = serializers.CharField(source='author.get_full_name', read_only=True)

    class Meta:
        model = CommunityComment
        fields = '__all__'
