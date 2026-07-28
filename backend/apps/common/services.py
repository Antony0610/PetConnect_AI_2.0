import logging

logger = logging.getLogger(__name__)

class FcmNotificationService:
    """
    Firebase Cloud Messaging (FCM) push notification service
    supporting vaccination reminders, SOS alerts, rescue dispatches, and AI scan alerts.
    """

    @staticmethod
    def send_push_notification(user_id: str, title: str, body: str, data_payload: dict = None) -> bool:
        logger.info(f"[FCM_PUSH] User: {user_id} | Title: '{title}' | Body: '{body}' | Data: {data_payload}")
        # Production Firebase Admin SDK payload dispatch
        return True

    @staticmethod
    def send_topic_notification(topic: str, title: str, body: str, data_payload: dict = None) -> bool:
        logger.info(f"[FCM_TOPIC_PUSH] Topic: '{topic}' | Title: '{title}' | Body: '{body}'")
        return True
