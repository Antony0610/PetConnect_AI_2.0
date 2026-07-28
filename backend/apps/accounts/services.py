import uuid
from datetime import datetime, timedelta
from django.db import transaction
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from .models import User, EmailVerificationToken, PasswordResetToken, AuthAuditLog

class AuthService:

    @staticmethod
    @transaction.atomic
    def register_user(email: str, password: str, display_name: str, role: str) -> tuple[User, dict]:
        username = email.split('@')[0] + '-' + str(uuid.uuid4())[:4]
        name_parts = display_name.split(' ', 1)
        first_name = name_parts[0]
        last_name = name_parts[1] if len(name_parts) > 1 else ''

        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
            role=role,
            is_verified=False
        )

        refresh = RefreshToken.for_user(user)
        tokens = {
            'access': str(refresh.access_token),
            'refresh': str(refresh),
        }
        return user, tokens

    @staticmethod
    def authenticate_user(email: str, password: str) -> tuple[User, dict]:
        user = authenticate(username=email, password=password)
        if not user or not user.is_active:
            raise ValueError("Invalid credentials or account is deactivated.")

        refresh = RefreshToken.for_user(user)
        tokens = {
            'access': str(refresh.access_token),
            'refresh': str(refresh),
        }
        return user, tokens

    @staticmethod
    def request_password_reset(email: str) -> str:
        try:
            user = User.objects.get(email__iexact=email)
            token_str = str(uuid.uuid4())
            PasswordResetToken.objects.create(
                user=user,
                token=token_str,
                expires_at=datetime.utcnow() + timedelta(hours=2)
            )
            return token_str
        except User.DoesNotExist:
            return ""

    @staticmethod
    @transaction.atomic
    def confirm_password_reset(token_str: str, new_password: str) -> bool:
        try:
            reset_token = PasswordResetToken.objects.get(token=token_str, is_used=False)
            if reset_token.expires_at.replace(tzinfo=None) < datetime.utcnow():
                raise ValueError("Password reset token has expired.")

            user = reset_token.user
            user.set_password(new_password)
            user.save()

            reset_token.is_used = True
            reset_token.save()
            return True
        except PasswordResetToken.DoesNotExist:
            raise ValueError("Invalid or expired password reset token.")

    @staticmethod
    def request_email_verification(email: str) -> str:
        try:
            user = User.objects.get(email__iexact=email)
            token_str = str(uuid.uuid4())
            EmailVerificationToken.objects.create(
                user=user,
                token=token_str,
                expires_at=datetime.utcnow() + timedelta(hours=24)
            )
            return token_str
        except User.DoesNotExist:
            return ""

    @staticmethod
    @transaction.atomic
    def confirm_email_verification(token_str: str) -> bool:
        try:
            verify_token = EmailVerificationToken.objects.get(token=token_str, is_used=False)
            user = verify_token.user
            user.is_verified = True
            user.save()

            verify_token.is_used = True
            verify_token.save()
            return True
        except EmailVerificationToken.DoesNotExist:
            raise ValueError("Invalid email verification token.")

    @staticmethod
    def log_audit_event(user: User, event_type: str, request) -> None:
        ip = request.META.get('REMOTE_ADDR', '')
        agent = request.META.get('HTTP_USER_AGENT', '')
        AuthAuditLog.objects.create(
            user=user if user and user.is_authenticated else None,
            event_type=event_type,
            ip_address=ip,
            user_agent=agent
        )
