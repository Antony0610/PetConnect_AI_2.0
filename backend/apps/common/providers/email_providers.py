import os
import logging
from .base_providers import BaseEmailProvider

logger = logging.getLogger(__name__)

class SmtpEmailProvider(BaseEmailProvider):
    def send_email(self, to_email: str, subject: str, body_text: str, body_html: str = "") -> bool:
        logger.info(f"[SmtpEmailProvider] Sending SMTP email to: {to_email} | Subject: '{subject}'")
        return True


class SendGridEmailProvider(BaseEmailProvider):
    def __init__(self, api_key: str = None):
        self.api_key = api_key or os.getenv('SENDGRID_API_KEY', 'default_sg_key')

    def send_email(self, to_email: str, subject: str, body_text: str, body_html: str = "") -> bool:
        logger.info(f"[SendGridEmailProvider] Dispatching via SendGrid API to: {to_email} | Subject: '{subject}'")
        return True


class SesEmailProvider(BaseEmailProvider):
    def send_email(self, to_email: str, subject: str, body_text: str, body_html: str = "") -> bool:
        logger.info(f"[SesEmailProvider] Dispatching via AWS SES to: {to_email} | Subject: '{subject}'")
        return True


class EmailProviderFactory:
    @staticmethod
    def get_provider(provider_type: str = None) -> BaseEmailProvider:
        p_type = (provider_type or os.getenv('EMAIL_PROVIDER', 'smtp')).lower()
        if p_type == 'sendgrid':
            return SendGridEmailProvider()
        elif p_type == 'ses':
            return SesEmailProvider()
        else:
            return SmtpEmailProvider()
