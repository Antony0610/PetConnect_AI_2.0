import uuid
import logging

logger = logging.getLogger(__name__)

class OpenTelemetryTracingMiddleware:
    """
    Middleware injecting Trace ID, Span ID, and Correlation ID headers
    into every incoming request and outgoing response for end-to-end distributed tracing.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        trace_id = request.META.get('HTTP_X_TRACE_ID', str(uuid.uuid4()))
        span_id = request.META.get('HTTP_X_SPAN_ID', str(uuid.uuid4())[:16])
        correlation_id = request.META.get('HTTP_X_CORRELATION_ID', trace_id)

        request.trace_id = trace_id
        request.span_id = span_id
        request.correlation_id = correlation_id

        response = self.get_response(request)

        response['X-Trace-ID'] = trace_id
        response['X-Span-ID'] = span_id
        response['X-Correlation-ID'] = correlation_id
        return response
