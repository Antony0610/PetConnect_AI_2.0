import os
import logging
from .base_providers import BaseStorageProvider

logger = logging.getLogger(__name__)

class AwsS3StorageProvider(BaseStorageProvider):
    def __init__(self, bucket_name: str = None):
        self.bucket_name = bucket_name or os.getenv('AWS_S3_BUCKET_NAME', 'petconnect-media-s3')

    def generate_signed_url(self, file_path: str, expiration_seconds: int = 3600) -> str:
        return f"https://s3.amazonaws.com/{self.bucket_name}/{file_path}?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Expires={expiration_seconds}"

    def upload_file(self, file_path: str, file_bytes: bytes, content_type: str = "application/octet-stream") -> str:
        logger.info(f"[AwsS3StorageProvider] Uploading {len(file_bytes)} bytes to s3://{self.bucket_name}/{file_path}")
        return f"https://s3.amazonaws.com/{self.bucket_name}/{file_path}"


class MinioStorageProvider(BaseStorageProvider):
    def __init__(self, bucket_name: str = None):
        self.bucket_name = bucket_name or os.getenv('MINIO_BUCKET_NAME', 'petconnect-minio')

    def generate_signed_url(self, file_path: str, expiration_seconds: int = 3600) -> str:
        return f"http://localhost:9000/{self.bucket_name}/{file_path}?signature=minio_temp_token"

    def upload_file(self, file_path: str, file_bytes: bytes, content_type: str = "application/octet-stream") -> str:
        logger.info(f"[MinioStorageProvider] Uploading {len(file_bytes)} bytes to minio://{self.bucket_name}/{file_path}")
        return f"http://localhost:9000/{self.bucket_name}/{file_path}"


class StorageProviderFactory:
    @staticmethod
    def get_provider(provider_type: str = None) -> BaseStorageProvider:
        p_type = (provider_type or os.getenv('STORAGE_PROVIDER', 's3')).lower()
        if p_type == 'minio':
            return MinioStorageProvider()
        else:
            return AwsS3StorageProvider()
