from rest_framework.permissions import BasePermission

class AuthenticatedPermission(BasePermission):
    """Allows access only to authenticated users."""
    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated)

class PetOwnerPermission(BasePermission):
    """Allows access only to Pet Owner role users."""
    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated and request.user.role == 'pet_owner')

class VeterinarianPermission(BasePermission):
    """Allows access only to Veterinarian role users."""
    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated and request.user.role == 'vet')

class VolunteerPermission(BasePermission):
    """Allows access only to Volunteer / Rescue Worker role users."""
    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated and request.user.role == 'volunteer')

class AdministratorPermission(BasePermission):
    """Allows access only to Administrator role users."""
    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated and (request.user.role == 'admin' or request.user.is_superuser))
