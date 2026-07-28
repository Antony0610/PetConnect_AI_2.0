from abc import ABC, abstractmethod
from typing import Dict, Any, List

class BaseAiProvider(ABC):
    @abstractmethod
    def analyze_vision(self, scan_mode: str, image_url: str) -> Dict[str, Any]:
        pass

    @abstractmethod
    def chat_assistant(self, message: str, context: str = "") -> Dict[str, Any]:
        pass


class BaseEmailProvider(ABC):
    @abstractmethod
    def send_email(self, to_email: str, subject: str, body_text: str, body_html: str = "") -> bool:
        pass


class BaseNotificationProvider(ABC):
    @abstractmethod
    def send_push(self, user_id: str, title: str, body: str, data: Dict[str, Any] = None) -> bool:
        pass


class BaseStorageProvider(ABC):
    @abstractmethod
    def generate_signed_url(self, file_path: str, expiration_seconds: int = 3600) -> str:
        pass

    @abstractmethod
    def upload_file(self, file_path: str, file_bytes: bytes, content_type: str = "application/octet-stream") -> str:
        pass


class BaseSmsProvider(ABC):
    @abstractmethod
    def send_sms(self, phone_number: str, message: str) -> bool:
        pass


class BaseMqttProvider(ABC):
    @abstractmethod
    def publish_telemetry(self, topic: str, payload: Dict[str, Any]) -> bool:
        pass
