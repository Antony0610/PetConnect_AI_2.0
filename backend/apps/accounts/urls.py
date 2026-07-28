from django.urls import path
from .views import (
    RegisterView,
    LoginView,
    LogoutView,
    CustomTokenRefreshView,
    PasswordResetRequestView,
    PasswordResetConfirmView,
    EmailVerificationRequestView,
    EmailVerificationConfirmView,
    UserProfileMeView,
    UserProfileUpdateView,
)

urlpatterns = [
    path('register/', RegisterView.as_view(), name='auth-register'),
    path('login/', LoginView.as_view(), name='auth-login'),
    path('logout/', LogoutView.as_view(), name='auth-logout'),
    path('token/refresh/', CustomTokenRefreshView.as_view(), name='auth-token-refresh'),
    path('password-reset/request/', PasswordResetRequestView.as_view(), name='auth-password-reset-request'),
    path('password-reset/confirm/', PasswordResetConfirmView.as_view(), name='auth-password-reset-confirm'),
    path('email-verification/request/', EmailVerificationRequestView.as_view(), name='auth-email-verification-request'),
    path('email-verification/confirm/', EmailVerificationConfirmView.as_view(), name='auth-email-verification-confirm'),
    path('me/', UserProfileMeView.as_view(), name='auth-me'),
    path('profile/', UserProfileUpdateView.as_view(), name='auth-profile-update'),
]
