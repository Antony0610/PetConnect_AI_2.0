import logging

logger = logging.getLogger(__name__)

class EventBus:
    """
    Internal Event Bus for dispatching asynchronous notifications,
    volunteer dispatches, audit logs, and spatial notifications.
    """

    @staticmethod
    def dispatch(event_type: str, payload: dict):
        logger.info(f"[EVENT_BUS] Event Dispatched: {event_type} | Payload: {payload}")

        if event_type == 'LOST_PET_REPORTED':
            EventBus._handle_lost_pet(payload)
        elif event_type == 'FOUND_PET_REPORTED':
            EventBus._handle_found_pet(payload)
        elif event_type == 'SOS_TRIGGERED':
            EventBus._handle_sos_triggered(payload)
        elif event_type == 'VOLUNTEER_ASSIGNED':
            EventBus._handle_volunteer_assigned(payload)
        elif event_type == 'POST_FLAGGED':
            EventBus._handle_post_flagged(payload)

    @staticmethod
    def _handle_lost_pet(payload):
        logger.info(f"Triggering AI Noseprint & Microchip match for Lost Pet {payload.get('pet_id')}")

    @staticmethod
    def _handle_found_pet(payload):
        logger.info(f"Broadcasting Found Pet Alert in area: {payload.get('latitude')}, {payload.get('longitude')}")

    @staticmethod
    def _handle_sos_triggered(payload):
        logger.warning(f"CRITICAL SOS TRIGGERED: Incident {payload.get('incident_id')}")

    @staticmethod
    def _handle_volunteer_assigned(payload):
        logger.info(f"Volunteer {payload.get('volunteer_id')} assigned to Incident {payload.get('incident_id')}")

    @staticmethod
    def _handle_post_flagged(payload):
        logger.info(f"Post {payload.get('post_id')} auto-hidden due to abuse flags count ({payload.get('flags_count')})")
