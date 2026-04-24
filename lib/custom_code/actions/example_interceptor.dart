// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/api_requests/api_interceptor.dart';

class ExampleInterceptor extends FFApiInterceptor {
  @override
  Future<ApiCallOptions> onRequest({
    required ApiCallOptions options,
  }) async {
    // Get the token dynamically (e.g., from FFAppState, SharedPreferences, etc.)
    final token = FFAppState().token; // Replace with your token source

    // Add/modify headers
    final updatedHeaders = {
      ...options.headers, // Preserve existing headers
      'AuthorizationToken': 'Bearer $token', // Add dynamic token
      'X-Device-ID': 'some_device_id', // Optional: Add other dynamic headers
    };

    // Return updated options
    return options.copyWith(
      headers: updatedHeaders,
    );
  }

  @override
  Future<ApiCallResponse> onResponse({
    required ApiCallResponse response,
    required Future<ApiCallResponse> Function() retryFn,
  }) async {
    // Optional: Handle responses (e.g., refresh token on 401 errors)
    if (response.statusCode == 401) {
      // Example: Refresh token and retry
      await refreshToken();
      return retryFn();
    }
    return response;
  }

  // Helper function (example)
  Future<void> refreshToken() async {
    // Implement token refresh logic
  }
}
