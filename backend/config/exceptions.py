import logging
from rest_framework.views import exception_handler
from rest_framework.response import Response
from rest_framework import status

logger = logging.getLogger(__name__)

def global_exception_handler(exc, context):
    """
    Global exception handler returning consistent JSON envelopes:
    Success: {"success": true, "message": "...", "data": {}}
    Failure: {"success": false, "message": "...", "errors": {}}
    """
    response = exception_handler(exc, context)

    if response is not None:
        customized_response = {
            'success': False,
            'message': 'An error occurred processing your request.',
            'errors': response.data
        }

        if response.status_code == status.HTTP_401_UNAUTHORIZED:
            customized_response['message'] = 'Authentication credentials were not provided or are invalid.'
        elif response.status_code == status.HTTP_403_FORBIDDEN:
            customized_response['message'] = 'You do not have permission to perform this action.'
        elif response.status_code == status.HTTP_404_NOT_FOUND:
            customized_response['message'] = 'The requested resource was not found.'
        elif response.status_code == status.HTTP_400_BAD_REQUEST:
            customized_response['message'] = 'Validation failed for request payload.'

        response.data = customized_response
        return response

    # Uncaught 500 exceptions
    logger.error(f"Unhandled Exception: {exc}", exc_info=True)
    return Response(
        {
            'success': False,
            'message': 'Internal server error occurred.',
            'errors': {'detail': str(exc)}
        },
        status=status.HTTP_500_INTERNAL_SERVER_ERROR
    )
