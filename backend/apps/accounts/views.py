from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenRefreshView as BaseTokenRefreshView
from drf_spectacular.utils import extend_schema

from .serializers import (
    UserSerializer,
    UserRegistrationSerializer,
    UserLoginSerializer,
    ProfileUpdateSerializer,
    PasswordResetRequestSerializer,
    PasswordResetConfirmSerializer,
    EmailVerificationRequestSerializer,
    EmailVerificationConfirmSerializer,
)
from .services import AuthService

class RegisterView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(request=UserRegistrationSerializer, responses={201: UserSerializer})
    def post(self, request, *args, **kwargs):
        serializer = UserRegistrationSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        user, tokens = AuthService.register_user(
            email=serializer.validated_data['email'],
            password=serializer.validated_data['password'],
            display_name=serializer.validated_data['display_name'],
            role=serializer.validated_data['role'],
        )
        AuthService.log_audit_event(user, 'REGISTER', request)

        return Response({
            'success': True,
            'message': 'User account created successfully.',
            'data': {
                'user': UserSerializer(user).data,
                'tokens': tokens,
            }
        }, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(request=UserLoginSerializer)
    def post(self, request, *args, **kwargs):
        serializer = UserLoginSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user, tokens = AuthService.authenticate_user(
                email=serializer.validated_data['email'],
                password=serializer.validated_data['password'],
            )
            AuthService.log_audit_event(user, 'LOGIN', request)
            return Response({
                'success': True,
                'message': 'Login successful.',
                'data': {
                    'user': UserSerializer(user).data,
                    'tokens': tokens,
                }
            })
        except ValueError as e:
            return Response({'success': False, 'message': str(e), 'errors': {'detail': str(e)}}, status=status.HTTP_401_UNAUTHORIZED)


class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        refresh_token = request.data.get('refresh')
        if refresh_token:
            try:
                token = RefreshToken(refresh_token)
                token.blacklist()
            except Exception:
                pass
        AuthService.log_audit_event(request.user, 'LOGOUT', request)
        return Response({'success': True, 'message': 'Successfully logged out.', 'data': {}})


class CustomTokenRefreshView(BaseTokenRefreshView):
    def post(self, request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)
        if response.status_code == 200:
            return Response({
                'success': True,
                'message': 'Token refreshed successfully.',
                'data': response.data
            })
        return Response({
            'success': False,
            'message': 'Token refresh failed.',
            'errors': response.data
        }, status=response.status_code)


class PasswordResetRequestView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(request=PasswordResetRequestSerializer)
    def post(self, request, *args, **kwargs):
        serializer = PasswordResetRequestSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        token = AuthService.request_password_reset(serializer.validated_data['email'])
        return Response({
            'success': True,
            'message': 'Password reset token generated.',
            'data': {'reset_token': token}
        })


class PasswordResetConfirmView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(request=PasswordResetConfirmSerializer)
    def post(self, request, *args, **kwargs):
        serializer = PasswordResetConfirmSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        try:
            AuthService.confirm_password_reset(
                token_str=serializer.validated_data['token'],
                new_password=serializer.validated_data['new_password']
            )
            return Response({'success': True, 'message': 'Password reset successfully.', 'data': {}})
        except ValueError as e:
            return Response({'success': False, 'message': str(e), 'errors': {'detail': str(e)}}, status=status.HTTP_400_BAD_REQUEST)


class EmailVerificationRequestView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(request=EmailVerificationRequestSerializer)
    def post(self, request, *args, **kwargs):
        serializer = EmailVerificationRequestSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        token = AuthService.request_email_verification(serializer.validated_data['email'])
        return Response({
            'success': True,
            'message': 'Email verification token sent.',
            'data': {'verification_token': token}
        })


class EmailVerificationConfirmView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(request=EmailVerificationConfirmSerializer)
    def post(self, request, *args, **kwargs):
        serializer = EmailVerificationConfirmSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        try:
            AuthService.confirm_email_verification(serializer.validated_data['token'])
            return Response({'success': True, 'message': 'Email verified successfully.', 'data': {}})
        except ValueError as e:
            return Response({'success': False, 'message': str(e), 'errors': {'detail': str(e)}}, status=status.HTTP_400_BAD_REQUEST)


class UserProfileMeView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        serializer = UserSerializer(request.user)
        return Response({
            'success': True,
            'message': 'Profile retrieved.',
            'data': serializer.data
        })


class UserProfileUpdateView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(request=ProfileUpdateSerializer, responses={200: UserSerializer})
    def patch(self, request, *args, **kwargs):
        serializer = ProfileUpdateSerializer(request.user, data=request.data, partial=True)
        if not serializer.is_valid():
            return Response({'success': False, 'message': 'Validation failed.', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        user = serializer.save()
        AuthService.log_audit_event(user, 'PROFILE_UPDATE', request)
        return Response({
            'success': True,
            'message': 'Profile updated successfully.',
            'data': UserSerializer(user).data
        })
