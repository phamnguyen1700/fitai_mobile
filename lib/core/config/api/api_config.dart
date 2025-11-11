// ignore_for_file: constant_identifier_names

/// Environment configuration for API endpoints
class ApiConfig {
  // Environment flags
  static const bool IS_PRODUCTION = false; // Set to true for production
  static const bool USE_MOCK_API = false; // Set to true to use mock responses

  // Environment-specific URLs
  static const String PRODUCTION_URL = 'https://api.fitai.com';
  static const String DEVELOPMENT_URL = 'http://54.179.34.55:8081';
  static const String LOCAL_URL = 'http://localhost:8000';
  static const String MOCK_URL =
      'https://jsonplaceholder.typicode.com'; // For testing

  // Get the appropriate base URL based on environment
  static String get baseUrl {
    if (USE_MOCK_API) return MOCK_URL;
    if (IS_PRODUCTION) return PRODUCTION_URL;
    return DEVELOPMENT_URL;
  }

  // Feature flags
  static const bool ENABLE_LOGGING = true;
  static const bool ENABLE_ERROR_TRACKING = false;
  static const bool ENABLE_ANALYTICS = false;

  // Timeout configurations (in seconds)
  static const int CONNECT_TIMEOUT = 30;
  static const int RECEIVE_TIMEOUT = 30;
  static const int SEND_TIMEOUT = 30;

  // API version
  static const String API_VERSION = '/api';

  // Device info
  static const String DEFAULT_DEVICE_NAME = 'FitAI Mobile App';

  /// Get full API base URL with version
  static String get fullBaseUrl => baseUrl + API_VERSION;

  /// Print current configuration (for debugging)
  static void printConfiguration() {
    print('=== API Configuration ===');
    print('Environment: ${IS_PRODUCTION ? 'PRODUCTION' : 'DEVELOPMENT'}');
    print('Mock API: $USE_MOCK_API');
    print('Base URL: $baseUrl');
    print('Full URL: $fullBaseUrl');
    print('Logging: $ENABLE_LOGGING');
    print('========================');
  }
}
